curdir:=board

$(curdir)/subtargets:= prepare
$(curdir)/builddirs:=

# NOTE: 后续改成自动扫描board目录下的子目录
ifeq ($(strip $(CONFIG_BOARD_QEMU_ARM_VIRT)),y)
$(curdir)/builddirs+=qemu-arm-virt
endif

ifeq ($(strip $(CONFIG_BOARD_QEMU_AARCH64_VIRT)),y)
$(curdir)/builddirs+=qemu-aarch64-virt
endif

$(eval $(call stampfile,$(curdir),board,prepare))
$(eval $(call subdir,$(curdir)))
