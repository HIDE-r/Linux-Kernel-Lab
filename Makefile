TOPDIR=$(CURDIR)
MK_DIR=$(TOPDIR)/makefiles
export TOPDIR MK_DIR

include $(MK_DIR)/rules.mk
include $(MK_DIR)/verbose.mk
include $(MK_DIR)/debug.mk

export PATH:=$(if $(STAGING_DIR_HOST),$(abspath $(STAGING_DIR_HOST)/bin),$(TOPDIR)/output/staging_dir/host/bin):$(PATH)

world:

ifneq ($(LAB_BUILD),1)
# 这里放执行任何动作前, 都需要做的检查动作
  override LAB_BUILD=1
  export LAB_BUILD

# 放在第一遍构建, 防止menuconfig不加V=s时, 输出被重定向, 导致窗口显示不正常
include $(MK_DIR)/config-menu.mk
include $(MK_DIR)/prereq.mk

dockerfile:
	docker build -f $(TOPDIR)/docker/Dockerfile --build-arg TARGET_ARCH=$(ARCH) -t linux-kernel-lab-$(ARCH) .

distclean: FORCE
	rm -rf .config* output/

PARALLEL_OR_QUIET=$(if $(BUILD_LOG),,$(or \
    $(filter-out -j1,$(filter -j%,$(MAKEFLAGS))), \
    $(if $(findstring s,$(VERBOSE)),,1)))

# NOTE: 其他目标应有规则, 否则会被当成伪目标, 导致每次执行make时都执行以下规则
%::
	$(Q)$(R) $(PREP_MK) $(MAKE_WRAP) $(MF_NO_BUILTIN_RULES) prereq
	$(Q) echo "##### build target = $@ #####"
	$(Q)$(R) $(SUBMAKE) $(MF_SILENT) $(MF_NO_BUILTIN_RULES) $@ $(if $(PARALLEL_OR_QUIET), || { \
		printf "$(_R)Build failed - Please re-run make with -j1 V=s for a higher verbosity level to see the real error message$(_N)\n" >&2; \
		false; \
	})

else
# 真正的执行动作

#  NOTE: 每一层make都会重新include这些文件
include $(TOPDIR)/.config
export $(filter CONFIG_%,$(.VARIABLES))

include $(MK_DIR)/kernel.mk
include $(MK_DIR)/subdir.mk

include host-tools/Makefile
include board/Makefile
include platform/Makefile
include package/Makefile

world: board host-tools platform package

board: $(board/stamp-prepare) 

host-tools: $(host-tools/stamp-compile) $(host-tools/stamp-install)

platform: $(platform/stamp-compile) $(platform/stamp-install)

package: $(package/stamp-compile) $(package/stamp-install)

download: FORCE platform/download package/download


endif

FORCE:

.PHONY: FORCE
