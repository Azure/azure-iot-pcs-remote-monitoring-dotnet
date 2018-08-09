#!/usr/bin/env bash
# Copyright (c) Microsoft. All rights reserved.
# Note: Windows Bash doesn't support shebang extra params
set -e

while [ "$#" -gt 0 ]; do
    case "$1" in
        --version)                      VERSION="$2" ;;
        --git_access_token)             GIT_ACCESS_TOKEN="$2" ;;
        --docker_user)                  DOCKER_USER="$2" ;;
        --docker_pwd)                   DOCKER_PWD="$2" ;;
        --from_docker_namespace)        FROM_DOCKER_NAMESPACE="$2" ;;
        --to_docker_namespace)          TO_DOCKER_NAMESPACE="$2" ;;
        --docker_tag)                   DOCKER_TAG="$2" ;;
        --description)                  DESCRIPTION="$2" ;;
        --pre_release)                  PRE_RELEASE="$2" ;;
        --local)                        LOCAL="$2" ;;
    esac
    shift
done

# Set default values for optional parameters
FROM_DOCKER_NAMESPACE=${FROM_DOCKER_NAMESPACE:-azureiotpcs}
TO_DOCKER_NAMESPACE=${TO_DOCKER_NAMESPACE:-azureiotpcs}
DOCKER_TAG=${DOCKER_TAG:-testing}
DESCRIPTION=${DESCRIPTION:-''}
PRE_RELEASE=${PRE_RELEASE:-false}
LOCAL=${LOCAL:-''}

APP_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && cd .. && pwd )/"

NC="\033[0m" # no color
CYAN="\033[1;36m" # light cyan
YELLOW="\033[1;33m" # yellow
RED="\033[1;31m" # light red

failed() {
    SUB_MODULE=$1
    echo -e "${RED}Cannot find directory $SUB_MODULE${NC}"
    exit 1
}

usage() {
    echo -e "${RED}ERROR: $1 is a required option${NC}"
    echo "Usage: ./release"
    echo -e 'Options:
        --version               Version of this release (required)
        --git_access_token      Git access token to push tag (required)
        --docker_user           Username to login docker hub (required)
        --docker_pwd            Password to login docker hub (required)
        --from_docker_namespace Source namespace of docker image (default:azureiotpcs)
        --to_docker_namespace   Target namespace of docker image (default:azureiotpcs)
        --docker_tag            Source tag of docker image (default:testing)
        --description           Description of this release (default:empty)
        --pre_release           Publish as non-production release on github (default:false)
        --local                 Clean up the local repo at first (default:empty)
        '
    exit 1
}

check_input() {
    if [ ! -n "$VERSION" ]; then
        usage "version"
    fi
    if [ ! -n "$GIT_ACCESS_TOKEN" ]; then
        usage "git_access_token"
    fi
    if [ ! -n "$DOCKER_USER" ]; then
        usage "docker_user"
    fi
    if [ ! -n "$DOCKER_PWD" ]; then
        usage "docker_pwd"
    fi
    echo $DOCKER_PWD | docker login -u $DOCKER_USER --password-stdin
}

tag_release_repo() {
    SUB_MODULE=$1
    REPO_NAME=$2
    DESCRIPTION=$3

    echo
    echo -e "${CYAN}====================================     Start: Tagging the $REPO_NAME repo     ====================================${NC}"
    echo
    echo -e "Current working directory ${CYAN}$APP_HOME$SUB_MODULE${NC}"
    echo
    cd $APP_HOME$SUB_MODULE || failed $SUB_MODULE

    if [ -n "$LOCAL" ]; then
        echo "Cleaning the repo"
        git reset --hard origin/master
        git clean -xdf
    fi
    git checkout master
    git pull --all --prune
    git fetch --tags

    git tag --force $VERSION
    git push https://$GIT_ACCESS_TOKEN@github.com/Azure/$REPO_NAME.git $VERSION

    echo
    echo -e "${CYAN}====================================     End: Tagging $REPO_NAME repo     ====================================${NC}"
    echo

    echo
    echo -e "${CYAN}====================================     Start: Release for $REPO_NAME     ====================================${NC}"
    echo

    # For documentation https://help.github.com/articles/creating-releases/
    DATA="{
        \"tag_name\": \"$VERSION\",
        \"target_commitish\": \"master\",
        \"name\": \"$VERSION\",
        \"body\": \"$DESCRIPTION\",
        \"draft\": false,
        \"prerelease\": $PRE_RELEASE
    }"

    curl -X POST --data "$DATA" https://api.github.com/repos/Azure/$REPO_NAME/releases?access_token=$GIT_ACCESS_TOKEN
    echo
    echo -e "${CYAN}====================================     End: Release for $REPO_NAME     ====================================${NC}"
    echo
}

publish_docker_containers()
{
    DOCKER_CONTAINER_NAME=$1
    SUB_MODULE=$2

    if [ "$SUB_MODULE" == "reverse-proxy" ]; then
        cd $APP_HOME$SUB_MODULE || failed $SUB_MODULE
        if [ -n "$LOCAL" ]; then
            echo "Cleaning the repo"
            git reset --hard origin/master
            git clean -xdf
        fi
        git checkout master
        git pull --all --prune

        echo
        echo -e "${CYAN}====================================     Start: Building $DOCKER_CONTAINER_NAME     ====================================${NC}"
        echo

        BUILD_PATH="build"
        # Building docker containers
        /bin/bash $APP_HOME$SUB_MODULE/$BUILD_PATH
        
        echo
        echo -e "${CYAN}====================================     End: Building $DOCKER_CONTAINER_NAME     ====================================${NC}"
        echo
    else
        # Pull containers
        echo -e "${CYAN}Pulling $FROM_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$DOCKER_TAG${NC}"
        echo
        docker pull $FROM_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$DOCKER_TAG
    fi
    
    # Tag containers
    echo -e "${CYAN}Tagging $FROM_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$DOCKER_TAG ==> $TO_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$VERSION${NC}"
    echo
    docker tag $FROM_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$DOCKER_TAG  $TO_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$VERSION

    # Push containers
    echo -e "${CYAN}Pusing container $TO_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$VERSION${NC}"
    docker push $TO_DOCKER_NAMESPACE/$DOCKER_CONTAINER_NAME:$VERSION
}

check_input

# Publish DOTNET Microservices docker containers
publish_docker_containers pcs-auth-dotnet
publish_docker_containers pcs-config-dotnet
publish_docker_containers device-simulation-dotnet
publish_docker_containers iothub-manager-dotnet
publish_docker_containers pcs-storage-adapter-dotnet
publish_docker_containers telemetry-dotnet
publish_docker_containers asa-manager-dotnet
publish_docker_containers pcs-remote-monitoring-webui
publish_docker_containers pcs-diagnostics-dotnet
# Top Level repo
publish_docker_containers remote-monitoring-nginx       reverse-proxy

# # Release and Tag all the repositories with latest version
tag_release_repo          webui                           pcs-remote-monitoring-webui
tag_release_repo          services                        remote-monitoring-services-dotnet
# PCS CLI
tag_release_repo          cli                             pcs-cli
# Top Level repo
tag_release_repo          ""                              azure-iot-pcs-remote-monitoring-dotnet $DESCRIPTION

set +e
