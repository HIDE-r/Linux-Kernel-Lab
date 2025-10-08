# $(1) 目录
# $(2) 名称
# $(3) 动作目标
# $(4) 依赖
# $(5) 存放 stampfile 的路径, 默认为 STAGING_DIR 下
define stampfile
  $(1)/stamp-$(3):=$(if $(5),$(5),$(STAGING_DIR))/stamp/$(2)_$(3)

  $$($(1)/stamp-$(3)): $(4)
	@+$(SCRIPT_DIR)/timestamp.pl -n $$($(1)/stamp-$(3)) $(1) $(4) || \
		$(MAKE) $(if $(QUIET),--no-print-directory) $$($(1)/flags-$(3)) $(1)/$(3)
	@mkdir -p $$$$(dirname $$($(1)/stamp-$(3)))
	@touch $$($(1)/stamp-$(3))

  $$(if $(call debug,$(1),v),,.SILENT: $$($(1)/stamp-$(3)))

  $(1)//clean:=$(1)/stamp-$(3)/clean
  $(1)/stamp-$(3)/clean: FORCE
	@rm -f $$($(1)/stamp-$(3))

endef

