%onf: CFLAGS+= -O2
%onf: FORCE
	$(Q) $(EMPTY_MF) $(NO_TRACE_MAKE) $(if $(findstring s,$(VERBOSE)),,-s) \
		-C host-tools/config BUILD_VARIANT=$@ compile install

config: conf FORCE
	$(Q) $(STAGING_DIR_HOST)/bin/$< Config.in

nconfig: nconf FORCE
	$(Q) [ -L .config ] && export KCONFIG_OVERWRITECONFIG=1; \
		$(STAGING_DIR_HOST)/bin/$< Config.in

menuconfig: mconf FORCE
	$(Q) [ -L .config ] && export KCONFIG_OVERWRITECONFIG=1; \
		$(STAGING_DIR_HOST)/bin/$< Config.in ;\
	if [ ! -f .config ]; then exit 1; fi

.config: scan_config_in
	$(Q)$(R) if [ ! -e $(TOPDIR)/.config ]; then \
		$(PREP_MK) $(NO_TRACE_MAKE) menuconfig; \
	fi

$(OUTPUT_DIR)/config-board.in:
	$(Q) $(SCRIPT_DIR)/merge_board_configs.sh
	$(Q) echo "All Config.in files from 'board/' merged into output/config-board.in"

scan_config_in:
	$(Q) echo "##### Scan and Generate Config.in files #####"
	$(Q) $(PREP_MK) $(MAKE) $(NO_PRINT_DIR_MF) $(OUTPUT_DIR)/config-board.in
