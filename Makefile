TOPDIR=$(CURDIR)
MK_DIR=$(TOPDIR)/makefiles

include build.mk
include $(MK_DIR)/rules.mk
include $(MK_DIR)/verbose.mk

include $(MK_DIR)/kernel.mk

all: build_check kernel

build_print:
	@ echo "********** ARCH=$(call SHELL_VAR,ARCH)"
	@ echo "********** CROSS_COMPILE=$(call SHELL_VAR,CROSS_COMPILE)"
	@ echo "********** TOPDIR=$(TOPDIR)"
	@ echo ""

build_check: build_print
	$(Q) if [ "$(ARCH)" != "$$(cat .envrc | grep 'export ARCH=' | cut -d '=' -f 2)" ]; then \
		echo "Error: ARCH does not match .envrc"; exit 1; \
	fi

git_init:
	$(Q) git submodule update --init --recursive
	
init: git_init

dockerfile:
	$(Q) docker build -f $(TOPDIR)/docker/Dockerfile --build-arg TARGET_ARCH=$(ARCH) -t linux-kernel-lab-$(ARCH) .
