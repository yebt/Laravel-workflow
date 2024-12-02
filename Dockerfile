FROM php:7.4-fpm-alpine
# 
RUN apk update
RUN apk upgrade
# Compatible deps
RUN apk add git unzip libpq libpq-dev libzip libzip-dev curl imagemagick imagemagick-dev autoconf automake cmake make gcc g++ icu icu-dev libpng libpng-dev zlib zlib-dev
# Optional
RUN apk add neovim fish bash

# Dependencies of libs for php
RUN pecl install imagick
RUN docker-php-ext-enable imagick
RUN docker-php-ext-install pdo pdo_mysql mysqli intl gd zip exif;
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Add composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Working dir
WORKDIR /var/www/html
#COPY ./laravel-app /var/www/html
#RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
#RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
#RUN composer i

EXPOSE 9000
