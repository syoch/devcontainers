#!/bin/bash

printf "\e[32mSetting up Mbed\e[0m\n"

apt update
apt install -y stlink-tools
rm -rf /var/lib/apt/lists/*
