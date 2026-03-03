include $(MK_DIR)/rules.mk
include $(MK_DIR)/package-build.mk

PKG_NAME:=busybox
PKG_VERSION:=1.37.0
PKG_VARIANT:=$(if $(strip $(BUILD_VARIANT)),$(BUILD_VARIANT),busybox)

prepare: download
	echo $(PKG_BUILD_PATH)
	mkdir -p $(PKG_BUILD_PATH)
	tar -xjf $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION).tar.bz2 -C $(PKG_BUILD_PATH) --strip-components=1

download:
	if [ ! -e $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION).tar.bz2 ]; then \
		mkdir -p $(DL_DIR); \
		wget https://busybox.net/downloads/$(PKG_NAME)-$(PKG_VERSION).tar.bz2 -O $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION).tar.bz2; \
	fi

compile: prepare
	echo 'build busybox'
	# $(MAKE) -C $(PKG_BUILD_PATH) $(if $(filter busybox,$(PKG_VARIANT)),,$(PKG_VARIANT))

install: compile
	@case "$(PKG_VARIANT)" in \
		busybox) install -D -m 0755 $(PKG_BUILD_PATH)/busybox $(STAGING_DIR_ROOTFS)/bin/busybox ;; \
		*) : ;; \
	esac
