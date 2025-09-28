TOPDIR=$(CURDIR)
MK_DIR=$(TOPDIR)/makefiles

include build.mk
include $(MK_DIR)/rules.mk
include $(MK_DIR)/verbose.mk

world:

ifneq ($(LAB_BUILD),1)
# 这里放执行任何动作前, 都需要做的检查动作
  override LAB_BUILD=1
  export LAB_BUILD

prereq::
	$(Q)+ $(NO_TRACE_MAKE) -r -s $@

PARALLEL_OR_QUIET=$(if $(BUILD_LOG),,$(or \
    $(filter-out -j1,$(filter -j%,$(MAKEFLAGS))), \
    $(if $(findstring s,$(VERBOSE)),,1)))

%::
	$(Q)+ $(NO_TRACE_MAKE) -s -r prereq
	$(Q)+ $(SUBMAKE) -s -r $@ $(if $(PARALLEL_OR_QUIET), || { \
		printf "$(_R)Build failed - Please re-run make with -j1 V=s for a higher verbosity level to see the real error message$(_N)\n" >&2; \
		false; \
	})

else
# 真正的执行动作

include $(MK_DIR)/kernel.mk

world: kernel

prereq: build_check

build_print:
	@ echo "********** ARCH=$(call SHELL_VAR,ARCH)"
	@ echo "********** CROSS_COMPILE=$(call SHELL_VAR,CROSS_COMPILE)"
	@ echo "********** TOPDIR=$(TOPDIR)"
	@ echo ""

build_check: build_print
	$(Q) if [ "$(ARCH)" != "$$(cat .envrc | grep 'export ARCH=' | cut -d '=' -f 2)" ]; then \
		echo "Error: ARCH does not match .envrc"; exit 1; \
	fi

git_init:
	$(Q) git submodule update --init --recursive
	
init: git_init

dockerfile:
	$(Q) docker build -f $(TOPDIR)/docker/Dockerfile --build-arg TARGET_ARCH=$(ARCH) -t linux-kernel-lab-$(ARCH) .

endif
