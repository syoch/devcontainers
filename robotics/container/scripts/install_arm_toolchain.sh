#!/bin/bash

TOOLCHAIN_URL=https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz

printf "\e[32mInstalling ARM toolchain\e[0m\n"

wget \
  $TOOLCHAIN_URL \
  -O /tmp/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz

sudo tar -xf /tmp/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt
sudo mv /opt/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi /opt/arm-none-eabi
sudo ln -sr /opt/arm-none-eabi/bin/arm-none-eabi-* /usr/bin
