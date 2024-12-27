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

#* User utilities
USER vscode

ADD ./container/scripts/setup_idf.sh /opt/container/scripts/setup_idf.sh
RUN /opt/container/scripts/setup_idf.sh

ADD ./container/scripts/setup_node.sh /opt/container/scripts/setup_node.sh
RUN /opt/container/scripts/setup_node.sh

ADD ./container/scripts/setup_rust.sh /opt/container/scripts/setup_rust.sh
RUN /opt/container/scripts/setup_rust.sh

# task
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin && \
    echo 'eval "$(task --completion bash)"' >>~/.bashrc

#* Alternative/Additional System utilities
USER root

# some
RUN sudo apt update && \
    sudo apt install -y tmux socat stlink-tools && \
    sudo rm -rf /var/lib/apts/lists/*

# Clang
RUN apt update && \
    apt install -y lsb-release wget software-properties-common gnupg && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh && \
    chmod +x /tmp/llvm.sh && \
    /tmp/llvm.sh 19 && \
    rm /tmp/llvm.sh

RUN sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 1 && \
    sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 1 && \
    sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-19 1

#* Add some tools to container
ADD ./container /opt/container