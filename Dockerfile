FROM php:7.4-fpm-alpine

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# imagecreatefromjpeg

# Deps
RUN apk add --no-cache \
    git unzip autoconf curl gcc icu libpq-dev libzip-dev  icu-dev libpng-dev zlib-dev libwebp-dev;

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
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli intl zip exif;

#  a
RUN apk add --no-cache imagemagick imagemagick-dev;
RUN apk add --no-cache cmake make automake build-base autoconf libtool;
RUN pecl install imagick;
RUN docker-php-ext-enable imagick;

# Optional dependencies
RUN apk add neovim fish bash;

# Copy the PHP.ini file for ini-development
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini";


# PSYSH
RUN wget https://psysh.org/psysh && chmod +x psysh && mv psysh /usr/local/bin/psysh;

WORKDIR /var/www/html

EXPOSE 9000

