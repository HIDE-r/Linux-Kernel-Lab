curdir:=host-tools

$(curdir)/subtargets:= download prepare compile install
$(curdir)/builddirs:=config

$(eval $(call stampfile,$(curdir),$(curdir),compile))
$(eval $(call subdir,$(curdir)))
