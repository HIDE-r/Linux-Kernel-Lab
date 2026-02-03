ifndef VERBOSE
  VERBOSE:=
endif

ifeq ("$(origin V)", "command line")
  VERBOSE:=$(V)
endif

ifeq ($(NO_TRACE_MAKE),)
NO_TRACE_MAKE := $(MAKE) V=s
export NO_TRACE_MAKE
endif

ifeq ($(IS_TTY),1)
  ifeq ($(strip $(COLOR_TTY)),1)
    _Y:=\\033[33m
    _R:=\\033[31m
    _N:=\\033[m
  endif
endif

ifeq ($(findstring s,$(VERBOSE)),s)
  SUBMAKE=$(MAKE) -w

  define MESSAGE
    printf "%s\n" "$(1)"
  endef
else
  define MESSAGE
	{ \
		printf "$(_Y)%s$(_N)\n" "$(1)" >&8 || \
		printf "$(_Y)%s$(_N)\n" "$(1)"; \
	} 2>/dev/null
  endef

  ifeq ($(QUIET),1)
    ifneq ($(CURDIR),$(TOPDIR))
      _DIR:=$(patsubst $(TOPDIR)/%,%,${CURDIR})
    else
      _DIR:=
    endif
    _MESSAGE:=$(if $(MAKECMDGOALS),$(shell \
		$(call MESSAGE, make[$(MAKELEVEL)]$(if $(_DIR), -C $(_DIR)) $(MAKECMDGOALS)); \
    ))
    ifneq ($(strip $(_MESSAGE)),)
      $(info $(_MESSAGE))
    endif
    SUBMAKE=$(MAKE)
  else
    export QUIET:=1
    SUBMAKE=cmd() { $(SILENT) $(MAKE) "$$@" < /dev/null || { printf "\n$(_R)make $$*: build failed.$(_N)\n" ; false; } } 8>&1 9>&2; cmd
  endif
endif
