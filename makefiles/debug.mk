# debug flags:
#
# d: show subdirectory tree
# t: show added targets
# l: show legacy targets
# r: show autorebuild messages
# v: verbose (no .SILENCE for common targets)

ifeq ($(DEBUG),all)
build_debug:=dltvr
else
build_debug:=$(DEBUG)
endif

ifneq ($(DEBUG),)

# DEBUG_SCOPE_DIR 可以控制哪些目录启用 debug 输出
# $(1) 目录
# $(2) 调试标志, 用于判断是否匹配
define debug
$$(findstring $(2),$$(if $$(DEBUG_SCOPE_DIR),$$(if $$(filter $$(DEBUG_SCOPE_DIR)%,$(1)),$(build_debug)),$(build_debug)))
endef

define warn
$$(if $(call debug,$(1),$(2)),$$(warning $(3)))
endef

define debug_eval
$$(if $(call debug,$(1),$(2)),$(3))
endef

define warn_eval
$(call warn,$(1),$(2),$(3)	$(4))
$(4)
endef

else

debug:=
warn:=
debug_eval:=
warn_eval = $(4)

endif
