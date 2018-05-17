#!/usr/bin/env bash

set -e

APP_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )/"

cd $APP_HOME

git checkout master
git pull

COL="\e[93m\e[1m"
NOCOL="\e[0m"

echo -e "${COL}### Auth${NOCOL}"
git submodule update auth              && cd auth              && git checkout master && git pull && cd ..
echo -e "${COL}### CLI${NOCOL}"
git submodule update cli               && cd cli               && git checkout master && git pull && cd ..
echo -e "${COL}### Config${NOCOL}"
git submodule update config            && cd config            && git checkout master && git pull && cd ..
echo -e "${COL}### Device Simulation${NOCOL}"
git submodule update device-simulation && cd device-simulation && git checkout master && git pull && cd ..
echo -e "${COL}### IoT Hub Manager${NOCOL}"
git submodule update iothub-manager    && cd iothub-manager    && git checkout master && git pull && cd ..
echo -e "${COL}### Storage Adapter${NOCOL}"
git submodule update storage-adapter   && cd storage-adapter   && git checkout master && git pull && cd ..
echo -e "${COL}### Telemetry${NOCOL}"
git submodule update telemetry         && cd telemetry         && git checkout master && git pull && cd ..
echo -e "${COL}### ASA Manager${NOCOL}"
git submodule update asa-manager       && cd asa-manager       && git checkout master && git pull && cd ..
echo -e "${COL}### Web UI${NOCOL}"
git submodule update webui             && cd webui             && git checkout master && git pull && cd ..
