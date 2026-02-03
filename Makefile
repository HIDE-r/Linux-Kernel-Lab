TOPDIR=$(CURDIR)
MK_DIR=$(TOPDIR)/makefiles
export TOPDIR MK_DIR

include $(MK_DIR)/rules.mk
include $(MK_DIR)/verbose.mk
include $(MK_DIR)/debug.mk

world:

ifneq ($(LAB_BUILD),1)
# 这里放执行任何动作前, 都需要做的检查动作
  override LAB_BUILD=1
  export LAB_BUILD

# 放在第一遍构建, 防止menuconfig不加V=s时, 输出被重定向, 导致窗口显示不正常
include $(MK_DIR)/config-menu.mk
include $(MK_DIR)/prereq.mk

dockerfile:
	$(Q) docker build -f $(TOPDIR)/docker/Dockerfile --build-arg TARGET_ARCH=$(ARCH) -t linux-kernel-lab-$(ARCH) .

distclean: FORCE
	$(Q) make -C ./scripts/config clean
	$(Q) rm -rf .config* output/

PARALLEL_OR_QUIET=$(if $(BUILD_LOG),,$(or \
    $(filter-out -j1,$(filter -j%,$(MAKEFLAGS))), \
    $(if $(findstring s,$(VERBOSE)),,1)))

%::
	$(Q)$(R) $(PREP_MK) $(NO_TRACE_MAKE) $(MF_SILENT) $(MF_NO_BUILTIN_RULES) prereq
	$(Q) echo "##### build target = $@ #####"
	$(Q)$(R) $(SUBMAKE) $(MF_SILENT) $(MF_NO_BUILTIN_RULES) $@ $(if $(PARALLEL_OR_QUIET), || { \
		printf "$(_R)Build failed - Please re-run make with -j1 V=s for a higher verbosity level to see the real error message$(_N)\n" >&2; \
		false; \
	})

else
# 真正的执行动作

#  NOTE: 每一层make都会重新include这些文件
-include $(TOPDIR)/.config
include $(MK_DIR)/kernel.mk
include $(MK_DIR)/subdir.mk

include board/Makefile
include platform/Makefile

world: $(board/stamp-prepare) $(platform/stamp-compile)


endif

FORCE:

.PHONY: FORCE
