#!/usr/bin/env bash

APP_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )/"

cd $APP_HOME

git checkout master

git submodule update cli               && cd cli               && git checkout master && git pull && cd ..
git submodule update device-simulation && cd device-simulation && git checkout master && git pull && cd ..
git submodule update iothub-manager    && cd iothub-manager    && git checkout master && git pull && cd ..
git submodule update storage-adapter   && cd storage-adapter   && git checkout master && git pull && cd ..
git submodule update telemetry         && cd telemetry         && git checkout master && git pull && cd ..
git submodule update telemetry-agent   && cd telemetry-agent   && git checkout master && git pull && cd ..
git submodule update ui-config         && cd ui-config         && git checkout master && git pull && cd ..
git submodule update webui             && cd webui             && git checkout master && git pull && cd ..
