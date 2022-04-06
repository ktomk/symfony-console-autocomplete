SHELL = /bin/bash

.PHONY: issue-72
issue-72: Dockerfile
	docker rm -f container-php
	docker build --tag container-php .
	docker run --name container-php -d --rm -i container-php
	docker exec -it container-php head -n 5 /etc/bash_completion.d/composer

.PHONY: clean
clean:
	docker rm -f container-php
