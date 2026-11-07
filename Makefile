SWIFT ?= swift
SWIFT_STM32_DEVICES ?= STM32H7S
TRIPLE := armv7em-none-none-eabi

export SWIFT_STM32_DEVICES
# Keep SwiftPM's build-plan environment stable between editor and terminal runs.
unexport $(filter CODEX_% VSCODE_% TERM_% ITERM_%,$(.VARIABLES))
unexport TERM COLORTERM SHLVL OLDPWD _ __CFBundleIdentifier XPC_SERVICE_NAME

export TMPDIR := $(abspath .build/tmp)
export CLANG_MODULE_CACHE_PATH := $(abspath .build/ModuleCache)
export SWIFTPM_MODULECACHE_OVERRIDE := $(abspath .build/ModuleCache)

PACKAGE_FLAGS := --build-system native \
    --cache-path .build/swiftpm-cache \
    --config-path .build/swiftpm-config \
    --security-path .build/swiftpm-security

.PHONY: build test test-register-layout

build:
	@mkdir -p "$(TMPDIR)" "$(CLANG_MODULE_CACHE_PATH)"
	$(SWIFT) build $(PACKAGE_FLAGS) -c release --target STM32H7RSHardware \
	    --triple $(TRIPLE) --toolset embedded-toolset.json
	@python3 Tools/sync-plugin-build-cache.py .build

# The pure HAL/C differential suite does not need to build MMIO macros.
test:
	@mkdir -p "$(TMPDIR)" "$(CLANG_MODULE_CACHE_PATH)"
	env -u SWIFT_STM32_DEVICES $(SWIFT) test $(PACKAGE_FLAGS) \
	    --scratch-path .build/host-tests

# These tests inspect addresses without accessing device memory on the host.
test-register-layout:
	@mkdir -p "$(TMPDIR)" "$(CLANG_MODULE_CACHE_PATH)"
	$(SWIFT) test $(PACKAGE_FLAGS) -c release \
	    --toolset Tools/host-toolset.json \
	    --filter RegisterLayoutTests
	@python3 Tools/sync-plugin-build-cache.py .build
