#!/bin/bash

docker build -t nice60-build .

mkdir -p dist

docker run -i -v "$(pwd)"/dist:/dist nice60-build << EOF
rm -rf /dist/*
cp /build/zmk.hex /dist/zmk.hex
cp /build/zmk.uf2 /dist/zmk.uf2
chown $(id -u):$(id -g) /dist/zmk.hex
chown $(id -u):$(id -g) /dist/zmk.uf2
EOF
