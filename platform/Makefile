curdir:=platform

$(curdir)/subtargets:=compile install
$(curdir)/builddirs:=

ifeq ($(strip $(CONFIG_PLATFORM_LINUX_LATEST)),y)
$(curdir)/builddirs+=linux_latest
endif

$(eval $(call stampfile,$(curdir),platform,compile))
$(eval $(call subdir,$(curdir)))
