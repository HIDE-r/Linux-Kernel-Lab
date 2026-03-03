$(STAGING_DIR_HOST)/bin/%onf: CFLAGS+= -O2
$(STAGING_DIR_HOST)/bin/%onf: 
	$(Q) $(EMPTY_MF) $(MAKE_WRAP) -C host-tools/config BUILD_VARIANT=$(notdir $@) compile install

config: $(STAGING_DIR_HOST)/bin/conf FORCE
	$(Q) $(STAGING_DIR_HOST)/bin/$(notdir $<) Config.in

nconfig: $(STAGING_DIR_HOST)/bin/nconf FORCE
	$(Q) [ -L .config ] && export KCONFIG_OVERWRITECONFIG=1; \
		$(STAGING_DIR_HOST)/bin/$(notdir $<) Config.in

menuconfig: $(STAGING_DIR_HOST)/bin/mconf FORCE
	$(Q) [ -L .config ] && export KCONFIG_OVERWRITECONFIG=1; \
		$(STAGING_DIR_HOST)/bin/$(notdir $<) Config.in ;\
	if [ ! -f .config ]; then exit 1; fi

.config: $(OUTPUT_DIR)/config-board.in
	$(Q) $(R) if [ ! -e $(TOPDIR)/.config ]; then \
		$(PREP_MK) $(MAKE_WRAP) menuconfig; \
	fi

$(OUTPUT_DIR)/config-board.in: FORCE
	$(Q) echo "All Config.in files from 'board/' merged into output/config-board.in"
	$(Q) $(SCRIPT_DIR)/merge_board_configs.sh
