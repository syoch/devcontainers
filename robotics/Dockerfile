FROM mcr.microsoft.com/devcontainers/base:bookworm AS rust

USER vscode
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    ~/.cargo/bin/rustup override set nightly && \
    ~/.cargo/bin/rustup target add thumbv7em-none-eabi && \
    ~/.cargo/bin/rustup component add rust-src
RUN ~/.cargo/bin/cargo install cargo-binstall && \
    ~/.cargo/bin/cargo binstall -y cargo-generate cbindgen && \
    ~/.cargo/bin/rustup component add rustfmt clippy

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


# Clang
USER root
RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor -o /etc/apt/keyrings/llvm.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/llvm.gpg] http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm main" | tee /etc/apt/sources.list.d/llvm.list > /dev/nul && \
    apt update && \
    apt install -y clang clangd && \
    rm -rf /var/lib/apt/lists/*

#* ========================
#* .NET
#* ========================
# USER root
# WORKDIR /tmp
# RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
#     dpkg -i packages-microsoft-prod.deb && \
#     rm packages-microsoft-prod.deb && \
#     apt-get update && \
#     apt-get install -y dotnet-sdk-8.0 && \
#     rm -rf /var/lib/apt/lists/*

#* ========================
#* Custom Repository
#* ========================
ARG ROBO_EP=http://100.89.117.6
USER root
RUN echo "deb [trusted=yes] $ROBO_EP/debs/mbed ./" >> /etc/apt/sources.list && \
    echo "deb [trusted=yes] $ROBO_EP/debs/tools ./" >> /etc/apt/sources.list && \
    echo "deb [trusted=yes] $ROBO_EP/debs/libs ./" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
    static-mbed-os-nucleo_f303k8=1.0.1 static-mbed-os-nucleo_f446re=1.0.1 \
    xpack-qemu-arm=8.2.2.1 arm-none-eabi=13.3 task=3.43.3 cmake=4.0.2-1 \
    ikako-mdc=1.0.0 ikako-robomas=1.0.0 \
    ikarashi-can-mk2=1.0.0 motor-controller=1.0.0 \
    && \
    rm -rf /var/lib/apt/lists/*


#* ========================
#* Libraries
#* ========================
USER root
RUN chmod -R 777 /usr/arm-none-eabi && \
    chown -R vscode:vscode /usr/arm-none-eabi

USER vscode
RUN git clone https://github.com/nnctroboticsclub/libs-cmake.git /tmp/libs-cmake  && \
    make -C /tmp/libs-cmake install

# RUN sudo mkdir /opt/esp-idf || true && \
#     sudo chmod -R 777 /opt/esp-idf && \
#     git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf -b v5.0.5
# RUN sudo chown -R vscode:vscode /opt/esp-idf && \
#     sudo chmod -R 777 /opt/esp-idf && \
#     /opt/esp-idf/install.sh esp32 --enable-gdbgui

COPY --from=rust /home/vscode/.cargo /home/vscode/.cargo
COPY --from=rust /home/vscode/.rustup /home/vscode/.rustup
RUN sudo chown -R vscode:vscode /home/vscode/.cargo && \
    sudo chmod -R 777 /home/vscode/.cargo && \
    sudo chown -R vscode:vscode /home/vscode/.rustup && \
    sudo chmod -R 777 /home/vscode/.rustup

#* ========================
#* User environment
#* ========================
USER vscode
RUN echo ". /opt/esp-idf/export.sh" >> ~/.bashrc && \
    echo ". ~/.cargo/env" >> ~/.bashrc && \
    echo "set auto-load safe-path /" >> ~/.gdbinit && \
    echo "[net]" >> $HOME/.cargo/config.toml && \
    echo "git-fetch-with-cli=true" >> $HOME/.cargo/config.toml

COPY dotfiles/.gdbinit /home/vscode/.gdbinit

USER root
COPY robotics /usr/share/robotics

#* ========================
#* Cleanup
#* ========================
USER vscode