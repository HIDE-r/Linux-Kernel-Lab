include rules.mk

init:
	git submodule update --init --recursive

kernel_kconfig:
	make -C $(LINUX_DIR) scripts/kconfig/

dockerfile:
	docker build -f $(TOPDIR)/docker/Dockerfile --build-arg TARGET_ARCH=arm64 -t Linux-Kernel-Lab .
