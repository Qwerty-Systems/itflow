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

# Install PHP extensions
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

# Set working directory
WORKDIR /var/www/html

# Copy source code
COPY . /var/www/html

# Expose Apache port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
