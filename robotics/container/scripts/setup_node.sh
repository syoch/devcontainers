#!/bin/bash

printf "\e[32mSetting up Node.js\e[0m\n"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
. ~/.nvm/nvm.sh

nvm install 20
