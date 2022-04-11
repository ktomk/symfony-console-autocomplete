FROM php:8.1-cli-alpine

COPY tmp /tmp

RUN set -ex; \
    apk add bash; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
    :

RUN set -ex; \
    composer --working-dir=/tmp/symfony-console-autocomplete install; \
    mkdir -p /etc/bash_completion.d; \
    /tmp/symfony-console-autocomplete/bin/symfony-autocomplete --shell=bash --aliases=codecept \
      > /etc/bash_completion.d/composer; \
    :
