#!/bin/bash

printf "\e[32mSetting up Rust\e[0m\n"

sudo apt update
sudo apt install -y libx11-6 clang
sudo rm -rf /var/lib/apt/lists/*

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

. ~/.cargo/env
rustup override set nightly

rustup target add thumbv7em-none-eabi

rustup component add rust-src

cargo install cargo-binstall

yes | cargo binstall cargo-generate cbindgen

rustup component add rustfmt clippy
