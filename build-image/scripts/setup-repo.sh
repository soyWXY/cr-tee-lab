#! /usr/bin/env bash

mkdir optee
cd optee
repo init -u https://github.com/OP-TEE/manifest.git -m qemu_v8.xml
repo sync
rm -rf optee_examples/aes
cd build
make toolchains
make

git clone https://github.com/NTHU-SCOPELAB/cr-tee-image.git ~/
