#!/bin/bash

printf "\e[32mInstallin libs-cmake\e[0m\n"
git clone git@github.com:nnctroboticsclub/libs-cmake.git /tmp/libs-cmake
make -C /tmp/libs-cmake install

printf "\e[32mInstallin static-mbed-os\e[0m\n"
git clone git@github.com:nnctroboticsclub/static-mbed-os.git /tmp/static-mbed-os
make -C /tmp/static-mbed-os install TARGET=NUCLEO_F446RE
