#!/bin/bash
set -e

echo "Building ZMK firmware locally using Docker..."

# Use the official ZMK dev image
DOCKER_IMAGE="zmkfirmware/zmk-dev-arm:3.5"

docker run --rm -v "$(pwd):/workspace/zmk-config" -w /workspace/zmk-config "$DOCKER_IMAGE" bash -c "
  echo 'Initializing ZMK workspace in .zmk-cache...'
  mkdir -p .zmk-cache
  cd .zmk-cache

  if [ ! -d \".west\" ]; then
    # We copy the config into the cache to act as the west manifest project
    cp -r ../config .
    west init -l config
  fi
  
  # Always update to ensure dependencies match the manifest
  west update
  west zephyr-export

  echo 'Building Keyboard (nice60)...'
  west build -s zmk/app -b nice60 -d build/keyboard -- -DZMK_CONFIG=/workspace/zmk-config/config -DZMK_EXTRA_MODULES=/workspace/zmk-config
  cp build/keyboard/zephyr/zmk.uf2 /workspace/zmk-config/keyboard.uf2

  echo 'Building Dongle (nice60_dongle)...'
  west build -s zmk/app -b nrf52840_mdk_usb_dongle -d build/dongle -- -DSHIELD=nice60_dongle -DZMK_CONFIG=/workspace/zmk-config/config -DZMK_EXTRA_MODULES=/workspace/zmk-config
  cp build/dongle/zephyr/zmk.uf2 /workspace/zmk-config/dongle.uf2

  echo 'Building Keyboard Settings Reset...'
  west build -s zmk/app -b nice60 -d build/keyboard_reset -- -DSHIELD=settings_reset -DZMK_CONFIG=/workspace/zmk-config/config -DZMK_EXTRA_MODULES=/workspace/zmk-config
  cp build/keyboard_reset/zephyr/zmk.uf2 /workspace/zmk-config/keyboard_settings_reset.uf2

  echo 'Building Dongle Settings Reset...'
  west build -s zmk/app -b nrf52840_mdk_usb_dongle -d build/dongle_reset -- -DSHIELD=settings_reset -DZMK_CONFIG=/workspace/zmk-config/config -DZMK_EXTRA_MODULES=/workspace/zmk-config
  cp build/dongle_reset/zephyr/zmk.uf2 /workspace/zmk-config/dongle_settings_reset.uf2

  echo 'Build complete! Check the .uf2 files in your directory.'
"
