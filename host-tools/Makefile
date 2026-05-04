curdir:=host-tools

$(curdir)/subtargets:= download prepare compile install
$(curdir)/builddirs:=config
$(curdir)/builddirs+=xz

$(eval $(call stampfile,$(curdir),$(curdir),compile))
$(eval $(call stampfile,$(curdir),$(curdir),install))
$(eval $(call subdir,$(curdir)))
