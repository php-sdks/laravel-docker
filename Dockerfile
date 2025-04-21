ARG PHP_TAG=8.4-fpm-alpine
FROM php:${PHP_TAG}

ARG PHP_TAG=8.4-fpm-alpine
ENV PHP_MEMORY_LIMIT=256M
ENV PHP_DATE_TIMEZONE=UTC

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN set -ex; \
    export EXTENSION_DIR=$(php -r 'echo ini_get("extension_dir");'); \
    export PHP_VER=$(echo ${PHP_TAG} | awk -F'[.-]' '{print $1$2}'); \
    apk add \
        autoconf build-base libmemcached-dev \
        php$PHP_VER-pdo_mysql \
        php$PHP_VER-pdo_pgsql \
        php$PHP_VER-session \
        php$PHP_VER-sockets \
        php$PHP_VER-tokenizer \
        php$PHP_VER-bcmath \
        php$PHP_VER-pcntl \
        php$PHP_VER-intl \
        php$PHP_VER-dom \
        php$PHP_VER-dev; \
    cp /usr/lib/php$PHP_VER/modules/* $EXTENSION_DIR; \
    pecl install memcached; \
    docker-php-ext-enable opcache pdo_mysql pdo_pgsql session sockets tokenizer bcmath pcntl intl dom memcached; \
    apk del --purge autoconf build-base; \
    curl -o /usr/bin/composer https://getcomposer.org/composer.phar; \
    chmod +x /usr/bin/composer; \
    cd

RUN apk add linux-headers zlib-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install gd zip

WORKDIR /var/www
