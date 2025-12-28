scripts/config/%onf: CFLAGS+= -O2
scripts/config/%onf: FORCE
	$(Q) $(EMPTY_MF) $(NO_TRACE_MAKE) $(if $(findstring s,$(VERBOSE)),,-s) \
		-C scripts/config $(notdir $@)

config: scripts/config/conf FORCE

nconfig: scripts/config/nconf FORCE
	$(Q) [ -L .config ] && export KCONFIG_OVERWRITECONFIG=1; \
		$< Config.in

menuconfig: scripts/config/mconf FORCE
	$(Q) [ -L .config ] && export KCONFIG_OVERWRITECONFIG=1; \
		$< Config.in ;\
	if [ ! -f .config ]; then exit 1; fi

