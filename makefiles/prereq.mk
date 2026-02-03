prereq: env_print .config 
	$(Q) echo ""

env_check: 
	$(Q) if [ -z "$(ARCH)" ]; then \
		echo "Error: $(ARCH) not set"; exit 1; \
	fi
	$(Q) if [ -z "$(CROSS_COMPILE)" ]; then \
		echo "Error: $(CROSS_COMPILE) not set"; exit 1; \
	fi

env_print: env_check
	$(Q) echo "##### Evnironment Variables #####"
	$(Q) echo "ARCH=$(call SHELL_VAR,ARCH)"
	$(Q) echo "CROSS_COMPILE=$(call SHELL_VAR,CROSS_COMPILE)"
	$(Q) echo "TOPDIR=$(TOPDIR)"
	$(Q) echo ""

