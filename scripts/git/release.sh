
#!/usr/bin/env bash -e
VERSION=$1
ACCESS_TOKEN=$2
DESCRIPTION=$3
PRE_RELEASE=$4
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

check_input() {
    if [ -n "$VERSION" ]; then
        echo -e "${RED}Version is required parameter${NC}"
        exit 1
    elif [ -n "$ACCESS_TOKEN" ]; then
        echo -e "${RED}Acess_token is required parameter${NC}"
        exit 1
    elif [ -n "$DESCRIPTION" ]; then
        echo -e "${RED}Description is required parameter${NC}"
        exit 1
    fi
}

tag_repo() {
    SUB_MODULE=$1
    REPO_NAME=$2
    DESCRIPTION=$3
    if [[ ! -n "$VERSION" ]]; then
        echo "${RED}Version number is required in format 1.0.0 or 1.0.0-preview${NC}"
        exit 1
    fi

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
    git push https://$ACCESS_TOKEN@github.com/Azure/$REPO_NAME.git $VERSION

    DATA="{
        \"tag_name\": \"$VERSION\",
        \"target_commitish\": \"master\",
        \"name\": \"$VERSION\",
        \"body\": \"$DESCRIPTION\",
        \"draft\": false,
        \"prerelease\": $PRE_RELEASE
    }"

    curl -X POST --data "$DATA" https://api.github.com/repos/Azure/$REPO_NAME/releases?access_token=$ACCESS_TOKEN

    # Building docker containers
    if [ -n "$SUB_MODULE" ]; then
        echo "Building $REPO_NAME..."
        /bin/bash $APP_HOME$SUB_MODULE/scripts/docker/build
        echo
    else
        echo "Building reverse_proxy..."
        cd $APP_HOME/reverse-proxy
        /bin/bash build
    fi

    echo
    echo -e "${CYAN}====================================     End: Tagging $REPO_NAME repo     ====================================${NC}"
    echo
}

stop_running_docker_containers() {
    echo -e "${CYAN}=== Stop all running containers${NC}"

    list=$(docker ps -aq)
    if [ -n "$list" ]; then
        docker rm -f $list
    fi
}

delete_temporary_docker_images() {
    echo -e "${CYAN}=== Delete temporary Docker images${NC}"

    list=$(docker images | grep '<none>'| tr -s ' ' | cut -d' ' -f 3)
    if [ -n "$list" ]; then
        docker rmi $list
    fi
    list=$(docker images | grep ' testing '| tr -s ' ' | cut -d' ' -f 3)
    if [ -n "$list" ]; then
        docker rmi $list
    fi
}

tag_docker_images() {
    # stop_running_docker_containers
    # delete_temporary_docker_images

    echo -e "${CYAN}====================================     Start: Tag image with $VERSION     ====================================${NC}"

    echo -e "Tagging azureiotpcs/remote-monitoring-nginx:$VERSION"
    docker tag azureiotpcs/remote-monitoring-nginx:testing      azureiotpcs/remote-monitoring-nginx:$VERSION

    echo -e "Tagging azureiotpcs/pcs-remote-monitoring-webui:$VERSION"
    docker tag azureiotpcs/pcs-remote-monitoring-webui:testing  azureiotpcs/pcs-remote-monitoring-webui:$VERSION

    # Dotnet microservices containers
    echo -e "Tagging azureiotpcs/device-simulation-dotnet:$VERSION"
    docker tag azureiotpcs/device-simulation-dotnet:testing     azureiotpcs/device-simulation-dotnet:$VERSION
    echo -e "Tagging azureiotpcs/telemetry-dotnet:$VERSION"
    docker tag azureiotpcs/telemetry-dotnet:testing             azureiotpcs/telemetry-dotnet:$VERSION
    echo -e "Tagging azureiotpcs/iothub-manager-dotnet:$VERSION"
    docker tag azureiotpcs/iothub-manager-dotnet:testing        azureiotpcs/iothub-manager-dotnet:$VERSION
    echo -e "Tagging azureiotpcs/pcs-auth-dotnet:$VERSION"
    docker tag azureiotpcs/pcs-auth-dotnet:testing              azureiotpcs/pcs-auth-dotnet:$VERSION
    echo -e "Tagging azureiotpcs/pcs-config-dotnet:$VERSION"
    docker tag azureiotpcs/pcs-config-dotnet:testing            azureiotpcs/pcs-config-dotnet:$VERSION
    echo -e "Tagging azureiotpcs/pcs-storage-adapter-dotnet:$VERSION"
    docker tag azureiotpcs/pcs-storage-adapter-dotnet:testing   azureiotpcs/pcs-storage-adapter-dotnet:$VERSION
    echo -e "Tagging azureiotpcs/telemetry-agent-dotnet:$VERSION"
    docker tag azureiotpcs/telemetry-agent-dotnet:testing       azureiotpcs/telemetry-agent-dotnet:$VERSION

    # Java microservices containers
    # echo -e "Tagging azureiotpcs/telemetry-java:$VERSION"
    # docker tag azureiotpcsdev/telemetry-java               azureiotpcs/telemetry-java:$VERSION
    # echo -e "Tagging azureiotpcs/iothub-manager-java:$VERSION"
    # docker tag azureiotpcsdev/iothub-manager-java          azureiotpcs/iothub-manager-java:$VERSION
    # echo -e "Tagging azureiotpcs/pcs-config-java:$VERSION"
    # docker tag azureiotpcsdev/pcs-config-java              azureiotpcs/pcs-config-java:$VERSION
    # echo -e "Tagging azureiotpcs/pcs-storage-adapter-java:$VERSION"
    # docker tag azureiotpcsdev/pcs-storage-adapter-java     azureiotpcs/pcs-storage-adapter-java:$VERSION
    # echo -e "Tagging azureiotpcs/telemetry-agent-java:$VERSION"
    # docker tag azureiotpcsdev/telemetry-agent-java         azureiotpcs/telemetry-agent-java:$VERSION

    # echo -e "${CYAN}=== Delete 'testing' tag${NC}"
    # docker rmi azureiotpcsdev/remote-monitoring-nginx
    # docker rmi azureiotpcsdev/pcs-remote-monitoring-webui

    # docker rmi azureiotpcsdev/device-simulation-dotnet
    # docker rmi azureiotpcsdev/telemetry-dotnet
    # docker rmi azureiotpcsdev/iothub-manager-dotnet
    # docker rmi azureiotpcsdev/pcs-auth-dotnet
    # docker rmi azureiotpcsdev/pcs-config-dotnet
    # docker rmi azureiotpcsdev/pcs-storage-adapter-dotnet
    # docker rmi azureiotpcsdev/telemetry-agent-dotnet

    # docker rmi azureiotpcsdev/telemetry-java
    # docker rmi azureiotpcsdev/iothub-manager-java
    # docker rmi azureiotpcsdev/pcs-config-java
    # docker rmi azureiotpcsdev/pcs-storage-adapter-java
    # docker rmi azureiotpcsdev/telemetry-agent-java

    echo -e "${CYAN}====================================     End: Tag image with $VERSION     ====================================${NC}"
}

# publish_azureiotpcs_docker_images() {
#     echo
#     echo -e "${CYAN}====================================     Start: Publishing images with $VERSION     ====================================${NC}"
#     echo
#     docker push azureiotpcs/remote-monitoring-nginx:$VERSION
#     docker push azureiotpcs/pcs-remote-monitoring-webui:$VERSION

#     docker push azureiotpcs/device-simulation-dotnet:$VERSION
#     docker push azureiotpcs/telemetry-dotnet:$VERSION
#     docker push azureiotpcs/iothub-manager-dotnet:$VERSION
#     docker push azureiotpcs/pcs-auth-dotnet:$VERSION
#     docker push azureiotpcs/pcs-config-dotnet:$VERSION
#     docker push azureiotpcs/pcs-storage-adapter-dotnet:$VERSION
#     docker push azureiotpcs/telemetry-agent-dotnet:$VERSION

#     docker push azureiotpcs/telemetry-java:$VERSION
#     docker push azureiotpcs/iothub-manager-java:$VERSION
#     docker push azureiotpcs/pcs-config-java:$VERSION
#     docker push azureiotpcs/pcs-storage-adapter-java:$VERSION
#     docker push azureiotpcs/telemetry-agent-java:$VERSION

#     echo
#     echo -e "${CYAN}====================================     End: Publishing images with $VERSION     ====================================${NC}"
#     echo
# }

pull_azureiotpcsdev_docker_images() {
    echo
    echo -e "${CYAN}====================================     Start: Pulling latest images from dev     ====================================${NC}"
    echo

    # docker pull azureiotpcsdev/remote-monitoring-nginx
    docker pull azureiotpcsdev/pcs-remote-monitoring-webui

    # docker pull azureiotpcsdev/device-simulation-dotnet
    # docker pull azureiotpcsdev/telemetry-dotnet
    # docker pull azureiotpcsdev/iothub-manager-dotnet
    # docker pull azureiotpcsdev/pcs-auth-dotnet
    # docker pull azureiotpcsdev/pcs-config-dotnet
    # docker pull azureiotpcsdev/pcs-storage-adapter-dotnet
    # docker pull azureiotpcsdev/telemetry-agent-dotnet

    # docker pull azureiotpcsdev/telemetry-java
    # docker pull azureiotpcsdev/iothub-manager-java
    # docker pull azureiotpcsdev/pcs-config-java
    # docker pull azureiotpcsdev/pcs-storage-adapter-java
    # docker pull azureiotpcsdev/telemetry-agent-java

    echo
    echo -e "${CYAN}====================================     End: Pulling latest images from dev      ====================================${NC}"
    echo
}

check_input

# DOTNET Microservices
tag_repo auth               pcs-auth-dotnet
tag_repo config             pcs-config-dotnet
tag_repo device-simulation  device-simulation-dotnet
tag_repo iothub-manager     iothub-manager-dotnet
tag_repo storage-adapter    pcs-storage-adapter-dotnet
tag_repo telemetry          device-telemetry-dotnet
tag_repo telemetry-agent    telemetry-agent-dotnet
tag_repo webui              pcs-remote-monitoring-webui

# PCS CLI
tag_repo cli                pcs-cli

# Top Level repo
tag_repo ""                 azure-iot-pcs-remote-monitoring-dotnet $DESCRIPTION

# pull_azureiotpcsdev_docker_images
tag_docker_images
# publish_azureiotpcs_docker_images

set +e