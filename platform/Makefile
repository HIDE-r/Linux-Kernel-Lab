curdir:=platform

$(curdir)/subtargets:= download compile install
$(curdir)/builddirs:=

ifeq ($(strip $(CONFIG_PLATFORM_LINUX_LATEST)),y)
$(curdir)/builddirs+=linux_latest
$(curdir)/linux_latest/compile:= $(curdir)/linux_latest/download
endif

$(eval $(call stampfile,$(curdir),platform,compile))
$(eval $(call subdir,$(curdir)))
