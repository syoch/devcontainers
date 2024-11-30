#!/bin/bash

QEMU_URL="https://github.com/xpack-dev-tools/qemu-arm-xpack/releases/download/v8.2.2-1/xpack-qemu-arm-8.2.2-1-linux-x64.tar.gz"

printf "\e[32mInstalling QEMU ARM\e[0m\n"

sudo wget \
  $QEMU_URL \
  -O /tmp/xpack-qemu.tgz

sudo tar -xf /tmp/xpack-qemu.tgz -C /opt
sudo mv /opt/xpack-qemu-arm-8.2.2-1 /opt/xpack-qemu-arm
sudo ln -s /opt/xpack-qemu-arm-8.2.2-1/bin/* /usr/bin
