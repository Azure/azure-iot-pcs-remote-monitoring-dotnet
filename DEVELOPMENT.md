Azure IoT Hub setup
===================

To work on Remote Monitoring you will need to setup some dependencies
first:

* Azure IoT Hub
* CosmosDb SQL (DocumentDb)

Azure IoT Hub setup
===================

The project includes some Bash scripts to help you with this setup:

* Create new IoT Hub: `./scripts/iothub/create-hub.sh`
* List existing hubs: `./scripts/iothub/list-hubs.sh`
* Show IoT Hub details (e.g. keys): `./scripts/iothub/show-hub.sh`

and in case you had multiple Azure subscriptions:

* Show subscriptions list: `./scripts/iothub/list-subscriptions.sh`
* Change current subscription: `./scripts/iothub/select-subscription.sh`

CosmosDb SQL (DocumentDb)
=========================

To setup CosmosDb you will need to use the Azure Portal.