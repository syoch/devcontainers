FROM mcr.microsoft.com/devcontainers/base:bookworm

# Fixup permissions for uucp
RUN sudo groupadd -g 986 uucp-2 && sudo usermod -a -G uucp-2 vscode

#* Install packages to system
# ninja-build: C++ build system (used for build)
# ccache: Compiler cache (used for optimization)
# librsvg2-bin: SVG to PNG converter (used for generating dependency graph)
RUN sudo apt update && \
    sudo apt install -y \
    tmux socat stlink-tools \
    pkg-config libudev-dev clang-format openocd libncursesw5 \
    libffi-dev libssl-dev dfu-util libusb-1.0-0 \
    ninja-build ccache \
    lsb-release wget software-properties-common gnupg \
    libx11-6 librsvg2-bin python3 python3-dev python3-pip python3-venv mercurial \
    && \
    rm -rf /var/lib/apt/lists/*

# CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v4.0.0/cmake-4.0.0-linux-x86_64.sh -O /tmp/cmake.sh && \
    chmod +x /tmp/cmake.sh && \
    sudo mkdir /opt/cmake && \
    sudo /tmp/cmake.sh --skip-license --prefix=/opt/cmake && \
    rm /tmp/cmake.sh && \
    sudo ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

# Clang
RUN wget https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh && \
    chmod +x /tmp/llvm.sh && \
    /tmp/llvm.sh 19 && \
    rm /tmp/llvm.sh && \
    sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 1 && \
    sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 1 && \
    sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-19 1

# arm-none-eabi
ARG TOOLCHAIN_URL=https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz

RUN wget $TOOLCHAIN_URL -O /tmp/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz && \
    sudo tar -xf /tmp/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt && \
    sudo mv /opt/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi /opt/arm-none-eabi && \
    sudo ln -sr /opt/arm-none-eabi/bin/arm-none-eabi-* /usr/bin

#* User utilities
USER vscode

# nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    bash -c "source ~/.nvm/nvm.sh && nvm install 20"

# task
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin && \
    echo 'eval "$(task --completion bash)"' >>~/.bashrc

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    ~/.cargo/bin/rustup override set nightly && \
    ~/.cargo/bin/rustup target add thumbv7em-none-eabi && \
    ~/.cargo/bin/rustup component add rust-src
RUN ~/.cargo/bin/cargo install cargo-binstall && \
    ~/.cargo/bin/cargo binstall -y cargo-generate cbindgen && \
    ~/.cargo/bin/rustup component add rustfmt clippy


#* ========================
#* Libraries
#* ========================
USER vscode
RUN sudo mkdir /usr/arm-none-eabi && \
    sudo chmod -R 777 /usr/arm-none-eabi

RUN git clone https://github.com/nnctroboticsclub/libs-cmake.git /tmp/libs-cmake  && \
    make -C /tmp/libs-cmake install

RUN git clone https://github.com/nnctroboticsclub/static-mbed-os.git /tmp/static-mbed-os && \
    make -C /tmp/static-mbed-os install TARGET=NUCLEO_F303K8 && \
    make -C /tmp/static-mbed-os install TARGET=NUCLEO_F446RE

RUN sudo mkdir /opt/esp-idf || true && \
    sudo chmod -R 777 /opt/esp-idf && \
    git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf -b v5.0.5
RUN sudo chown -R vscode:vscode /opt/esp-idf && \
    sudo chmod -R 777 /opt/esp-idf && \
    /opt/esp-idf/install.sh esp32 --enable-gdbgui


#* ========================
#* Debugging tools
#* ========================
USER root
ARG QEMU_URL="https://github.com/xpack-dev-tools/qemu-arm-xpack/releases/download/v8.2.2-1/xpack-qemu-arm-8.2.2-1-linux-x64.tar.gz"
RUN sudo wget $QEMU_URL -O /tmp/xpack-qemu.tgz && \
    sudo tar -xf /tmp/xpack-qemu.tgz -C /opt && \
    sudo mv /opt/xpack-qemu-arm-8.2.2-1 /opt/xpack-qemu-arm && \
    sudo ln -s /opt/xpack-qemu-arm-8.2.2-1/bin/* /usr/bin


#* ========================
#* .NET
#* ========================
USER root
WORKDIR /tmp
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

RUN apt-get update && \
    apt-get install -y dotnet-sdk-8.0 && \
    rm -rf /var/lib/apt/lists/*

#* ========================
#* User environment
#* ========================
USER vscode
RUN echo ". /opt/esp-idf/export.sh" >> ~/.bashrc && \
    echo "set auto-load safe-path /" >> ~/.gdbinit
