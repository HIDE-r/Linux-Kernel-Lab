prereq: env_check env_print .config 
	if [ -f $(TMP_DIR)/.prereq-error ]; then \
		echo; \
		cat $(TMP_DIR)/.prereq-error; \
		rm -f $(TMP_DIR)/.prereq-error; \
		echo; \
		false; \
	fi

env_check: FORCE
	$(Q) if [ -z "$(ARCH)" ]; then \
		echo "Error: $(ARCH) not set"; exit 1; \
	fi
	$(Q) if [ -z "$(CROSS_COMPILE)" ]; then \
		echo "Error: $(CROSS_COMPILE) not set"; exit 1; \
	fi

env_print: FORCE
	$(Q) echo "##### Evnironment Variables #####"
	$(Q) echo "ARCH=$(call SHELL_VAR,ARCH)"
	$(Q) echo "CROSS_COMPILE=$(call SHELL_VAR,CROSS_COMPILE)"
	$(Q) echo "TOPDIR=$(TOPDIR)"
	$(Q) echo ""


# ifneq ($(__prereq_inc),1)
# __prereq_inc:=1

# prereq:

# .SILENT: prereq
# endif

PREREQ_PREV=

# 1: display name
# 2: error message
define Require
  export PREREQ_CHECK=1
  ifeq ($$(CHECK_$(1)),)
    prereq: prereq-$(1)

    prereq-$(1): $(if $(PREREQ_PREV),prereq-$(PREREQ_PREV)) FORCE
		printf "Checking '$(1)'... "
		if $(NO_TRACE_MAKE) -f $(firstword $(MAKEFILE_LIST)) check-$(1) PATH="$(ORIG_PATH)" >/dev/null 2>/dev/null; then \
			echo 'ok.'; \
		elif $(NO_TRACE_MAKE) -f $(firstword $(MAKEFILE_LIST)) check-$(1) PATH="$(ORIG_PATH)" >/dev/null 2>/dev/null; then \
			echo 'updated.'; \
		else \
			echo 'failed.'; \
			echo "$(PKG_NAME): $(strip $(2))" >> $(TMP_DIR)/.prereq-error; \
		fi

    check-$(1): FORCE
	  $(call Require/$(1))
    CHECK_$(1):=1

    .SILENT: prereq-$(1) check-$(1)
    .NOTPARALLEL:
  endif

  PREREQ_PREV=$(1)
endef


define RequireCommand
  define Require/$(1)
    command -v $(1)
  endef

  $$(eval $$(call Require,$(1),$(2)))
endef

define RequireHeader
  define Require/$(1)
    [ -e "$(1)" ]
  endef

  $$(eval $$(call Require,$(1),$(2)))
endef

# 1: header to test
# 2: failure message
# 3: optional compile time test
# 4: optional link library test (example -lncurses)
define RequireCHeader
  define Require/$(1)
    echo 'int main(int argc, char **argv) { $(3); return 0; }' | gcc -include $(1) -x c -o $(TMP_DIR)/a.out - $(4)
  endef

  $$(eval $$(call Require,$(1),$(2)))
endef

define QuoteHostCommand
'$(subst ','"'"',$(strip $(1)))'
endef

# 1: display name
# 2: failure message
# 3: test
define TestHostCommand
  define Require/$(1)
	($(3)) >/dev/null 2>/dev/null
  endef

  $$(eval $$(call Require,$(1),$(2)))
endef

# 1: canonical name
# 2: failure message
# 3+: candidates
define SetupHostCommand
  define Require/$(1)
	mkdir -p "$(STAGING_DIR_HOST)/bin"; \
	for cmd in $(call QuoteHostCommand,$(3)) $(call QuoteHostCommand,$(4)) \
	           $(call QuoteHostCommand,$(5)) $(call QuoteHostCommand,$(6)) \
	           $(call QuoteHostCommand,$(7)) $(call QuoteHostCommand,$(8)) \
	           $(call QuoteHostCommand,$(9)) $(call QuoteHostCommand,$(10)) \
	           $(call QuoteHostCommand,$(11)) $(call QuoteHostCommand,$(12)); do \
		if [ -n "$$$$$$$$cmd" ]; then \
			bin="$$$$$$$$(command -v "$$$$$$$${cmd%% *}")"; \
			if [ -x "$$$$$$$$bin" ] && eval "$$$$$$$$cmd" >/dev/null 2>/dev/null; then \
				case "$$$$$$$$(ls -dl -- $(STAGING_DIR_HOST)/bin/$(strip $(1)))" in \
					"-"* | \
					*" -> $$$$$$$$bin"* | \
					*" -> "[!/]*) \
						[ -x "$(STAGING_DIR_HOST)/bin/$(strip $(1))" ] && exit 0 \
						;; \
				esac; \
				ln -sf "$$$$$$$${bin#$(STAGING_DIR_HOST)/bin/}" "$(STAGING_DIR_HOST)/bin/$(strip $(1))"; \
				exit 1; \
			fi; \
		fi; \
	done; \
	exit 1
  endef

  $$(eval $$(call Require,$(1),$(if $(2),$(2),Missing $(1) command)))
endef
