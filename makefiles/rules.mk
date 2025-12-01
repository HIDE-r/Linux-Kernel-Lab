export IS_TTY=$(if $(MAKE_TERMOUT),1,0)

LINUX_DIR?=$(TOPDIR)/linux
BUSYBOX_DIR?=$(TOPDIR)/busybox
SCRIPT_DIR:=$(TOPDIR)/scripts
JOBS?=$(shell nproc)

OUTPUT_DIR:=$(TOPDIR)/output

# TODO: 待修改, ARCH 这个粒度还是太大了
STAGING_DIR:=$(OUTPUT_DIR)/staging_dir/$(ARCH)

EMPTY:=
SPACE:= $(EMPTY) $(EMPTY)

_SINGLE=export MAKEFLAGS=$(SPACE);

define SHELL_VAR
$${$(1)}
endef
