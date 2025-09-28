kernel: 
	$(Q) $(SUBMAKE) -C $(LINUX_DIR) -j$(JOBS) 

kernel_defconfig:
	$(Q) $(SUBMAKE) -C $(LINUX_DIR) ARCH=$(ARCH) defconfig

kernel_kconfig:
	$(Q) $(SUBMAKE) -C $(LINUX_DIR) scripts/kconfig/
