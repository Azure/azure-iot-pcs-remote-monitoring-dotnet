[![Build][build-badge]][build-url]
[![Issues][issues-badge]][issues-url]
[![Gitter][gitter-badge]][gitter-url]

Pre-configured solution for Remote Monitoring with Azure IoT
============================================================

This solution is currently in preview. This is an end to end solution that 
offers a rich set of IoT features, but there are known bugs (please see the 
Issue lists!) and there will be a number of new features coming up as we move 
towards General Availability.  Please see our Issues list in this repo (and in any
submodules) and feel free to add or comment with what you think we should 
work on.  Please also feel free to do the work and submit PRs :).

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

The easiest way to get started with Remote Monitoring is to deploy the running 
application to your Azure subscription through the command line interface 
[CLI](https://github.com/Azure/pcs-cli). Deployment instructions for the CLI 
are in the CLI repository.  These instructions will show you how to deploy 
all Remote Monitoring resources, with seed data, and see a running solution.  
You can then customize, extend, or replace the components of the system to 
meet your needs.  The [Developer Reference Guide](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/wiki/Developer-Reference-Guide) 
will facilitate customization by showing how to replace the containers deployed
by the CLI with your own.

To run Remote Monitoring on your local machine:
1. Clone the repo with:
   `git clone --recursive https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet`
2. Install Docker: https://www.docker.com
3. Create your IoT Hub either using the Azure Portal or by executing the IoT
   Hub creation helper script in the repository:
   [scripts/iothub/create-hub.sh](scripts/iothub/create-hub.sh)
4. Create required environment variables: {TODO - need a script for this}
5. Run the local deployment script: {TODO}

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
[gitter-badge]: https://img.shields.io/gitter/room/azure/iot-solutions.js.svg
[gitter-url]: https://gitter.im/Azure/iot-solutions
