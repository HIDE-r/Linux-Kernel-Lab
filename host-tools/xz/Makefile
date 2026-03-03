include $(MK_DIR)/rules.mk
include $(MK_DIR)/host-build.mk

PKG_NAME:=xz
PKG_VERSION:=5.8.1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/tukaani-project/xz/releases/download/v$(PKG_VERSION)

download:
	mkdir -p $(DL_DIR)
	if [ ! -e $(DL_DIR)/$(PKG_SOURCE) ]; then \
		wget $(PKG_SOURCE_URL)/$(PKG_SOURCE) -O $(DL_DIR)/$(PKG_SOURCE); \
	fi

prepare: download
	$(Q) if [ ! -d $(PKG_BUILD_PATH) ]; then \
		mkdir -p $(PKG_BUILD_PATH); \
	fi
	tar -xjf $(DL_DIR)/$(PKG_SOURCE) -C $(PKG_BUILD_PATH) --strip-components=1

HOST_CONFIGURE_ARGS += \
	--prefix=$(STAGING_DIR_HOST) \
	--enable-static=yes \
	--enable-shared=no \
	--disable-doc \
	--disable-nls \
	--with-pic

compile: prepare
	cd $(PKG_BUILD_PATH) && ./configure $(HOST_CONFIGURE_ARGS)
	make -C $(PKG_BUILD_PATH)


install:
	+$(MAKE) -C $(PKG_BUILD_PATH) install xzlinks="unxz xzcat"


