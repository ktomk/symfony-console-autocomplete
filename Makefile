BATS_GIT := https://github.com/sstephenson/bats.git
BATS_TMP := build/bats
COMPOSER_COMMAND ?= composer
COMPOSER_OPTIONS ?= --prefer-source
GIT ?= git
PHP ?= php

COMPOSER_EXECUTABLE := $(shell command -v $(COMPOSER_COMMAND) 2> /dev/null)
COMPOSER_CMD := $(PHP) $(COMPOSER_EXECUTABLE)
export COMPOSER_VENDOR_DIR := vendor-$(PHP).cache
export COMPOSER := composer-$(PHP).cache.json

export PATH := $(PWD)/bin:$(dir $(BATS_TMP))local/bin:$(PWD)/tests/fixtures:$(PATH)


.PHONY : all
all : install-build-deps test

.PHONY : test
test : $(dir $(BATS_TMP))local/bin/bats vendor
	bats tests

.PHONY : install
install : install-build-deps

.PHONY : uninstall
uninstall : clean uninstall-build-deps

## install-build-deps : install build dependencies (bats)
.PHONY : install-build-deps
install-build-deps : $(dir $(BATS_TMP))local/bin/bats vendor
	@$(PHP) --version | head -1
	@$(COMPOSER_CMD) --version
	@bats --version

## uninstall-build-deps : uninstall build dependencies (bats)
.PHONY : uninstall-build-deps
uninstall-build-deps :
	git clean -ffx build/bats build/local/bin/bats build/local/libexec build/local/share

$(dir $(BATS_TMP))local/libexec/bats $(dir $(BATS_TMP))local/bin/bats : $(BATS_TMP)/.git/HEAD
	mkdir -p $(dir $(BATS_TMP))local
	bash $(BATS_TMP)/install.sh $(dir $(BATS_TMP))local
	bats --version
	touch $(@)

$(BATS_TMP)/.git/HEAD :
	$(GIT) clone $(BATS_GIT) $(BATS_TMP)

.PHONY : vendor
vendor : vendor/composer/installed.json $(COMPOSER) $(COMPOSER_VENDOR_DIR)/composer/installed.json

vendor/composer/installed.json : composer.json
	COMPOSER=$< COMPOSER_VENDOR_DIR=$(dir $(@D)) $(COMPOSER_CMD) install

composer-%.cache.json : composer.json
	rm -f $@
	cp $< $@

composer.lock : $(COMPOSER_VENDOR_DIR)/composer/installed.json
	touch $@

$(COMPOSER_VENDOR_DIR)/composer/installed.json : composer.json
	$(COMPOSER_CMD) update $(COMPOSER_OPTIONS)
	touch $@

.PHONY : clean
clean :
	git clean -ffx build/[ac-z]* composer-*.cache* vendor-*.cache vendor/*
