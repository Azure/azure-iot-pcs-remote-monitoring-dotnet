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
> Learn more from our
> [blog announcement](https://azure.microsoft.com/en-in/blog/the-next-generation-of-azure-iot-suite-accelerates-iot-solutions/). 
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

This solution offers many features but there are known bugs. You can refer to our
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

Getting Started
===============

## Deploy a solution
There are two ways to deploy a solution:
1) Deploy using the web interface using the instructions [here](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-deploy).
2) Deploy using the [command line](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-deploy-cli).

Common Scenarios
================
## Create additional simulated devices
Once you have a solution up and running, you can [create additional simulated devices](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-test). You can then stop the default simulated devices by calling the simulation endpoint with the instructions [here](https://github.com/Azure/device-simulation-dotnet/wiki/%5BAPI-Specifications%5D-Simulations#stop-simulation).

## Connect a physical device!
By default, the solution once spun up uses simulated devices. You can start adding your
own devices with the instructions here: 
* [Connect a physical device](https://docs.microsoft.com/azure/iot-suite/iot-suite-connecting-devices-node)

Architecture Overview
=====================
<div align="center">
<img src="https://user-images.githubusercontent.com/3317135/31914374-44a4be80-b7ff-11e7-86b2-19845ab65d7a.png" width="700" height="auto"/>
</div>

[Learn more](https://docs.microsoft.com/azure/iot-suite/iot-suite-remote-monitoring-sample-walkthrough) about the Remote Monitoring architecture, including the use of microservices and Docker containers.

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
[draw-io-map]: https://www.draw.io/?lightbox=1&edit=_blank&layers=1&nav=1#R7V1rc9o4F%2F41mdn9YMbynY%2BUNLvdabqdTd7Z3U8ZYQtQYyxeW0DSX7%2BSb9iSIAZsA23S6SQ%2BvuscPXrORfKNOV68%2FBbD5fyeBCi8MfTg5ca8vTEMwwGA%2FeKS11wCLCeTzGIcZDJ9K3jA31EmBIV0hQOU5LJMRAkJKV7WhT6JIuTTmgzGMdnUD5uSMKgJlnCGao%2FBBQ8%2BDJF02N84oPNM6tmVo39HeDYv7gz0fM8E%2Bs%2BzmKyi%2FH4RiVC2ZwGLy%2BSHJnMYkE1FZH68MccxITT7a%2FEyRiFv13qL3e3YWz5yjCKqOOF%2FCYr%2FnHzjrWXoIZwwlaUHZaeFOHrOtueU8kYe8RONuxmm89Vk4JMF2xh9X8Xsbe4g%2F61hQrWln2gxWhCKtAWJMCUxjmbaN7iG2WWLhzMcq3zD8skT%2Blq0N2uLJf8TL1LFfEh%2Fj5JlpludSWCxMcUviF31wxrFFDONfeav8pUkmGISsf0TQil72u0BoxDP%2BA5KlsWV2Vb9NTEdrEiMZiQaoGDFBMlrQhF%2F5ykOmSGyI%2Fh5PvTnvAESbilPlDxZjv708mRy7d%2Fxt9ZCMiMak74w2WAZzdgdpySid3CBQ94ZHuGcLCCTytrKFcgfG71URHmj%2FYbIAtH4lR2S79UcNzelvJtpppkLNlujdexMNK%2FYq5VrHebdZFZee2sv7I9cU8VmxYL6tqiA0Aix29zRGPHjF5CpJ2Z%2FxIi1V4K0ZUxeXgWbs82Ltjl%2FRaLZ%2F1fMpPLG2Cw1hmeUG4Rxt1qGBAbc8gwduOyXzlUTzXD0khpZ58Zl6%2FbArpuXDdxCVDUwUzYw22rDwCSMc%2FNbrWG4QlVjq6h1M8cUPSyhz7c3bHxi7TGnC26bYGeDcWk%2BCgGPb%2BMwHJOQxOk1zZF7e3s3ZvKExuQZVfY46Q%2FbE8Bkzm0kvUkL7Q8cq974ngWkpjd0V2570xoe3PhSSxvDt1saBWzMzDdJTOfMKiMYftxKP%2FireF02Sjoqplt6XSXoBdN%2FKn%2F%2Fyw9hhsa2IvbY%2F%2BRnpBvbfd8Qpa%2B5zuCKEibaPsRnwjteqfBCtfbhPSYhq9jPXzhvAgrjGSoaOxPxptir1RiFkOJ1nV6coiDTeVdQEwVZZ1OQ%2B66gJgpyzqYg711BTRQEzoZxNrh0DSWsoeiIO5xMlPp6uewO87fKTwmKI%2FwQJgn2M2F%2BCLgYRRe8oXNF73IcRl8%2FMcFvkKINZOc7IXuwDxNG850Z%2F%2BuXlP3%2BenMh7kWlbWTnYmtnXG8NOOkJaj2E1JsCq7QLSl1hlaCIUFRZpaMfrOYmjB4UDLa3Lu1eWJ%2BWXIpx%2BtPIVbFFx0PwW6bTqeH7TSHBVGC%2FbreNCemprPF4Dy8PWBIc0aRy5a9cUDFcUIxCheEC06yaXoMzbEew1ewhtpZbvs0hmMXlMlTdw4i5%2FIvUlRf3HYFfHLWYDc1LoKoC0f4ox4UCkTE0BH16hgxEpgqI7E6AqLjVaVzjCHrR7thfQ8Z9KNcIESwZEdzW2aC6%2F4KC%2FBUG4nhCTCl7qvw0Qfd7u7I8CFn6Ebp%2BH4TSy9p6vl05W09%2FWh2cFKbYweDU1DOxJLD4RB6Z4PfVZNdgEEsmdi3Q7AydhtB8OEeUcdhoA4eb9c12ofc4D7KR8Tvnw2HNNMQsgCuoOXtSCYgVkC4yMsvsDNJ179IgvYaF14PvmcWfAt0K6%2B0Punfx9lu0xuwBJbB%2BwIsVvyOJjuDpQXpRLSmvoSTszg9B2JWRg5ZGhQOSzY8oRNvL7VRXQPxksMB%2BTBIypbnaUKStkiI8xHP8hGpzPoIXf2lMoWkpirZAScIG8YRnaFlnWvmCTr0r1Kmhi3h8GSr9c8RcXUPumsuYrJku4uRQn7qR8qHPYUYLcMweiPB34d0ZhQxD5Z3a2uAxQUp8EiYawYFfN4dh3%2BYA84IDn5kDo5rd2AcoXLC37ENkCC356Ara3fMg377DvosxuI3JIVDE7cxuwnYyO%2FS8uolIlR8tUjpwFi%2F9R6RtJzskKpvrKlYsG91Q8EhKB%2FUNozsi6uwK5g3ejDoLZ5wWdZY7gVwBNSbRFM9WcYW0Xjz1kOmkYXudcY%2FdhYoZj0iWMCqYROEX6GXUJjuGV31WDuuKbXL3YVEmDzTCmnSN0abOLjIbu3a26YKGbKKj1KOp6krJgjAd6bc8jAcXvK2iSbJMWyCzgwCvCxsYM3CHURBDdsJHhvQU%2Bw8Ixv6cbace4SOcMJ0YY5mvPuIFtzH2iBglFROrXF1xQ0T9wa6Dr6LbSzZgmsNmNgAM72AjkKO2Z%2BCPeQSw4BS1wXcbHPz3YGJQ4SFbllGlIqBORXKysuUh%2BumKr9WTOEOZEnhtE4LGmrb71%2FTPUjlkKlIxpfb7V3WZ5%2B%2ByE8tuwXukt6FpXE4JSXHJYvCx8tqj3WRePKNtMu92X%2FxUN91LSC2XyeFsTzG%2F7oDJGfVks3XL%2F%2B0ZWPVTzLf9osgdxmYYgudoipUu7YVSTBURkujm6GHUmJqqXKm3PKgrJrJaUa1UYoltyES2pTpKxZDXIZv5ScY1m%2F%2FbP8Q3wwy7vyFPkZwfDpzKjw2EyJjhGvUD6nfYkbk%2FYmgVJqIW1H%2FP0Cqc0fLQasoOwAMlMZ%2BHKTnjowAu6fXU54jQY3RYwi1PyWilTPLkoPxFek%2B7oNNoXm%2Bp8KF7S%2BWIE05NIFyjzVSO9T6AtZXL2d1Ljra5HgcwU0ggmoaQy2lvjBJxM09B7BmjhDNad%2F%2Bc3nuB8WN7gDtDccfDb391luJiHh5o1BOOsLziRSujeKWOSpGvGIUwXiTpLv2vVboiynWQJSnPaBbzsvsoZrblSfp5qSAzl0ydckuyV6P15mLH4u9pLinrmznWsaPtDzc2N3ze%2FZK8QW8U1UDqdUmYO%2B7jaPaY9lTNqivGVNT1G7Zn3w67VBgoTLNc9mIos1vDUujLakNfDebshzjHyyp0pSuApMVh2YIwTLdcXlXiEsWYPRBXxy1fJWrCcPfrVqZQKrsGv9m4XONKSNmYikkVAUTe1FeBruN7aDLll%2BVap7x9Xb1TVYoT8Mrls6pdT6FJrw1Vlh7Qz5rx2T3qNuObjUbMkijW2CM4XzJIl%2F3%2BWwxnEeHZeZ7ZZw0SpjWc1zKCie6%2Bp5iM05K3v6tO5h4x%2Bwry4X9MFgsYFVt%2FkMnOctytUqqveL31Kp689lWf9SpA78FpBjdvuAvHFxv0BVy7M18NIU1VT9vXMkJvTVfRHzc46qYAXq5HI4yzpFWFSWWxDLFvX%2BP0c6lvO5Yihtpn3wayR%2FaZzJKGmbY%2F7x8yOB4tl5%2BiJH3cdPtrzB9vjlY5XAsVZH3k405gGicodCgvltfWTAVFTe7wDFTzeujk3hni%2BxmzGB5qhOAK%2FO4riW9Z%2B%2FNxQ9c7Ih8nz6Q1hVoBxgCN%2BqUOLoE%2FJZzv9rhQ17knbZ%2BWGu4rnGjrA7PyY3liYtiz2jBEBrzCfQ66TYsZJU%2Bu5q4syXCZITbD2mmXrYyJAkh4itWhla5jgS5tLOm2XIasVbKpKXuWdvsbTTL6cszybrVV2pRTrkE2ZejKaKrmDC9tubbh%2B7KzMtCDoQLpjZ4oh%2Be4NQiuG4ylO7W9DbOriuqAoa1C8qb36ZCO7F%2BZTf%2FE8XkKVWs9%2FPIXgj49BnHUy0hu0GSFReC5xrla21D95QDP%2B2q9KuBxZeAp0ahz6HFNZx8m2JZXwwRhsZ%2Fm0GN6exDujbu0SDGHcozmPo2p8Tma15DJ7QYrTJGkeIWgihVFGrfGM53dJtf4QwV6g4rE95xt4wWCbTH%2F3mfStoxitLTo5p4JIYeg9bFTInUgo%2FPZvkdgHJU%2BOjhjdMhIWF8dsuWGLkPC52hqOR7G66sYh1xIOrhQBigVTnnFRfoonCqVp2xBkcejKKg4Dh03btsf%2BtFcT6yT6bWljQbj57k%2FlbU3f1ku3p%2BeyyVZFpMJfRKjQbLu9ENZX%2BCXmvrK7Yr2SlmtYO3wKJtCew0i75epvURD16y9UtjKOjTdBSDyj6jsDECc2zg2m80gLS9C%2BRvmn8AbJcnWLNhvz0LmBBmWZnsTX7OGQ18bBrauTT3d84DtTQGA5eGdhkZ0T%2Founi6vYmKqvsx2eI9XxEZ2WdEDCVd5nH38%2BdORNuWHkv1cZeRcGlSBpaje6i6A1XJXV6hl%2F4qj5%2B7Wa3YI8wLQYIOfMRxExCfkGaNBhvUBWlcRP%2BD%2FOeg%2Fvi5R4sd4SZ%2FKb1ym6R2cpIZ9x4g6SthD3%2FkTdkvGs22gGyYwTQs43WZibCGzWXx%2FpNbnPUWfP3zdogPM6a90CGCy%2B0p9lj748vHxCENr%2BpWkmh06%2Bl47vBZ4sBQQfgZ4UOvzj%2FJ7yp1%2FpvkaK3VlbSqXFbsKsD%2BuDxoXPRak0gGe8Hdlm9%2F%2B%2BPL1g11S%2FydO8596%2BaSxY4tLrAzlRScL06mB%2BLANM5G9N6dBNv3c2uMEnXlwzyjOTZVdLhu10RSuQj6cF99IZ3ZKnoprP4U8GNe5TkFR6bnNPsjRE9V8MTFRdJT77TSYMHZuBT6vJihmHQ0lA0yqtGsK15h5W92rSJzjrUoQFbmg1vNDToPE8blVlCD0nCJg1sNKDd3ybuaTJP3iu%2BYAb%2BzefgT6SKue0Ln%2BPLGOTDEl0wStUF9ZfW6D8OQJaYymqYqd7fjmGpjtV3weWoKXzzh%2BoDGCzLz0EXu113w63C%2Bjh9Gvb03gyt%2FrymihNCdAuUZXj5M8DPcY033%2FJlEXK1Uackftb9ETUBhiGUA8ujbGFa5kdbQSvqWLBWFvrfAln3HS6ik8DkQIrR7OoGV%2BTwKOcx%2F%2FAw%3D%3D
