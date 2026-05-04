curdir:=package

$(curdir)/subtargets:= download prepare compile install
$(curdir)/builddirs:=utils/busybox

$(eval $(call stampfile,$(curdir),package,compile))
$(eval $(call stampfile,$(curdir),package,install))
$(eval $(call subdir,$(curdir)))
