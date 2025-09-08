# Use PHP 8.2 with Apache on Debian Bullseye (keeps IMAP working)
FROM php:8.2-apache-bullseye

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
    libc-client2007e-dev \
    libkrb5-dev \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mods
RUN a2enmod rewrite headers

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install \
        gd \
        zip \
        mysqli \
        pdo \
        pdo_mysql \
        intl \
        mbstring \
        xml \
        opcache \
        imap

# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set correct permissions for storage & bootstrap cache (Laravel style)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Expose Apache port
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]
