ARG PHP_TAG=8.4-fpm-alpine
FROM php:${PHP_TAG}

ARG PHP_TAG=8.4-fpm-alpine
ENV PHP_MEMORY_LIMIT=256M
ENV PHP_DATE_TIMEZONE=UTC

ARG XDEBUG_MODE=''
ENV XDEBUG_PORT=9003

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd zip opcache pdo_mysql pdo_pgsql sockets bcmath pcntl intl redis memcached @composer

RUN apk add --no-cache bash git openssh-client nodejs npm && npm install -g pnpm
RUN set -ex; \
    if [ -n "$XDEBUG_MODE" ]; then \
      install-php-extensions xdebug; \
      ini=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
      echo "xdebug.mode=$XDEBUG_MODE" >> $ini; \
      echo "xdebug.start_upon_error=yes" >> $ini; \
      echo "xdebug.client_port=${XDEBUG_PORT:-9003}" >> $ini; \
      echo "xdebug.client_host=host.docker.internal" >> $ini; \
    fi

WORKDIR /var/www
