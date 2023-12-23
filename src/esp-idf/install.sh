#!/bin/bash

set -e

apt update
apt install python3 python3-venv
rm -rf /var/lib/apt/lists/*

mkdir /opt/esp-idf
git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf
/opt/esp-idf/install.sh esp32 --enable-gdbgui
python3 /opt/esp/esp-idf/tools/idf_tools.py install qemu-xtensa

rm -rf ~/.espressif
