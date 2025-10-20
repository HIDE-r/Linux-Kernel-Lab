kernel: 
	$(Q)+ $(SUBMAKE) -C $(LINUX_DIR) O=build/

kernel_defconfig:
	$(Q) $(SUBMAKE) -C $(LINUX_DIR) ARCH=$(ARCH) defconfig

kernel_kconfig:
	$(Q) $(SUBMAKE) -C $(LINUX_DIR) scripts/kconfig/
