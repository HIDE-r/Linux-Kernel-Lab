include $(MK_DIR)/rules.mk
include $(MK_DIR)/host-build.mk

PKG_NAME:=config
PKG_VERSION:=6.6.16
PKG_VARIANT:=$(if $(strip $(BUILD_VARIANT)),$(BUILD_VARIANT),mconf)

prepare:
	if [ ! -d $(PKG_BUILD_PATH) ]; then \
		mkdir -p $(PKG_BUILD_PATH); \
		cp -r src/* $(PKG_BUILD_PATH); \
	fi

compile: prepare $(addsuffix /compile,$(PKG_VARIANT))

install: $(addsuffix /install,$(PKG_VARIANT))

%onf/compile:
	$(EMPTY_MF) $(MAKE) -C $(PKG_BUILD_PATH) $*onf

nconf/install:
	echo 1


