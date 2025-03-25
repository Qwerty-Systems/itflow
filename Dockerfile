# Use PHP 7.4 with Apache
FROM php:7.4-apache

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    mariadb-client \
    git \
    unzip \
    curl \
    supervisor \
    whois \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libmcrypt-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip mysqli pdo pdo_mysql intl mbstring xml

# Install missing PHP extensions
RUN docker-php-ext-install opcache

# Install PECL extensions
RUN pecl install mailparse \
    && docker-php-ext-enable mailparse

# Update PHP configuration for upload size
RUN echo "upload_max_filesize = 500M" >> /usr/local/etc/php/conf.d/uploads.ini \
&& echo "post_max_size = 500M" >> /usr/local/etc/php/conf.d/uploads.ini

# Enable Apache modules
RUN a2enmod rewrite ssl

# Set up ITFlow
WORKDIR /var/www/html
RUN rm -rf * && git clone https://github.com/Qwerty-Systems/itflow.git .

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html 

# Expose ports
EXPOSE 80 443

# Start Apache
CMD ["apache2-foreground"]
