[![Build][build-badge]][build-url]
[![Issues][issues-badge]][issues-url]
[![Gitter][gitter-badge]][gitter-url]

Pre-configured solution for Remote Monitoring with Azure IoT
============================================================

This is the "top level" repo for the Azure IoT PCS Remote Monitoring solution.
This repository contains submodules for each .NET microservice and the
React Web UI project.  It also contains instructions and scripts on how to get
remote monitoring running locally and in your Azure cloud subscription.  Each
microservice is built to run standalone - to view and use a microservice
independently click on a microservice submodule and view the readme.md for it.

Overview
========

Remote Monitoring is an end to end solution that showcases how a remote
monitoring IoT solution can be built and deployed for Azure IoT.  The
solution implements a number of uses cases including: registering devices,
sending telemetry from devices, creating rules and specifying alarms
for telemetry, sending commands to devices (e.g. reboot).  Remote Monitoring
can be deployed and run local or in the cloud.  When run local cloud access
must be available so as to allow access to required cloud resources, e.g.
the IoT Hub.

Remote Monitoring uses Docker containers to host microservices and the
React UI.  Microservices allow communication through REST/HTTP.  When running
locally microservices can also be executed inside an IDE (Visual Studio, VS
Code, etc.).  When running in the cloud the microservices are hosted using
Azure Container Service (ACS) and Kubernetes as the Container Orchestrator.

How to use it
=============

To run Remote Monitoring on your local machine:
1. Clone the repo with:
   `git clone --recursive https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet`
2. Install Docker: https://www.docker.com
3. Create your IoT Hub either using the Azure Portal or by executing the IoT
   Hub creation helper script in the repository:
   [scripts/iothub/create-hub.sh](scripts/iothub/create-hub.sh)
4. Create required environment variables: {TODO - need a script for this}
5. Run the local deployment script: {TODO}

To run Remote Monitoring in your cloud subscription: {TODO}

Configuration
=============

Remote Monitoring uses environment variables for required configuration.
Required environment variables are:
- Name: PCS_IOTHUB_CONN_STRING
  Value: <Your IoT Hub Connection String>
- Name: PCS_IOTHUBREACT_CHECKPOINT_COSMOSDBSQL_CONNSTRING
  Value: <Your DocumentDb Connection String>
- {TODO - TCP ports for each msvc}


Other documents
===============

* [Contributing](CONTRIBUTING.md)
* [Development setup](DEVELOPMENT.md)


[build-badge]: https://img.shields.io/travis/Azure/azure-iot-pcs-remote-monitoring-dotnet.svg
[build-url]: https://travis-ci.org/Azure/azure-iot-pcs-remote-monitoring-dotnet
[issues-badge]: https://img.shields.io/github/issues/azure/azure-iot-pcs-remote-monitoring-dotnet.svg
[issues-url]: https://github.com/azure/azure-iot-pcs-remote-monitoring-dotnet/issues
[gitter-badge]: https://img.shields.io/gitter/room/azure/iot-pcs.js.svg
[gitter-url]: https://gitter.im/azure/iot-pcs
