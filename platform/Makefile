curdir:=platform

$(curdir)/subtargets:= download prepare compile install
$(curdir)/builddirs:=

ifeq ($(strip $(CONFIG_PLATFORM_LINUX_LATEST)),y)
$(curdir)/builddirs+=linux_latest
$(curdir)/linux_latest/compile:= $(curdir)/linux_latest/prepare
$(curdir)/linux_latest/prepare:= $(curdir)/linux_latest/download
endif

$(eval $(call stampfile,$(curdir),platform,compile))
$(eval $(call subdir,$(curdir)))
