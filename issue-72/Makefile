SHELL = /bin/bash
.SUFFIXES:            # Delete the default suffixes

all: issue-72

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  help                           to show this help"
	@echo "  rev-<pattern>                  build container from git reference by <pattern>"
	@echo "  shell                          start shell within container"
	@echo "  clean                          remove container"

.PHONY: rev-%
rev-%:
	git show-ref --verify --hash "$*"
	docker rm -f container-php
	(tar --create -f - Dockerfile | head -c $$(( ($$(stat --printf="%s" Dockerfile) / 512 + 2) * 512 )) \
	  ; git -C .. archive --format tar \
	    --prefix=/tmp/symfony-console-autocomplete/ \
	    $* \
	) | docker build --tag container-php -
	docker run --name container-php -d --rm -i container-php
	docker exec -it container-php head -n 5 /etc/bash_completion.d/composer

.PHONY: shell
shell: ; docker exec -it container-php bash

.PHONY: clean
clean: ; docker rm -f container-php

.PHONY: issue-72
issue-72:
	docker rm -f container-php
	docker build --tag container-php - < $(@).Dockerfile
	docker run --name container-php -d --rm -i container-php
	docker exec -it container-php head -n 5 /etc/bash_completion.d/composer
