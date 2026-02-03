include $(MK_DIR)/rules.mk
include $(MK_DIR)/platform-build.mk

PKG_NAME:=linux
PKG_VERSION:=latest

download:
	if [ ! -e $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION) ]; then \
		git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION); \
	fi

prepare:
	if [ ! -e $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION)/.config ]; then \
		cp $(STAGING_DIR)/$(PKG_NAME)-$(PKG_VERSION).config $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION)/.config; \
		make -C $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION) defconfig; \
	fi

compile:
	$(EMPTY_MF) $(MAKE) -C $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION) -j$(JOBS) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
