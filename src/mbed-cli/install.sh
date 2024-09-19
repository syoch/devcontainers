#!/bin/bash

set -e

apt-get update
apt-get install -y \
  python3="3.10.6-1~22.04.1" \
  python3-dev="3.10.6-1~22.04.1" \
  python3-pip="22.0.2+dfsg-1ubuntu0.4" \
  mercurial="6.1.1-1ubuntu1"

rm -rf /var/lib/apt/lists/*

python3 -m pip install mbed-cli==$VERSION

cd /tmp
wget \
  "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2?rev=78196d3461ba4c9089a67b5f33edf82a&hash=D484B37FF37D6FC3597EBE2877FB666A41D5253B" \
  -O gcc-arm-none-eabi.tar.bz2
tar -xvf gcc-arm-none-eabi.tar.bz2
mv gcc-arm-none-eabi-10.3-2021.10 /opt/gcc-arm-none-eabi-10.3-2021.10
rm -rf gcc-arm-none-eabi.tar.bz2

cd /

sudo -u vscode mbed config -G GCC_ARM_PATH /opt/gcc-arm-none-eabi-10.3-2021.10/bin
sudo -u vscode mbed toolchain -G GCC_ARM
