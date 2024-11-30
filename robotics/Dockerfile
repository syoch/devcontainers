FROM mcr.microsoft.com/devcontainers/base:bookworm

ADD ./Makefile /opt/container/Makefile

# Install build tools

RUN make -C /opt/container install_build_tools
RUN make -C /opt/container install_arm_toolchain
RUN make -C /opt/container install_qemu_arm

# Install libraries

RUN make -C /opt/container setup_mbed

# Machine specific setup

RUN make -C /opt/container prepare_uid
