FROM php:8.3-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    dnsutils \
    whois \
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

# Set working directory
WORKDIR /app

# Copy application code
COPY . /app

# Set permissions
RUN chown -R www-data:www-data /app && chmod -R 775 /app

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
