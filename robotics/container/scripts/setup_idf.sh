#!/bin/bash

printf "\e[32mSetting up ESP-IDF\e[0m\n"

apt update
apt install -y \
  python3 python3-venv \
  libffi-dev libssl-dev dfu-util libusb-1.0-0
rm -rf /var/lib/apt/lists/*

mkdir /opt/esp-idf || true
git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf -b v5.0.5
sudo -u vscode /opt/esp-idf/install.sh esp32 --enable-gdbgui

rm -rf ~/.espressif # fix pid/uid
