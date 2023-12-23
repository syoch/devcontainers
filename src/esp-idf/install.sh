#!/bin/bash

set -e

apt update
apt install -y python3 python3-venv
rm -rf /var/lib/apt/lists/*

mkdir /opt/esp-idf
git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf -b $TARGET
/opt/esp-idf/install.sh esp32 --enable-gdbgui

rm -rf ~/.espressif
