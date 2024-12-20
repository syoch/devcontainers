FROM mcr.microsoft.com/devcontainers/base:bookworm

# Fixup permissions for uucp

RUN sudo groupadd -g 986 uucp-2 && sudo usermod -a -G uucp-2 vscode

#* Install packages to system

# Install build tools

ADD ./container/scripts/install_build_tools.sh /opt/container/scripts/install_build_tools.sh
RUN /opt/container/scripts/install_build_tools.sh

ADD ./container/scripts/install_arm_toolchain.sh /opt/container/scripts/install_arm_toolchain.sh
RUN /opt/container/scripts/install_arm_toolchain.sh

ADD ./container/scripts/install_qemu_arm.sh /opt/container/scripts/install_qemu_arm.sh
RUN /opt/container/scripts/install_qemu_arm.sh

# Install libraries

ADD ./container/scripts/setup_mbed.sh /opt/container/scripts/setup_mbed.sh
RUN /opt/container/scripts/setup_mbed.sh

#* Setup for user 'vscode'
USER vscode

ADD ./container/scripts/setup_idf.sh /opt/container/scripts/setup_idf.sh
RUN /opt/container/scripts/setup_idf.sh

ADD ./container/scripts/setup_node.sh /opt/container/scripts/setup_node.sh
RUN /opt/container/scripts/setup_node.sh

ADD ./container/scripts/setup_rust.sh /opt/container/scripts/setup_rust.sh
RUN /opt/container/scripts/setup_rust.sh

#* Add some tools to container
ADD ./container /opt/container

#* Install Utilities to container
USER root

RUN sudo apt update && sudo apt install -y tmux clangd clang-format llvm lld clang-tools && sudo rm -rf /var/lib/apt/lists/*

#* User utilities
USER vscode

RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin && echo 'eval "$(task --completion bash)"' >>~/.bashrc
RUN /opt/container/scripts/setup_rust.sh
RUN bash -c "~/.cargo/bin/cargo binstall -y cbindgen"
