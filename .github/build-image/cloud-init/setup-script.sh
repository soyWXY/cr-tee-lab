#!/usr/bin/env bash

cd ~/optee/build
make toolchains
make -j$(nproc)
