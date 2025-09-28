export IS_TTY=$(if $(MAKE_TERMOUT),1,0)

LINUX_DIR?=$(TOPDIR)/linux
BUSYBOX_DIR?=$(TOPDIR)/busybox
JOBS?=$(shell nproc)

define SHELL_VAR
$${$(1)}
endef
