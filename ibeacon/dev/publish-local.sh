#!/bin/bash
set -e

ADDON_DIR=$(cd $(dirname $0)/..; pwd -P)
docker run -it --rm --privileged -v ${ADDON_DIR}:/data homeassistant/amd64-builder --docker-login --all -t /data