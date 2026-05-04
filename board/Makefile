curdir:=board

$(curdir)/subtargets:= prepare
$(curdir)/builddirs:=

board/stamp-prepare:=$(STAGING_DIR))/stamp/board_prepare
$(board/stamp-prepare):
	@$(MAKE) -C $(CONFIG_TARGET_BOARD) prepare
	@touch $@

