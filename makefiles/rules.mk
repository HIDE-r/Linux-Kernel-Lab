export IS_TTY=$(if $(MAKE_TERMOUT),1,0)

LINUX_DIR?=$(TOPDIR)/linux
BUSYBOX_DIR?=$(TOPDIR)/busybox
SCRIPT_DIR:=$(TOPDIR)/scripts
JOBS?=$(shell nproc)

EMPTY:=
SPACE:= $(EMPTY) $(EMPTY)

_SINGLE=export MAKEFLAGS=$(SPACE);

define SHELL_VAR
$${$(1)}
endef
