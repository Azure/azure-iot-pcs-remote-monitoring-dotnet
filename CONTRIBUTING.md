Contribution license Agreement
==============================

If you want/plan to contribute, we ask you to sign a [CLA](https://cla.microsoft.com/)
(Contribution license Agreement). A friendly bot will remind you about it when you submit
a pull-request.

Development
===========

... notes about code style ...
... how to run tests locally ...
... requirements, e.g. Azure sub, IoT Hub setup etc. ...
... useful scripts included in the project ...

Development setup
=================

## .NET setup

1. Install [.NET Core](https://dotnet.github.io/)
2. MacOS/Linux: Install [Mono 5.x](http://www.mono-project.com/download/alpha/)
3. Some IDE options:
   * [Visual Studio](https://www.visualstudio.com/)
   * [IntelliJ Rider](https://www.jetbrains.com/rider)
   * [Visual Studio Code](https://code.visualstudio.com/)
   * [Visual Studio for Mac](https://www.visualstudio.com/vs/visual-studio-mac)

Note: .NET Core support is work in progress, all .NET development is
currently via .NET Framework on Windows and Mono on Linux/MacOS.

We provide also a [Java version here](https://github.com/Azure/device-simulation-java).

## IoT Hub setup

At some point you will probably want to setup your Azure IoT Hub, for
development and integration tests.

The project includes some Bash scripts to help you with this setup:

* Create new IoT Hub: `./scripts/iothub/create-hub.sh`
* List existing hubs: `./scripts/iothub/list-hubs.sh`
* Show IoT Hub details (e.g. keys): `./scripts/iothub/show-hub.sh`

and in case you had multiple Azure subscriptions:

* Show subscriptions list: `./scripts/iothub/list-subscriptions.sh`
* Change current subscription: `./scripts/iothub/select-subscription.sh`

## Git setup

The project includes a Git hook, to automate some checks before accepting a
code change. You can run the tests manually, or let the CI platform to run
the tests. We use the following Git hook to automatically run all the tests
before sending code changes to GitHub and speed up the development workflow.

To setup the included hooks, open a Windows/Linux/MacOS console and execute:

```
cd PROJECT-FOLDER
cd scripts/git
setup
```

If at any point you want to remove the hook, simply delete the file installed
under `.git/hooks`. You can also bypass the pre-commit hook using the
`--no-verify` option.