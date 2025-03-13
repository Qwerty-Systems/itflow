# Use PHP 8.2 with Apache
FROM php:8.2-apache

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
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
    php-pear \
    php8.2-intl \
    php8.2-imap \
    php8.2-mailparse \
    php8.2-mysqli \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip mysqli pdo pdo_mysql intl mbstring xml \
    && pecl install mailparse \
    && echo "extension=mailparse.so" > /usr/local/etc/php/conf.d/mailparse.ini \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite ssl

# Set up ITFlow
WORKDIR /var/www/html
RUN rm -rf * && git clone https://github.com/itflow-org/itflow.git .

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html \
    && chmod 640 /var/www/html/config.php

# Copy custom Apache configuration
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Enable SSL site
RUN a2ensite default-ssl && systemctl reload apache2

# Expose ports
EXPOSE 80 443

# Start Apache
CMD ["apache2-foreground"]
