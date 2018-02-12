#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

DEFAULT_UUID=$(cat /proc/sys/kernel/random/uuid)
DEFAULT_MAJOR=0
DEFAULT_MINOR=0
DEFAULT_ADVINT=100
DEFAULT_MPOWER=-60

UUID=$(jq --raw-output ".uuid // empty" $CONFIG_PATH)
MAJOR=$(jq --raw-output ".major // ${DEFAULT_MAJOR}" $CONFIG_PATH)
MINOR=$(jq --raw-output ".minor // ${DEFAULT_MINOR}" $CONFIG_PATH)
ADVINT=$(jq --raw-output ".advertisementInterval // ${DEFAULT_ADVINT}" $CONFIG_PATH)
MPOWER=$(jq --raw-output ".measuredPower // ${DEFAULT_MPOWER}" $CONFIG_PATH)

# Store generated UUID if not set
if [ -z "${UUID}" ]; then
  UUID=${DEFAULT_UUID^^}
  NEW_CONF=$(jq --arg uuid ${UUID} '. + {uuid: $uuid}' $CONFIG_PATH)
  echo "No UUID found, updating config with a generated UUID"
  echo $NEW_CONF
  echo $NEW_CONF > $CONFIG_PATH
fi

hex_bytes() {
  fold -w2 | tr '\n' ' '
}

# The presence UUID with hyphens removed
HEX_UUID=$(echo ${UUID} | tr -d - | hex_bytes)

# The 16-bit advertising interval, as bytes in little-endian order.
# Advertising intervals are specified in units of 0.625ms
ADVINT_UNITS=$((${ADVINT} * 1000 / 625))
HEX_ADVINT=$(printf "%04x" ${ADVINT_UNITS})
HEX_ADVINT_LE="${HEX_ADVINT:2:2} ${HEX_ADVINT:0:2}"

# The major version
HEX_MAJOR=$(printf "%04x" ${MAJOR} | hex_bytes)

# The minor version
HEX_MINOR=$(printf "%04x" ${MINOR} | hex_bytes)

# The measured power (RSSI) as a byte (2-complement - this is a negative value)
HEX_MPOWER=$(printf "%02x" ${MPOWER})
HEX_MPOWER=${HEX_MPOWER: -2}

# Apple's iBeacon prefix
HEX_PREFIX="02 01 06 1a ff 4c 00 02 15"

STOP_ADVERTISING="hcitool -i hci0 cmd 0x08 0x000A  00"
START_ADVERTISING="hcitool -i hci0 cmd 0x08 0x000A  01"

# 03           non-connectable undirected advertising
# 00           use public address
# 00           target address is public (not used for undirected advertising)
# 00 00 00 ... target address (not used for undirected advertising)
# 07           adv. channel map (enable all)
# 00           filter policy (allow any)
SET_ADVERTISING_PARAMS="hcitool -i hci0 cmd 0x08 0x0006  ${HEX_ADVINT_LE} ${HEX_ADVINT_LE}  03  00  00  00 00 00 00 00 00  07  00"

SET_ADVERTISEMENT_DATA="hcitool -i hci0 cmd 0x08 0x0008 1e ${HEX_PREFIX} ${HEX_UUID} ${HEX_MAJOR} ${HEX_MINOR} ${HEX_MPOWER} 00"

echo "Stop advertising:"
echo ${STOP_ADVERTISING}
[ -z $DRY_RUN ] && ${STOP_ADVERTISING}

echo "Set advertising parameters:"
echo ${SET_ADVERTISING_PARAMS}
[ -z $DRY_RUN ] && ${SET_ADVERTISING_PARAMS}

echo "Start advertising:"
echo ${START_ADVERTISING}
[ -z $DRY_RUN ] && ${START_ADVERTISING}

echo "Set iBeacon advertisement data:"
echo ${SET_ADVERTISEMENT_DATA}
[ -z $DRY_RUN ] && ${SET_ADVERTISEMENT_DATA}

echo "iBeacon mode enabled. Presence UUID: ${UUID^^}"
