# ZMK Configuration for nice!60

This repository contains the ZMK firmware configuration for the nice!60 keyboard and the `nrf52840_mdk_usb_dongle` wireless dongle.

## Building Firmware Locally

This project includes a script to build the firmware locally using Docker.

### Prerequisites

- [Docker](https://www.docker.com/)

### Build Instructions

Execute the build script from the repository root:

```bash
./build.sh
```

The script initializes a Zephyr workspace in an isolated `.zmk-cache` directory to prevent cluttering the host system, then compiles the firmware.

### Output Files

Upon completion, the following `.uf2` files are generated in the root directory:

- `keyboard.uf2`: Standard firmware for the nice!60 keyboard.
- `dongle.uf2`: Standard firmware for the dongle.
- `keyboard_settings_reset.uf2`: Clears Bluetooth pairing data on the keyboard.
- `dongle_settings_reset.uf2`: Clears Bluetooth pairing data on the dongle.

## Flashing

1. Enter bootloader mode on the device (either via keymap shortcut or by double-tapping the physical reset button).
2. The device will mount as a USB mass storage drive.
3. Copy the relevant `.uf2` file to the drive. The device will automatically flash the firmware and restart.
