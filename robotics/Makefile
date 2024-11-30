MARKER := /opt/container/marker


$(MARKER):
	mkdir -p $(MARKER)

$(MARKER)/install_build_tools: $(MARKER)
	@printf "\e[32mInstalling build tools\e[0m\n"

	@sudo apt update

	# cmake: CMake Build system generator (used for build)
	# ninja-build: C++ build system (used for build)
	# ccache: Compiler cache (used for optimization)
	# librsvg2-bin: SVG to PNG converter (used for generating dependency graph)
	@sudo apt install -y \
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
	@rm -rf /var/lib/apt/lists/*

	@touch $@

.PHONY: install_build_tools
install_build_tools: $(MARKER)/install_build_tools

$(MARKER)/install_arm_toolchain: $(MARKER)
	@printf "\e[32mInstalling ARM toolchain\e[0m\n"

	@wget \
		https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz \
		-O /tmp/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz

	@sudo tar -xf /tmp/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt
	@sudo mv /opt/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi /opt/arm-none-eabi
	@sudo ln -sr /opt/arm-none-eabi/bin/arm-none-eabi-* /usr/bin

	@touch $@

.PHONY: install_arm_toolchain
install_arm_toolchain: $(MARKER)/install_arm_toolchain

$(MARKER)/install_qemu_arm: $(MARKER)
	@printf "\e[32mInstalling QEMU ARM\e[0m\n"

	@sudo wget \
		https://github.com/xpack-dev-tools/qemu-arm-xpack/releases/download/v8.2.2-1/xpack-qemu-arm-8.2.2-1-linux-x64.tar.gz \
		-O /tmp/xpack-qemu.tgz
	@sudo tar -xf /tmp/xpack-qemu.tgz -C /opt
	@sudo mv /opt/xpack-qemu-arm-8.2.2-1 /opt/xpack-qemu-arm
	@sudo ln -s /opt/xpack-qemu-arm-8.2.2-1/bin/* /usr/bin

	@touch $@

.PHONY: install_qemu_arm
install_qemu_arm: $(MARKER)/install_qemu_arm

$(MARKER)/setup_idf: $(MARKER)
	@printf "\e[32mSetting up ESP-IDF\e[0m\n"

	@apt update
	@apt install -y python3 python3-venv \
		libffi-dev libssl-dev dfu-util libusb-1.0-0
	@rm -rf /var/lib/apt/lists/*

	@mkdir /opt/esp-idf || true
	@git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf -b v5.0.5
	@sudo -u vscode /opt/esp-idf/install.sh esp32 --enable-gdbgui

	@rm -rf ~/.espressif # fix pid/uid

	@touch $@

.PHONY: setup_idf
setup_idf: $(MARKER)/setup_idf


$(MARKER)/setup_mbed: $(MARKER)
	@printf "\e[32mSetting up Mbed\e[0m\n"

	@sudo apt update
	@sudo apt install -y stlink-tools
	@sudo rm -rf /var/lib/apt/lists/*

	@touch $@

.PHONY: setup_mbed
setup_mbed: $(MARKER)/setup_mbed

$(MARKER)/setup_node: $(MARKER)
	@printf "\e[32mSetting up Node.js\e[0m\n"

	@curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	@. ~/.nvm/nvm.sh; nvm install 20

	@touch $@

.PHONY: setup_node
setup_node: $(MARKER)/setup_node

setup_rust_:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

	@. ~/.cargo/env; rustup override set nightly
	@. ~/.cargo/env; rustup target add thumbv7em-none-eabi
	@. ~/.cargo/env; rustup component add rust-src
	@. ~/.cargo/env; cargo install cargo-binstall
	@. ~/.cargo/env; yes | cargo binstall cargo-generate cbindgen

	@. ~/.cargo/env; rustup component add rustfmt clippy

$(MARKER)/setup_rust: $(MARKER)
	@printf "\e[32mSetting up Rust\e[0m\n"

	@sudo apt update
	@sudo apt install -y libx11-6 clang
	@sudo rm -rf /var/lib/apt/lists/*

	@sudo vscode $(MAKE) setup_rust_

	@touch $@

.PHONY: setup_rust
setup_rust: $(MARKER)/setup_rust

$(MARKER)/prepare_uid: $(MARKER)
	@printf "\e[32mPreparing UID\e[0m\n"

	@sudo groupadd -g 986 uucp-2
	@sudo usermod -a -G uucp-2 vscode

	@touch $@

.PHONY: prepare_uid
prepare_uid: $(MARKER)/prepare_uid

$(MARKER)/libs_mbed: $(MARKER)
	@git clone git@github.com:nnctroboticsclub/libs-cmake.git /tmp/libs-cmake
	@make -C /tmp/libs-cmake install
	@rm -rf /tmp/libs-cmake

	@git clone git@github.com:nnctroboticsclub/static-mbed-os.git /tmp/static-mbed-os
	@make -C /tmp/static-mbed-os install TARGET=NUCLEO_F446RE
	@rm -rf /tmp/static-mbed-os

	@touch $@

.PHONY: libs_mbed
libs_mbed: $(MARKER)/libs_mbed