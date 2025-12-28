subtarget-dir= $(filter-out ., \
	$(if $($(1)/builddirs-$(2)),$($(1)/builddirs-$(2)), \
	$($(1)/builddirs)))

define subtarget
  $(call warn,$(1),t,Target $(1)/$(2))
  $(1)/$(2): $($(1)/) $(foreach bd,$(call subtarget-dir,$(1),$(2)),$(1)/$(bd)/$(2))
endef

define ERROR
	($(call MESSAGE, $(2)); $(if $(BUILD_LOG), echo "$(2)" >> $(BUILD_LOG_DIR)/$(1)/error.txt;) exit 1;)
endef

subdir_make_opts = \
	$(if $(SUBDIR_MAKE_DEBUG),-d) -r -C $(1) \
		BUILD_SUBDIR="$(1)" \
		BUILD_VARIANT="$(3)"

# 1: subdir
# 2: target
# 3: build variant
log_make = \
	 $(if $(call debug,$(1),v),,@)+ \
	 $(if $(BUILD_LOG), \
		set -o pipefail; \
		mkdir -p $(BUILD_LOG_DIR)/$(1)$(if $(3),/$(3));) \
	$(SCRIPT_DIR)/time.pl "time: $(1)$(if $(3),/$(3))/$(2)" \
	$$(SUBMAKE) $(subdir_make_opts) $(2) \
		$(if $(BUILD_LOG),SILENT= 2>&1 | tee $(BUILD_LOG_DIR)/$(1)$(if $(3),/$(3))/$(2).txt)


# $(1) 目录
define subdir
  $(call warn,$(1),d,Dir $(1))

  $(foreach bd,$($(1)/builddirs),
    $(call warn,$(1),d,BuildDir $(1)/$(bd))
    $(foreach target, $($(1)/subtargets),
      $(call warn,$(1)/$(bd),t,Target $(1)/$(bd)/$(target))
      $(1)/$(bd)/$(target): $($(1)/$(bd)/$(target)) $(call $(1)//$(target),$(1)/$(bd))
        $(foreach variant,$(filter-out *,$(if $(BUILD_VARIANT),$(BUILD_VARIANT),$(if $(strip $($(1)/$(bd)/variants)),$($(1)/$(bd)/variants),__default))),
		$(call log_make,$(1)/$(bd),$(target),$(filter-out __default,$(variant))) \
			|| $(call ERROR,$(1),   ERROR: $(1)/$(bd) failed to build$(if $(filter-out __default,$(variant)), (build variant: $(variant))).) 
        )
    )
  )

  $(foreach target,$($(1)/subtargets),$(call subtarget,$(1),$(target)))
endef

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

