#!/usr/bin/env bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
source "$DIR/.functions.sh"

main() {
    check_dependencies
    login

    header "Azure IoT Hubs in the current subscription"
    az iot hub list | jq '.[] | {name: .name, resourcegroup: .resourcegroup, location: .location, subscription: .subscriptionid}' | jq .
}

main
