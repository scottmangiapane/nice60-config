#!/bin/bash

if ! command -v "docker" &> /dev/null
then
    echo "The 'docker' command was not found."
    echo "Please install Docker to continue."
    exit
fi

docker build -t nice60-build .

mkdir -p dist

docker run -i -v "$(pwd)"/dist:/dist nice60-build << EOF
rm -rf /dist/*
cp /zmk/build/zephyr/zmk.hex /dist/zmk.hex
cp /zmk/build/zephyr/zmk.uf2 /dist/zmk.uf2
chown $(id -u):$(id -g) /dist/zmk.hex
chown $(id -u):$(id -g) /dist/zmk.uf2
EOF
