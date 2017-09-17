#!/usr/bin/env bash

APP_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )/"

cd $APP_HOME

git checkout master

echo "### CLI"
git submodule update cli               && cd cli               && git checkout master && git pull && cd ..
echo "### Config"
git submodule update config            && cd config            && git checkout master && git pull && cd ..
echo "### Device Simulation"
git submodule update device-simulation && cd device-simulation && git checkout master && git pull && cd ..
echo "### IoT Hub Manager"
git submodule update iothub-manager    && cd iothub-manager    && git checkout master && git pull && cd ..
echo "### Storage Adapter"
git submodule update storage-adapter   && cd storage-adapter   && git checkout master && git pull && cd ..
echo "### Telemetry"
git submodule update telemetry         && cd telemetry         && git checkout master && git pull && cd ..
echo "### Telemetry Agent"
git submodule update telemetry-agent   && cd telemetry-agent   && git checkout master && git pull && cd ..
echo "### Web UI"
git submodule update webui             && cd webui             && git checkout master && git pull && cd ..
