#!/bin/bash
set -e

BASEDIR=$(cd $(dirname $0); pwd -P)

docker build --build-arg BUILD_FROM="homeassistant/i386-base:latest" -t local/ibeacon-addon ${BASEDIR}/..
docker run --rm -e "DRY_RUN=true" -v ${BASEDIR}/data:/data local/ibeacon-addon
