[![Build status][build-badge]][build-url]
[![Issues][issues-badge]][issues-url]
[![Gitter][gitter-badge]][gitter-url]

Remote Monitoring Solution with Azure IoT
========
<div align="center">
<img src="https://user-images.githubusercontent.com/33666587/39657377-33612fc8-4fbc-11e8-98a8-58906236238a.png" width="600" height="auto"/>
</div>

Overview
========
> There is a Java version of this repo available [here](https://github.com/Azure/azure-iot-pcs-remote-monitoring-java)

Remote monitoring helps you get better visibility into your devices, assets, and
sensors wherever they happen to be located. You can collect and analyze real-time
device data using a remote monitoring solution that triggers automatic alerts and
actions — from remote diagnostics to maintenance requests. You can also command and
control your devices.

[Azure IoT Hub][iot-hub]
is a key building block of the remote monitoring solution. IoT Hub is a fully
managed service that enables reliable and secure bidirectional communications between
millions of IoT devices and a solution back end.

Check out the [Interactive Demo](http://www.microsoftazureiotsuite.com/demos/remotemonitoring)
for a detailed overview of features and use cases.

To get started you can follow along with the Getting Started for a command line deployment. You can also deploy using the web interface at https://www.azureiotsolutions.com.

### Documentation
See more documentation [here](https://docs.microsoft.com/azure/iot-suite/).

Getting Started
===============

## Deploy a solution
There are three ways to deploy a solution accelerator:
1) Deploy using the web interface using the instructions [here](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-deploy).
2) Deploy using the [command line](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-deploy-cli).
3) Deploy locally using instructions [here](https://docs.microsoft.com/azure/iot-accelerators/iot-accelerators-remote-monitoring-deploy-local).

Common Scenarios
================
## Create additional simulated devices
Once you have a solution up and running, you can [create additional simulated devices](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-test). You can then stop the default simulated devices by calling the simulation endpoint with the instructions [here](https://github.com/Azure/device-simulation-dotnet/wiki/%5BAPI-Specifications%5D-Simulations#stop-simulation).

## Connect a physical device!
By default, the solution once spun up uses simulated devices. You can start adding your
own devices with the instructions here: 
* [Connect a physical device](https://docs.microsoft.com/azure/iot-suite/iot-suite-connecting-devices-node)

## Customize the Web UI
You can find information about customizing the remote monitoring solution [here](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-customize).

Architecture Overview
=====================
![alt text](https://raw.githubusercontent.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/master/docs/architecture.png)

[Learn more](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-sample-walkthrough) about the Remote Monitoring architecture, including the use of microservices and Docker containers.

## Components
* [Remote Monitoring Web UI](https://github.com/Azure/pcs-remote-monitoring-webui)
* [Command Line Interface (CLI)](https://github.com/Azure/pcs-cli)
* [Microservices](https://github.com/Azure/remote-monitoring-services-dotnet)
* [Application Gateway (SSL Proxy WebApp)](https://github.com/Azure/reverse-proxy-dotnet)
* [API Gateway](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/tree/master/reverse-proxy)

How-to and Troubleshooting Resources
====================================
* [Developer Troubleshooting Guide](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/wiki/Developer-Troubleshooting-Guide)
* [Developer Reference Guide](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/wiki/Developer-Reference-Guide#running-all-pcs-microservices-locally)

Feedback
========
* If you have feedback, feature requests, or find a problem, you can create
  a new issue in the [GitHub Issues][issues-url]
* We also have a [User Voice](https://feedback.azure.com/forums/321918-azure-iot) channel to receive suggestions for features and future supported scenarios.

Contributing
============
Refer to our [contribution guidelines](docs/CONTRIBUTING.md). We love PRs!

License
=======
Copyright (c) Microsoft Corporation. All rights reserved.
Licensed under the [MIT](LICENSE) License.

[build-badge]: https://solutionaccelerators.visualstudio.com/RemoteMonitoring/_apis/build/status/Consolidated%20Repo
[build-url]: https://solutionaccelerators.visualstudio.com/RemoteMonitoring/_build/latest?definitionId=22
[issues-badge]: https://img.shields.io/github/issues/azure/azure-iot-pcs-remote-monitoring-dotnet.svg
[issues-url]: https://github.com/azure/azure-iot-pcs-remote-monitoring-dotnet/issues
[gitter-badge]: https://img.shields.io/gitter/room/azure/iot-solutions.js.svg
[gitter-url]: https://gitter.im/Azure/iot-solutions
[azure-active-directory]: https://azure.microsoft.com/services/active-directory
[iot-hub]: https://azure.microsoft.com/services/iot-hub
[cosmos-db]: https://azure.microsoft.com/services/cosmos-db
[container-service]: https://azure.microsoft.com/services/container-service
[storage-account]: https://docs.microsoft.com/azure/storage/common/storage-introduction#types-of-storage-accounts
[virtual-machines]: https://azure.microsoft.com/services/virtual-machines
[web-application]: https://azure.microsoft.com/services/app-service/web
