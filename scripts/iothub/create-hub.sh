#!/usr/bin/env bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
source "$DIR/.functions.sh"

if [[ "$1" == "-a" || "$1" == "--all-options" ]]; then
    ADVANCED=true
else
    ADVANCED=false
fi

SUBSCRIPTION=""
HUB_NAME=""
RESOURCE_GROUP=""
NEW_RESOURCE_GROUP="false"
LOCATION=""
SKU=""
MAXUNITS=""
UNITS=""
D2C_PARTITIONS=""
D2C_TTL=""
C2D_ATTEMPTS=""
C2D_TTL=""
C2D_FEEDBACK_LOCK=""
C2D_FEEDBACK_TTL=""
C2D_FEEDBACK_ATTEMPTS=""

ask_hub_name() {
    header "New Azure IoT Hub"
    HUB_NAME=""

    while [[ -z "$HUB_NAME" ]]; do
        echo -n "Enter IoT Hub name: "
        read HUB_NAME
    done
}

select_resource_group() {
    header "Resource group"

    echo "Existing resource groups"

    azure group list

    echo
    announce "You can re-use an existing group or enter a new name to create a new resource group."
    echo
    RESOURCE_GROUP=""
    while [[ -z "$RESOURCE_GROUP" ]]; do
        echo -n "Enter resource group name: "
        read RESOURCE_GROUP
    done

    NEW_RESOURCE_GROUP="false"
    TEST=$(azure group list | grep -i "$RESOURCE_GROUP")
    if [[ -z "$TEST" ]]; then
        NEW_RESOURCE_GROUP="true"
    fi
}

select_location() {
    header "Azure region"

    # TODO: az account list-locations + filter for IoT Hub
    echo -e "Select the location where to create the hub:"
    PS3=">> "
    select LOCATION in eastus westus westus2 westcentralus northeurope westeurope eastasia southeastasia japaneast japanwest australiaeast australiasoutheast; do
        break;
    done
}

select_sku_and_units() {
    header "Pricing and Scale Tier"

    echo "F1: 8k messages/unit/day (free)"
    echo "S1: 400k messages/unit/day"
    echo "S2: 6M messages/unit/day"
    echo "S3: 300M messages/unit/day"

    echo -e "\nSelect pricing and scale:"
    PS3=">> "
    select SKU in F1 S1 S2 S3; do
        case $SKU in
            F1 ) MAXUNITS=1; break;;
            S1 ) MAXUNITS=200; break;;
            S2 ) MAXUNITS=200; break;;
            S3 ) MAXUNITS=10; break;;
        esac
    done

    UNITS="1"
    if [[ "$SKU" != "F1" ]]; then
        echo -n -e "\nHow many units? (1..${MAXUNITS}) [${UNITS}]: "
        read TEMP
        if [[ ! -z "$TEMP" ]]; then UNITS="$TEMP"; fi
    fi
}

ask_d2c_partitions() {
    D2C_PARTITIONS="2" # 2..128 (2 for F1)
    if [[ "$ADVANCED" == "false" ]]; then return 0; fi

    if [[ "$SKU" != "F1" ]]; then
        echo -n "How many partitions? (1..128) [${D2C_PARTITIONS}]: "
        read TEMP
        if [[ ! -z "$TEMP" ]]; then D2C_PARTITIONS="$TEMP"; fi
    fi
}

ask_d2c_retention() {
    D2C_TTL="1" # 1..7 days
    if [[ "$ADVANCED" == "false" ]]; then return 0; fi

    echo -n "How many days before device-to-cloud messages expire? (1..7) [${D2C_TTL}]: "
    read TEMP
    if [[ ! -z "$TEMP" ]]; then D2C_TTL="$TEMP"; fi
}

ask_c2d_attempts() {
    C2D_ATTEMPTS="10" # 1..100 count
    if [[ "$ADVANCED" == "false" ]]; then return 0; fi

    echo -n "How many attempts to deliver a cloud-to-device message? (1..100) [${C2D_ATTEMPTS}]: "
    read TEMP
    if [[ ! -z "$TEMP" ]]; then C2D_ATTEMPTS="$TEMP"; fi
}

ask_c2d_ttl() {
    # PnYnMnDTnHnMnS
    C2D_TTL="PT1H" # 1 min .. 2 days
    if [[ "$ADVANCED" == "false" ]]; then return 0; fi

    echo -n "How long before cloud-to-device messages expire? (ISO8601: 1 min .. 2 days) [${C2D_TTL}]: "
    read TEMP
    if [[ ! -z "$TEMP" ]]; then C2D_TTL="$TEMP"; fi
}

ask_c2d_feedback_lock() {
    # PnYnMnDTnHnMnS
    C2D_FEEDBACK_LOCK="PT1M" # 5 secs .. 5 mins
    if [[ "$ADVANCED" == "false" ]]; then return 0; fi

    echo -n "How long before cloud-to-device feedback messages lock expire? (ISO8601: 5 secs .. 5 mins) [${C2D_FEEDBACK_LOCK}]: "
    read TEMP
    if [[ ! -z "$TEMP" ]]; then C2D_FEEDBACK_LOCK="$TEMP"; fi
}

ask_c2d_feedback_ttl() {
    # PnYnMnDTnHnMnS
    C2D_FEEDBACK_TTL="PT1M" # 1 min .. 2days
    if [[ "$ADVANCED" == "false" ]]; then return 0; fi

    echo -n "How long before cloud-to-device feedback messages expire? (ISO8601: 1 min .. 2days) [${C2D_FEEDBACK_TTL}]: "
    read TEMP
    if [[ ! -z "$TEMP" ]]; then C2D_FEEDBACK_TTL="$TEMP"; fi
}

ask_c2d_feedback_attempts() {
    C2D_FEEDBACK_ATTEMPTS="1" # 1..100 count
    if [[ "$ADVANCED" == "false" ]]; then return 0; fi

    echo -n "How many attempts to deliver a cloud-to-device feedback message? (1..100) [${C2D_FEEDBACK_ATTEMPTS}]: "
    read TEMP
    if [[ ! -z "$TEMP" ]]; then C2D_FEEDBACK_ATTEMPTS="$TEMP"; fi
}

advanced() {
    if [[ "$ADVANCED" == "true" ]]; then
        header "Other settings";
    else
        announce "Using default settings. Use '--all-options' to manually set all the hub options."
    fi

    ask_d2c_partitions
    ask_d2c_retention
    ask_c2d_attempts
    ask_c2d_ttl
    ask_c2d_feedback_lock
    ask_c2d_feedback_ttl
    ask_c2d_feedback_attempts
}

create_hub() {
    header "Create '$HUB_NAME' in '$LOCATION'"

    if [[ $NEW_RESOURCE_GROUP == "true" ]]; then
        azure group create "$RESOURCE_GROUP" "$LOCATION" || error_and_exit "Unable to create resource group."
    fi

    azure iothub create "$RESOURCE_GROUP" "$HUB_NAME" "$LOCATION" "$SKU" "$UNITS" \
        --enable-dm \
        --d2c-partitions "$D2C_PARTITIONS" \
        --d2c-retention-time-in-days "$D2C_TTL" \
        --c2d-max-delivery-count "$C2D_ATTEMPTS" \
        --c2d-ttl "$C2D_TTL" \
        --feedback-lock-duration "$C2D_FEEDBACK_LOCK" \
        --feedback-ttl "$C2D_FEEDBACK_TTL" \
        --feedback-max-delivery-count "$C2D_FEEDBACK_ATTEMPTS" \
        || error_and_exit "Unable to create IoT Hub"
}

confirm() {
    header "Summary"

    echo "Azure IoT Hub name:             ${HUB_NAME}"
    echo "Resource group name:            ${RESOURCE_GROUP} (new: ${NEW_RESOURCE_GROUP})"
    echo "Azure region:                   ${LOCATION}"
    echo "Pricing and Scaling SKU         ${SKU}"
    echo "Capacity units:                 ${UNITS}"
    echo "D2C events partitions:          ${D2C_PARTITIONS}"
    echo "D2C events TTL:                 ${D2C_TTL} days"
    echo "C2D messages TTL:               ${C2D_TTL}"
    echo "C2D message delivery attempts:  ${C2D_ATTEMPTS}"
    echo "C2D feedback TTL:               ${C2D_FEEDBACK_TTL}"
    echo "C2D feedback delivery attempts: ${C2D_FEEDBACK_ATTEMPTS}"
    echo "C2D feedback lock TTL:          ${C2D_FEEDBACK_LOCK}"
    echo

    echo "Proceed?"
    PS3=">> "
    select SKU in Yes No; do
        case $SKU in
            No ) user_exit;;
            Yes ) break;;
        esac
    done
}

main() {
    check_dependencies
    login

    ask_hub_name
    select_subscription
    select_resource_group
    select_location
    select_sku_and_units
    advanced
    confirm
    create_hub
    show_hub_details "$RESOURCE_GROUP" "$HUB_NAME"

    announce "Tip: to show the hub details, run: ./show-hub.sh $RESOURCE_GROUP $HUB_NAME"
}

main
