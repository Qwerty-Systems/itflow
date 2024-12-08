# Use the official PHP 8.3 image with Apache
FROM php:8.3-apache

# Install required PHP extensions and other dependencies
RUN apt-get update && apt-get install -y \
    git \
    dnsutils \
    whois \
    libmailutils-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    mysqli \
    intl \
    gd \
    mbstring \
    curl \
    && pecl install mailparse \
    && docker-php-ext-enable mailparse \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP settings
RUN echo "upload_max_filesize=500M" >> /usr/local/etc/php/php.ini \
    && echo "post_max_size=500M" >> /usr/local/etc/php/php.ini \
    && echo "memory_limit=256M" >> /usr/local/etc/php/php.ini \
    && echo "max_execution_time=300" >> /usr/local/etc/php/php.ini \
    && echo "disable_functions=" >> /usr/local/etc/php/php.ini

# Set working directory
WORKDIR /app

# Copy project files to the container
COPY . /app

# Set correct permissions
RUN chown -R www-data:www-data /app && chmod -R 775 /app

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
