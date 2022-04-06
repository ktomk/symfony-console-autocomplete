FROM php:8.1-cli-alpine

RUN apk add bash

RUN printf 'display_errors = STDERR\n' > /usr/local/etc/php/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sSL "https://github.com/bamarni/symfony-console-autocomplete/archive/master.zip" > /tmp/symfony-console-autocomplete.zip \
    && unzip -d /tmp /tmp/symfony-console-autocomplete.zip \
    && composer --working-dir=/tmp/symfony-console-autocomplete-master install \
    && mkdir /etc/bash_completion.d \
    && /tmp/symfony-console-autocomplete-master/bin/symfony-autocomplete --shell=bash --aliases=codecept > /etc/bash_completion.d/composer \
    && rm -fr /tmp/symfony-console-autocomplete* /root/.composer
