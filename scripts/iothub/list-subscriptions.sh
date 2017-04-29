#!/usr/bin/env bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
source "$DIR/.functions.sh"

main() {
    check_dependencies
    login

    header "Azure subscriptions"
    azure account list
    #az account list | jq '.[] | {name: .name, id: .id, current: .isDefault}' | jq .
}

main
