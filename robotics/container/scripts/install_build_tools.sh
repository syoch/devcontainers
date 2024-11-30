#!/bin/bash

printf "\e[32mInstalling build tools\e[0m\n"

sudo apt update

# cmake: CMake Build system generator (used for build)
# ninja-build: C++ build system (used for build)
# ccache: Compiler cache (used for optimization)
# librsvg2-bin: SVG to PNG converter (used for generating dependency graph)
sudo apt install -y \
  cmake \
  ninja-build \
  ccache \
  librsvg2-bin \
  socat \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  mercurial
rm -rf /var/lib/apt/lists/*
