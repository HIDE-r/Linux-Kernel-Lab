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

.config: scan_config_in
	$(Q)$(R) if [ ! -e $(TOPDIR)/.config ]; then \
		$(PREP_MK) $(NO_TRACE_MAKE) menuconfig; \
	fi

$(STAGING_DIR)/config-board.in:
	$(Q) $(SCRIPT_DIR)/merge_board_configs.sh
	$(Q) echo "All Config.in files from 'board/' merged into output/config-board.in"

scan_config_in:
	$(Q) echo "##### Scan and Generate Config.in files #####"
	$(Q) $(PREP_MK) $(MAKE) $(NO_PRINT_DIR_MF) $(STAGING_DIR)/config-board.in

