#!/usr/bin/env bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
source "$DIR/.functions.sh"

SUBSCRIPTION_ID="$1"

check_input() {
    if [[ -z "$SUBSCRIPTION_ID" ]]; then
        announce "Usage: ./select-subscription.sh SUBSCRIPTION_ID"
        echo "Use './list-subscriptions.sh' to see the list of subscriptions."
    fi
}

main() {
    check_input
    check_dependencies
    login

    if [[ ! -z "$SUBSCRIPTION_ID" ]]; then
        header "Changing current subscription"
        #az account set --subscription "$SUBSCRIPTION_ID"
        azure account set "$SUBSCRIPTION_ID"
    else
        select_subscription
    fi
}

main
