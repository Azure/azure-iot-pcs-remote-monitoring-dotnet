#!/usr/bin/env bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
source "$DIR/.functions.sh"

RESOURCE_GROUP="$1"
HUB_NAME="$2"

check_input() {
    if [[ -z "$RESOURCE_GROUP" || -z "$HUB_NAME" ]]; then
        announce "Usage: ./show-hub.sh RESOURCE_GROUP HUB_NAME"
        echo "Use './list-hubs.sh' to see the list of hubs."
        exit -1
    fi
}

main() {
    check_input
    check_dependencies
    login
    show_hub_details "$RESOURCE_GROUP" "$HUB_NAME"
}

main
