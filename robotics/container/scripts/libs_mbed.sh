#!/bin/bash

printf "\e[32mInstallin libs-cmake\e[0m\n"
git clone git@github.com:nnctroboticsclub/libs-cmake.git /tmp/libs-cmake
make -C /tmp/libs-cmake install
rm -rf /tmp/libs-cmake

printf "\e[32mInstallin static-mbed-os\e[0m\n"
git clone git@github.com:nnctroboticsclub/static-mbed-os.git /tmp/static-mbed-os
make -C /tmp/static-mbed-os install TARGET=NUCLEO_F446RE
# Do not remove static-mbed-os
# The original mbed-ce is installed in /tmp/static-mbed-os/Build and it is referenced by the static-mbed-os
