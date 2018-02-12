# iBeacon Add-On

![Latest Version][ibeacon-version-shield]
![Supports armhf Architecture][ibeacon-armhf-shield]
![Supports aarch64 Architecture][ibeacon-aarch64-shield]
![Supports amd64 Architecture][ibeacon-amd64-shield]
![Supports i386 Architecture][ibeacon-i386-shield]
![Docker Pulls][ibeacon-pulls-shield]

Turn Home Assistant into an iBeacon for better presence detection.

## Prequisites

This add-on requires a working Bluetooth setup. On the Raspberry Pi 3, install the [Bluetooth BCM43xx](https://home-assistant.io/addons/bluetooth_bcm43xx/) add-on first. 

The Raspberry Pi 3 is currently the only tested platform, but images are provided for the other architectures. It should work if `hcitool` can be successfully run.

## Quickstart

If you start this add-on without changing the configuration, a random presence UUID will be generated and printed to the logs.

The other default settings are:

* Advertising interval: 100ms (as specified by Apple)
* Major version: 0
* Minor version: 0
* Measured Power (RSSI): -60 (calibrated for the Raspberry Pi 3)

You can check if your Home Assistant is acting as an iBeacon by using a tool like [BeaconScanner](https://github.com/mlwelles/BeaconScanner).

## Advanced Configuration

You can change the Presence UUID and other parameters at any time and start the add-on again. 

The presence `uuid`, `major` and `minor` versions allow you to configure the beacon for a specific presence detection scenario (see [Apple's Getting Started Guide](https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf) for more background).

The `advertisementInterval` specifies how often the advertisement is being broadcast. By default this is every 100ms as specified by Apple, but you can configure this value anywhere between 20ms and 10s.

The `measuredPower` attribute specifies the Received Signal Strength Indicator (RSSI). Its value determines how accurate distance calculation will be. The value depends on the chipset and is set to `-60`, which works for the Raspberry Pi 3's BCM43xx chipset. See the *Calibration* section below for more details.

Allowed value ranges are:

* major: `0` - `65535`
* minor: `0`- `65535`
* advertisementInterval: `20` - `10000` (milliseconds)
* measuredPower: `-120` - `0`

### Example

```json
{
  "uuid": "C5B9BD76-21BF-47DF-8386-B97BA2AF3AF7",
  "major": 10,
  "minor": 20,
  "advertisementInterval": 500,
  "measuredPower": -49
}
```

### Calibration

This should not be necessary on a Raspberry Pi 3, but you can adjust the `measuredPower` for other hardware (or to fine-tune your setup).

1. Install [Locate Beacon](https://itunes.apple.com/au/app/locate-beacon/id738709014?mt=8) on your iPhone
1. Add your presence UUID (the beacon won't show up otherwise)
1. Select the beacon
1. Press *Calibrate* and follow the instructions
1. Configure the resulting value as `measuredPower`

----

![Works with iBeacon][works-with-ibeacon]

[ibeacon-version-shield]: https://images.microbadger.com/badges/version/pstreule/armhf-hassio-addon-ibeacon.svg
[ibeacon-armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[ibeacon-aarch64-shield]: https://img.shields.io/badge/aarch64-maybe-yellow.svg
[ibeacon-amd64-shield]: https://img.shields.io/badge/amd64-maybe-yellow.svg
[ibeacon-i386-shield]: https://img.shields.io/badge/i386-maybe-yellow.svg
[ibeacon-pulls-shield]: https://img.shields.io/docker/pulls/pstreule/armhf-hassio-addon-ibeacon.svg
[works-with-ibeacon]: readme/img/Works_with_Apple_iBeacon_Badge_0715.svg