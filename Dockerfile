# FROM php:8.2-fpm-alpine
FROM php:7.4-fpm-alpine

# TODO: cehck what happend if set config-set in pecl
# sudo pecl config-set php_suffix 7.4

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# imagecreatefromjpeg

# Deps
RUN apk add --no-cache \
    git unzip autoconf curl gcc icu libpq-dev libzip-dev  icu-dev libpng-dev zlib-dev libwebp-dev imap-dev;

# GD with FreeType, JPEG, WEBP
RUN apk add --no-cache --virtual .build-deps \
    freetype-dev \
    libjpeg \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libpng-dev \
    jpeg-dev libpng-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) gd;

# Libs
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli intl zip exif imap;

#  imagemagick
RUN apk add --no-cache imagemagick imagemagick-dev;
RUN apk add --no-cache cmake make automake build-base autoconf libtool;
RUN pecl install imagick;
RUN docker-php-ext-enable imagick;
# Install xdebug (3.1.6 for php 7.4)
# https://xdebug.org/docs/compat
RUN pecl install xdebug-3.1.6;
RUN docker-php-ext-enable xdebug;
# Supervisord
COPY ./container/supervisor/supervisord.conf /etc/supervisord.conf
RUN apk add supervisor;
# Redis
RUN pecl install redis;
# for horizontal
RUN docker-php-ext-install pcntl;
RUN docker-php-ext-enable redis pcntl;

# Optional dependencies
RUN apk add neovim fish bash gawk;

# Copy the PHP.ini file for ini-development
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini";


# PSYSH
RUN wget https://psysh.org/psysh && chmod +x psysh && mv psysh /usr/local/bin/psysh;

WORKDIR /var/www/html

EXPOSE 9000

