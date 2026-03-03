export IS_TTY=$(if $(MAKE_TERMOUT),1,0)

LINUX_DIR?=$(TOPDIR)/linux
BUSYBOX_DIR?=$(TOPDIR)/busybox
SCRIPT_DIR:=$(TOPDIR)/scripts
BOARD_DIR:=$(TOPDIR)/board
JOBS?=$(shell nproc)

OUTPUT_DIR:=$(TOPDIR)/output

# TODO: 待修改, ARCH 这个粒度还是太大了
STAGING_DIR:=$(OUTPUT_DIR)/staging_dir
STAGING_DIR_BOARD:=$(STAGING_DIR)/$(ARCH)-$(BOARD)
STAGING_DIR_ROOTFS:=$(STAGING_DIR_BOARD)/rootfs
STAGING_DIR_HOST:=$(STAGING_DIR)/host
BUILD_DIR:=$(OUTPUT_DIR)/build
BUILD_TARGET_DIR=$(BUILD_DIR)/target-$(ARCH)
BUILD_HOST_DIR=$(BUILD_DIR)/host
_CONFIG_EXTERNAL_DL_DIR:=$(strip $(patsubst "%",%,$(CONFIG_EXTERNAL_DL_DIR)))
_CONFIG_EXTERNAL_DL_DIR_ABS:=$(if $(filter /%,$(_CONFIG_EXTERNAL_DL_DIR)),$(_CONFIG_EXTERNAL_DL_DIR),$(TOPDIR)/$(_CONFIG_EXTERNAL_DL_DIR))
DL_DIR?=$(abspath $(if $(_CONFIG_EXTERNAL_DL_DIR),$(_CONFIG_EXTERNAL_DL_DIR_ABS),$(OUTPUT_DIR)/dl))
TMP_DIR=$(OUTPUT_DIR)/tmp

EMPTY:=
SPACE:= $(EMPTY) $(EMPTY)
SILENT:=>/dev/null 2>&1

# @			command not echoed
# +			command must be run even if -n is specified
Q:=@
R:=+

# -r, --no-builtin-rules      Disable the built-in implicit rules.
# -s, --silent, --quiet       Don't echo recipes.
MF_SILENT:=-s
MF_NO_BUILTIN_RULES:=-r

EMPTY_MF=export MAKEFLAGS=$(SPACE);
NO_PRINT_DIR_MF=--no-print-directory

PREP_MK= LAB_BUILD=0 QUIET=0

COLOR_TTY:=1

define SHELL_VAR
$${$(1)}
endef
