FROM php:8.3-apache

# Set non-interactive environment
ENV DEBIAN_FRONTEND=noninteractive

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
    && pecl install -f mailparse \
    && docker-php-ext-enable mailparse \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
