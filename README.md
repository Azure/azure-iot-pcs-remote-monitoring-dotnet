[![Build][build-badge]][build-url]
[![Issues][issues-badge]][issues-url]
[![Gitter][gitter-badge]][gitter-url]

Remote Monitoring preconfigured solution with Azure IoT
========
<div align="center">
<img src="https://user-images.githubusercontent.com/3317135/31798657-c75aaaec-b4e9-11e7-9835-dea95cb5316d.png" width="600" height="auto"/>
</div>

Overview
========
> This solution is currently in preview (learn more from our
> [blog announcement](https://azure.microsoft.com/en-in/blog/the-next-generation-of-azure-iot-suite-accelerates-iot-solutions/)). 
> The remote monitoring solution incorporates learnings from customers
> and partners, and is a fully operational IoT solution right out of the
> box. 
>
> Plus, a lot of great functionality will be coming in the next few 
> months, including:
>
> * Extended method support for your simulated devices to help demo and test additional scenarios
> * Additional ‘Getting Started’ and ‘Customization’ documentation in our GitHub repositories 
> * Easier retrieval of your physical device connection string in the web solution
> * Performance enhancements
> * UX improvements
> * Expanded browser compatibility (Internet Explorer and others)
>
> We will also be fixing known bugs. You can refer to our
> [Issues List](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/issues)
> in this repo (and in any submodules) to see known requests and issues. 
>
> There is also a Java version of this repo available [here](https://github.com/Azure/azure-iot-pcs-remote-monitoring-java)

The preview offers many features but there are known bugs. You can refer to our
[Issues List](issues) in this repo (and in any submodules) to see known requests 
and issues. If something doesn’t work as you would expect, feel free to submit new
[issues](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/issues). 
We also love PRs for fixes too!

We have a [User Voice](https://feedback.azure.com/forums/321918-azure-iot)
channel to receive suggestions for features and future supported scenarios.
We encourage you to browse what others are suggesting, vote for your favorites,
and even enter suggestions of your own.

Remote monitoring helps you get better visibility into your devices, assets, and
sensors wherever they happen to be located. You can collect and analyze real-time
device data using a remote monitoring solution that triggers automatic alerts and
actions — from remote diagnostics to maintenance requests. You can also command and
control your devices.

[Azure IoT Hub][iot-hub]
is a key building block of the remote monitoring solution. IoT Hub is a fully
managed service that enables reliable and secure bidirectional communications between
millions of IoT devices and a solution back end.

Check out the [Interactive Demo](http://dev-azureiotclicks01.azurewebsites.net/demos/remotemonitoring)
for a detailed overview of features and use cases.

To get started you can follow along with the [Getting Started](#getting-started)
for a command line deployment. You can also deploy using the web interface
at https://www.azureiotsuite.com.

Getting Started
===============

## Prerequisites
* [Azure Subscription](https://azure.microsoft.com/free/) (also see [permissions guidelines](https://docs.microsoft.com/azure/iot-suite/iot-suite-permissions))

## Setup
1. Open a terminal window or command shell
1. Check out the repository and submodules
    ```
    git clone --recursive https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet.git
    ```
    If you cloned the repo without the `--recursive` flag and it's your first time updating the submodules, you can use
    `git submodule update --init --recursive`. More information on submodules [here](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
1. Set up command line interface for deployments
    #### Prerequisite
    * Install [npm](https://www.npmjs.com/get-npm)

    #### Windows/Mac/Linux
    
    ```
    npm install -g iot-solutions
    ```
    #### 

1. Sign into your Azure account with
    ```
    pcs login
    ```

## Deploy a remote monitoring solution
### Standard Deployment
A standard deployment is a production-ready solution for reliability and scale. *See [Basic vs. Standard Deployments](#basic-vs-standard-deployments) for more details.*
```
pcs -s standard
```

### Basic Deployment
A lower-cost showcase solution best for discovering and learning about what a Remote Monitoring preconfigured solution has to offer.  *See [Basic vs. Standard Deployments](#basic-vs-standard-deployments) for more details.*
```
pcs
```

### Local Deployment
To set up a Remote Monitoring Solution locally see
[Local Development](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/wiki/Developer-Reference-Guide#local-development)

Common Scenarios
================

## All done? Connect a device!
By default, the solution uses simulated devices. You can start adding your
own devices with the instructions here: [Connect a physical device](https://docs.microsoft.com/en-us/azure/iot-suite/iot-suite-connecting-devices-linux)

## Stopping Simulated Devices
Once you are ready, you can stop the default simulated devices by calling the simulation endpoint with the instructions [here](https://github.com/Azure/device-simulation-dotnet/wiki/%5BAPI-Specifications%5D-Simulations#stop-simulation).

Basic vs. Standard Deployments
==============================
## Basic
Basic deployment is geared toward showcasing the solution. To reduce the cost
of this demonstration, all the microservices are deployed in a single
virtual machine; this is not considered a production-ready architecture.

Our Standard deployment option should be used when you are ready to customize
a production-ready architecture, built for scale and extensibility.

Creating a Basic solution will result in the following Azure services being
provisioned into your Azure subscription at cost: 

| Count | Resource                       | Type         | Used For |
|-------|--------------------------------|--------------|----------|
| 1     | [Linux Virtual Machine][virtual-machines] | Standard D1 V2  | Hosting microservices |
| 1     | [Azure IoT Hub][iot-hub]                  | S1 – Basic tier | Device management and communication |
| 1     | [Azure Cosmos DB][cosmos-db]              | Standard        | Storing configuration data, and device telemetry like rules, alarms, and messages |
| 1     | [Azure Storage Account][storage-account]  | Standard        | Storage for VM and streaming checkpoints |
| 1     | [Web Application][web-application]        |                 | Hosting front-end web application |

## Standard
The standard deployment is a production-ready deployment a developer can
customize and extend to meet their needs. For reliability and scale, application
microservices are built as Docker containers and deployed using an orchestrator
([Kubernetes](https://kubernetes.io/) by default). The orchestrator is
responsible for deployment, scaling, and management of the application.

Creating a Standard solution will result in the following Azure services being
provisioned into your Azure subscription at cost:

| Count | Resource                                     | SKU / Size      | Used For |
|-------|----------------------------------------------|-----------------|----------|
| 4     | [Linux Virtual Machines][virtual-machines]   | Standard D2 V2  | 1 master and 3 agents for hosting microservices with redundancy |
| 1     | [Azure Container Service][container-service] |                 | [Kubernetes](https://kubernetes.io) orchestrator |
| 1     | [Azure IoT Hub][iot-hub]                     | S1 – Basic tier | Device management, command and control |
| 1     | [Azure Cosmos DB][cosmos-db]                 | Standard        | Storing configuration data, and device telemetry like rules, alarms, and messages |
| 5     | [Azure Storage Accounts][storage-account]    | Standard        | 4 for VM storage, and 1 for the streaming checkpoints |
| 1     | [App Service][web-application]               | S1 Standard     | Application gateway over SSL |

> Pricing information for these services can be found
[here](https://azure.microsoft.com/pricing). Usage amounts and billing details
for your subscription can be found in the
[Azure Portal](https://portal.azure.com/).

Architecture Overview
=====================
<div align="center">
<img src="https://user-images.githubusercontent.com/3317135/31914374-44a4be80-b7ff-11e7-86b2-19845ab65d7a.png" width="700" height="auto"/>
</div>

[Open in draw.io][draw-io-map]

## Microservices & Docker Containers
Remote Monitoring is the first of our preconfigured solutions to leverage a
microservices architecture. The solution is available in both .NET and [Java](https://github.com/Azure/azure-iot-pcs-remote-monitoring-java).
Microservices have emerged as a prevalent pattern to achieve scale and flexibility
(by allowing containers to be scaled individually), without compromising development speed.
Microservices compartmentalize the code and provide well defined interfaces
making the solution easier to understand and less monolithic. It also further
expands options for partners that want to extend our current preconfigured
solutions to build finished solutions that can be monetized.

**Learn more about Docker Containers**
* [Install Docker](https://docs.docker.com/engine/installation/)
* [Common Docker Commands for Remote Monitoring](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/wiki/Developer-Reference-Guide#common-docker-commands)
* [Docker Getting Started](https://docs.docker.com/get-started/)

## Components
* [Remote Monitoring Web UI](https://github.com/Azure/pcs-remote-monitoring-webui)
* [Command Line Interface (CLI)](https://github.com/Azure/pcs-cli)
* [IoT Hub manager](https://github.com/Azure/iothub-manager-java)
* [User Management](https://github.com/Azure/pcs-auth-dotnet)
* [Device Simulation](https://github.com/Azure/device-simulation-java)
* [Telemetry](https://github.com/Azure/device-telemetry-java)
* [Telemetry Agent](https://github.com/Azure/telemetry-agent-java)
* [Configuration](https://github.com/azure/pcs-config-java)
* [Storage Adapter](https://github.com/azure/pcs-storage-adapter-java)
* [Application Gateway (SSL Proxy WebApp)](https://github.com/Azure/reverse-proxy-dotnet)
* [API Gateway](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/tree/master/reverse-proxy)

How-to and Troubleshooting Resources
====================================
* [Developer Troubleshooting Guide](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/wiki/Developer-Troubleshooting-Guide)
* [Developer Reference Guide](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/wiki/Developer-Reference-Guide#running-all-pcs-microservices-locally)

Feedback
========
* If you have feedback, feature requests, or find a problem, you can create
  a new issue in the [GitHub Issues](issues)
* We also have a [User Voice](https://feedback.azure.com/forums/321918-azure-iot) channel to receive suggestions for features and future supported scenarios.

Contributing
============
Refer to our [contribution guidelines](docs/CONTRIBUTING.md)

License
=======
Copyright (c) Microsoft Corporation. All rights reserved.
Licensed under the [MIT](LICENSE) License.

[build-badge]: https://img.shields.io/travis/Azure/azure-iot-pcs-remote-monitoring-dotnet.svg
[build-url]: https://travis-ci.org/Azure/azure-iot-pcs-remote-monitoring-dotnet
[issues-badge]: https://img.shields.io/github/issues/azure/azure-iot-pcs-remote-monitoring-dotnet.svg
[issues-url]: https://github.com/azure/azure-iot-pcs-remote-monitoring-dotnet/issues
[gitter-badge]: https://img.shields.io/gitter/room/azure/iot-solutions.js.svg
[gitter-url]: https://gitter.im/Azure/iot-solutions
[azure-active-directory]: https://azure.microsoft.com/services/active-directory/
[iot-hub]: https://azure.microsoft.com/services/iot-hub/
[cosmos-db]: https://azure.microsoft.com/services/cosmos-db/
[container-service]: https://azure.microsoft.com/services/container-service/
[storage-account]: https://docs.microsoft.com/azure/storage/common/storage-introduction#types-of-storage-accounts
[virtual-machines]: https://azure.microsoft.com/services/virtual-machines/
[web-application]: https://azure.microsoft.com/services/app-service/web/
[draw-io-map]: https://www.draw.io/?lightbox=1&edit=_blank&layers=1&nav=1#R7V1bc6O4Ev41qdrzQIr75THjTGazNZlJTbK1u48yVmxmAFGAnWR%2F%2FZEAYUACY5vrxpmHMUKA6P7U3epuNVfKwnv7EoJg84BW0L2SxdXblXJ7Jcuyroj4P9LynrWIlpW2rENnlbaJ%2B4Yn51%2BYNkq0deusYJS1pU0xQm7sBOVGG%2Fk%2BtONSGwhD9Fru9oLcVakhAGtYGgZpeLKBC5lufzmreJO2mlqh9%2B%2FQWW%2FokyUxO7ME9q91iLZ%2B9jwf%2BTA94wF6m6xrtAEr9FpoUj5fKYsQoTj95b0toEvoWqbYXc3ZfMgh9GPOBX9GMPy%2B%2FEmoJYsuWGKWJZ3Sy1zH%2F5Ueb%2BKYEPmGXCjfrZ14s11e28jDB%2BDfbYjf5i6wIwFT%2FsVZCz%2FBDqR3oOOQFT1%2FmXyQUfxOSYtfOyA%2FHS%2Fhwafk%2F5soSNko4hZAD16cN4jv%2BmkHw9jBzPlKRv2IIid2kI%2FPL1Ec44HtO9y4zpqciFFA74yPym8Ugtfr9K22mCL4NWJMr%2BwFb7IXTF5UcFAskFcNoYdiKHjId2IUOv5aWKHYh5iOdx6IYhjiHytkR%2BTCKIIx%2BZE8m%2FwgBLoO%2FDUezwt%2B1h3wHJfMimewQR7ArSzbMk6Sl4JvhaaMpF8g8mAcvuMu2VlBNtX0mmy%2BCYpopg2ve%2FSqWZ9NAbiqns2ZbL6s83vvgUNeM%2BUjPSxAqQ9oRZjKmHoCWIEAU5eHMVW5YGxgjGlWGWKyrrMQMzgQsyYCMUr4GLowGYGAyefHXHhdRNjg8DLK8FIVDrw0DryMicFrBXeODYU9yngq8iK%2BRleRKuXuXFQkpTymOW4UPOBj%2BnG1o2xc4DU4vJQyvHRVmSe8DlGegzddveBtYLzpllSx%2BFWOxT8Hc6w15eMQwiIDQojpFUEhCNHbewWR2kXBFhDprx3%2FrX8LTjLLkNSoG6gISasvSDIOESMTwDvgbmERngUgvG6cGD4FwCbHryEgLNvEHkGzVEss0pq5rPAr42PHdRfIRWFyT%2BXGuL29W%2BD2KA7RL1g4oyd%2F%2BMwKRBuCquQhHdBe0iukN1WJIb1MLeoS7WX1aOIzlJatw5SGqzV8yg5RGG%2FQGvnA%2Fbxv%2FWRvw11OlMSFlhyJZZbANyf%2Bu%2FD7H9LlWiNHPh7239kVycH%2B3E8Yx%2B8Zz8A2RrhpP4iviEzVnOGUtdrxsyVC29DOXjgjQQzCNcx6ZYAkpGjkaghdEDu7si%2FyHAZRzl8Y1MwgdTQGGRcGtWGQPhqDzAuD2jBIGk3GadLUORRhQsU3JDqFm5LAUNZ255C3yi5Z0R62iy05x04bsy7SZBhNjbbeGV231Lh5vMcNX0AMXwG%2BXnfxwD4tsR2sr8mv3xKj939XE1mQFGjDLkf2OCN8a2GTnsHWYwx6reIy00x2jSnRcGbRqtTFo9ncxqKXRGPgKW1MbE4zS4pF8tdqqaJVFx6VdcvLy4ts221FgsKR%2FaI2skwg7awoeEg8pR55G%2BbcCfKBSAXMo00uCIoTvdnvMNGJLluViS5Z7MpdUngTXetlotNHnafLT1Dfbedhk0hox7eSVGo141TOjDO6nnDZpY%2FIIbOFIgRbVxVNYFUkfDqq7LIK7%2FNxtLLjJHEAXstTl%2Bti8tdarneDJlEay3iXVPEEpl80e3JbjeKEh5%2FuND4XMUNpfAYxKqMh7tEzbvh9u6yzAEIGYpPVx3JZ3BoiG0zk6%2BPjDW9W%2BcpdKN%2BWc7NmAsrdezTqlX4r9Oss%2Bs1hlK%2BgMNrXqLA5HWg32tecmiAuSbD5SOUUiucIXA7kxl9i3SbpTayIfXK8LXki8q%2BOX1JlOVNRfg%2Fu2qo5KW%2BysryNE6UjWX5EpP6Z5qc1s4vElK89xw5RhF5oiBr6wja62iftEl%2FZhuhd%2BkvADE1S%2BAUPRhGJQpN8cTyZtnaFp%2BYMeZpfspfH%2FannI1j6%2FWYbb2R2agYh2mFehNGx7o9WzAc2ETPCygnxgBB5FzKdoYtlKHtS2MnEPRojG7mRgJyVXYaDNTQcQJatYWM4YAOxI3xUzDeJ2nOH8FHV6x25UzjG8sBKvknHGyNFr7oPVdXYb7p1rRf%2BtAo6ZNMony8%2FoMazgi0cEvbIuwWkQ9QwCkmqSC1q6N%2B1vyJTXXskpqM42diURln1%2FxcNyiYD%2BqjZ0LO1WQM1q7LC0S291Sw4BXRsWtgi2cu2DQvm6%2BSNENawlPWWWuYEK6Q%2B3zO1KKIA%2BNSmoCsEMfe6pH3wLYvd%2BrI7yULCyyM%2BAsIk3TnwtWxnSM0Z8tNkOWN36lrbME0%2FdoXCm0qRhzCPxFvihgMeoZW%2FjIKEAikOVs6OYmCBhSnwVyHAF3zGkjV27CcIQnuDj5O14TNYYp7IC9ZyfXY8gjE8RAdGBYgV7s55IIzt67rOs5j2DAYUKgYOYSBvPMvrOroleTBy014TFxT%2FXq0Xdb9U1v2ZdbBX%2FOL5nC%2BF1Dke9s59jK05rY3N6UbHoDzvhCoeq5XRUuckahP1yFs6czP2Hgqi%2Fxdt9JOR0ZcdfvQa0qzsAaebdGuXkNULNK2CyzMXkEb%2FCWFigyOjIKP%2BybqOjdU88JueodVLjtjNUg4kq7fk3zno7T5T9EQHCF1T5ujV9U7RqPCMI8YELTjeqzbtzbqQozZL8xQv3Cs0tgzWPO0oZZSjx3q0UT6IstLIv2a9XYuTcXxHSsW9KlV8SbIhN%2FlXa2LnZ%2BtGuv9wLN2osAb8U1pYhyN40ko7cxUyiszWCulNyGid5Kb2FUyZ%2BbqI2gqlddFEjN88WrHfcn%2FA%2BmWvyCIq3QVQ1IvC6yqCUu%2BEOBm6AypBpbIDPJeJPeSIGfrgqBtDrg23tmpwdZ4uNocKbytyVcqZUl%2FQoy9aUL6F9RQnTHDjgtCLklPij60Lo7nYOEx4TzE4Rk5fOcAaWzAgy9XDcEnZyVISv1pcJhfu6%2FybhHDSyZnpWNxb%2B3SlEeST%2BRdlBL3ipOPwq6pEmEGOv35OpqqglhmjcNLhZc3Ubq0%2BGSbpFe%2BCabFJYbLK4ZfaBb9a1A9wnUxgFmVXUo0kyc5Ky9lg3pL2IhMDGDp4QIQdt6S87RIL3sd9G4ep%2BB7kYYu8OG8lUKJw9iKsADRfbJ7U1W0TLl%2FIbQnXY0Jfo35nTBesVCoCzVQ5TgwOJ80uWJkvXCaxnpiU2m1n4LXSmLllVjLXpKE2tXPy7tnl%2Bq0D1j4iQXESUMcEcZMkyrlosOoq3exvkV6XnvIHWma6%2FwFipK2ygwXyPOBnR4yD9gcWX7B47mBWwf0jvimWZ1geYq10zJV4ehCdug1cBFZNnt%2Bx8mTEIpNnmyhjmFo72ykHZOeVCwZYqOcHsxXd9TG3lkKdk8RIozKj7Zj5jg2oJLOQSPF9HREypB1MXE49ZOWzUx7lwxCKgyjP9jmWL2BmOzfmNGBaXG5GFHT5V7SOOPI%2FKnvkD%2BqL7w9PqQq7CYJ7P0peJTl%2BDMnQN3Cbqbg%2BE93OMMHO4Koktlz%2F5t%2FiOMseU6wRrPD5iOvGPefNi4mq66yVaOcI9n7SClj%2Flqo2xxctwzwhvsg8R1IqFfCxLSKXb3X0VpCznLwD1lMbaqd34xakWhz2jTBNvFYKf6pZDWCbahcAk%2BXqc456TIc7MEw2b7xQvGGaXkVZrcVbJ9qu4u01FbaAL3e1rBz%2F%2FYvainpB4GKqpJtgGirr%2FQWXqQVySnW9UpE87jZvKd0MNDMrVDDEigN49Gp5FuvEH8GmmVjNUsniOP7kgUwJUzdKIrgMGFXUS2dbRnB5G041niRv%2B5wezYzmwn3iPZHPL4BXX%2BK3HxDY8SkSh1%2FF8xUut05V8MxxVxgGlTw1wXMplswTPAYreHJp1LvoMRS9SSZoqlmSCcqpokcxGyTcgad0aGJarAvmIXGZES%2F3HILX%2FcgKpZpVYPK2D9LIdcnOPP47RWwdCrFF7uQlTN3%2Bk3mVSWxqnDo0fcWp5Y7rdO431TB7ao6R1qdWOKe1LyfxOQj5pHDRSRGitrQt15HsmNCy2HmyWntSs34uklKGbUiP4cFELUCmXiTXe9BXrljOPC4Fq3Y89FeFhUPPxO36O0uCYVY%2FtDQopeUW%2BnPsb5s1hifzbyfk3yZLg5S40UYhvI52vX6j7Bv4VmJfflzgXt525ldmOdxr4VGfJvciAc6Ze3ljJxVvjnZAtKtuKSvNqTZjI2PgbxamXRNY9f7t1ureCU1m04VoPLi0JrKOhhXHf9Ih0ho%2FTZElGl8ANgLAmNCuPE%2BAHY7eZFs0LigbHGWsT2%2FOYqyVxz776NsFbCnYQhIi6R1nJlP%2BmIczzqenTwhVH4Gzx8UTblh8vT8RcLbLgGuWcWiTFsHIlY3SX%2BJ9%2F3KAw5bmmuEfbM7H7wGM7NAJ%2Bp%2F4usmYMWzwgNrSpYlv9gmsHwn5cNtDMbf6%2Btvn5xMg15YzJUTqzYb1XASFymHnCIKCz88%2FwA70wM%2Bf%2BW333JzjlheWm4o2CW4ONgfli1YYZ9lhVsuqSWwUsr9lB%2Btm1VukvX04ONi%2FYNg7FCSrsjIwLTY6wtsCX00EOcm9rrfYA%2F%2FB%2BP5ru4Qh7gyj%2FnlfdaLyMkvoSqTzxBK9RcbZB%2BP9ykb9c726IuAVvaAR0jNlf4cGBqYv2RGZ7n4O%2BfbEgS85fzQwjegs16nGmJsbM4v7xbRAUU3YT70AbRpAUyV23%2FCkgQaKfrLkGzY1EGvOa79AbDCIKZwP%2BU4aYpT%2BeyEGSJHqmtDfBWfj4KxaZ1RVZgazoiTLaiIIIC1KXAO1i9acBtRkfUioEdIiFBe6fwlBsHlAKwK6z%2F8H
