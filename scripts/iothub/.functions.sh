COL_NO="\033[0m" # no color
COL_ERR="\033[1;31m" # light red
COL_H1="\033[1;33m" # yellow
COL_H2="\033[1;36m" # light cyan

header() {
    echo -e "${COL_H1}\n### $1 ${COL_NO}\n"
}

announce() {
    echo -e "${COL_H2}\n> $1 ${COL_NO}"
}

error() {
    echo -e "${COL_ERR}$1 ${COL_NO}"
}

error_and_exit() {
    echo -e "${COL_ERR}$1 ${COL_NO}"
    exit -1
}

user_exit() {
    echo -e "${COL_H2}\nStopped${COL_NO}"
    exit -2
}

check_dependencies() {
    TEST=$(which jq)
    if [[ -z "$TEST" ]]; then
        error "ERROR: 'jq' command not found. Install 'jq' first."
        error "with debian/ubuntu: apt-get install jq"
        error "with homebrew: brew install jq"
        exit -1
    fi

    TEST=$(which az)
    if [[ -z "$TEST" ]]; then
        error "ERROR: 'az' command not found. Install Azure CLI first."
        error "how to: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        error "with bash: curl -L https://aka.ms/InstallAzureCli | bash"
        exit -1
    fi

    TEST=$(which azure)
    if [[ -z "$TEST" ]]; then
        error "ERROR: 'azure' command not found. Install Azure cross-platform CLI first."
        error "with npm: npm install -g azure-cli"
        error "with homebrew: brew install azure-cli"
        exit -1
    fi
}

login() {
    TEST=$(az account list-locations 2>&1)
    if [[ "$?" != "0" ]]; then
        header "Azure authentication required"
        announce "After the authentication, this machine will be allowed to execute Azure commands on your behalf."
        announce "At any moment, you can use 'az logout' to close the authenticated session."
        echo

        az login
    fi
}

show_hub_details() {
    header "Azure IoT Hub details"

    DATA=$(az iot hub show --name "$2")

    echo "Name:                   $(echo $DATA | jq .name)"
    echo "Location:               $(echo $DATA | jq .location)"
    echo "SKU:                    $(echo $DATA | jq .sku.name)"
    echo "Units:                  $(echo $DATA | jq .sku.capacity)"

    echo "D2C Events endpoint:    $(echo $DATA | jq .properties.eventHubEndpoints.events.endpoint)"
    echo "D2C Partitions:         $(echo $DATA | jq .properties.eventHubEndpoints.events.partitionCount)"
    echo "D2C Events retention:   $(echo $DATA | jq .properties.eventHubEndpoints.events.retentionTimeInDays) days"

    echo "C2D Hostname:           $(echo $DATA | jq .properties.hostName)"
    echo "C2D Messages retention: $(echo $DATA | jq .properties.cloudToDevice.defaultTtlAsIso8601)"

    header "Quota"

    DATA=$(az iot hub show-quota-metrics --name "$2")
    echo "Messages: $(echo $DATA | jq '.[0].currentValue')/$(echo $DATA | jq '.[0].maxValue')"
    echo "Devices:  $(echo $DATA | jq '.[1].currentValue')/$(echo $DATA | jq '.[1].maxValue')"

    header "Azure IoT Hub keys"

    azure iothub key list "$1" "$2"
}

do_select_subscription() {
    header "Select subscription"

    azure account list

    echo
    TEMP=""
    while [[ -z "$TEMP" ]]; do
        echo -n "Enter subscription ID: "
        read TEMP
    done

    azure account set "$TEMP" || error_and_exit "Unable to select the requested subscription."
}

select_subscription() {
    header "Azure subscription"

    echo -e "Reading account...\n"
    TEST0=$(az account list)
    TEST1=$(echo $TEST0 | grep isDefault|grep true)
    if [[ -z "$TEST1" ]]; then
        echo "No subscription selected"
        do_select_subscription
    else
        echo "Current subscription:"
        echo $TEST0 | jq '.[] | select(.isDefault == true)' | jq '{name: .name, id: .id, user: .user.name}' | jq .
        echo -e "\nDo you want to change to a different subscription?"
        PS3=">> "
        select YNC in No Yes; do
            case $YNC in
                Yes ) do_select_subscription; break;;
                No ) break;;
            esac
        done
    fi
}
