include $(MK_DIR)/rules.mk
include $(MK_DIR)/platform-build.mk

PKG_NAME:=linux
PKG_VERSION:=6.18.9

download:
	if [ ! -e $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION).tar.bz2 ]; then \
		wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.9.tar.xz -O $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION).tar.xz; \
	fi

prepare:
	tar -xJf $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION).tar.xz -C $(PLAT_BUILD_PATH) --strip-components=1
	if [ ! -e $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION)/.config ]; then \
		cp $(STAGING_DIR)/$(PKG_NAME)-$(PKG_VERSION).config $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION)/.config; \
		make -C $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION) defconfig; \
	fi

compile:
	$(EMPTY_MF) $(MAKE) -C $(PLAT_BUILD_PATH)/$(PKG_NAME)-$(PKG_VERSION) -j$(JOBS) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)

