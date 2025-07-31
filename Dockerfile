FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    build-essential libpng-dev libjpeg62-turbo-dev libfreetype6-dev locales zip jpegoptim optipng pngquant gifsicle \
    vim unzip git curl libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copiar composer primero
COPY ./laravel/composer.json ./laravel/composer.lock ./
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-scripts

# Copiar el resto de la app
COPY ./laravel ./

# Ejecutar scripts
RUN composer dump-autoload --optimize && php artisan package:discover

# Permisos solo en carpetas necesarias
RUN chown -R www-data:www-data storage bootstrap/cache
