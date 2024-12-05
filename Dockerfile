# Use the official Debian base image
FROM debian:bullseye-slim

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update apt repository and install required packages, including PHP 8.3 from Sury repository
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    lsb-release \
    apt-transport-https && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/sury-php.list && \
    curl -fsSL https://packages.sury.org/php/apt.gpg | tee /etc/apt/trusted.gpg.d/sury.asc && \
    apt-get update && \
    apt-get install -y \
    apache2 \
    mariadb-server \
    php8.3 \
    php8.3-intl \
    php8.3-imap \
    php8.3-mailparse \
    php8.3-mysqli \
    php8.3-curl \
    php8.3-gd \
    php8.3-mbstring \
    libapache2-mod-php8.3 \
    git \
    whois \
    ufw \
    curl && \
    apt-get clean

# Enable required Apache modules (SSL, PHP, etc.)
RUN a2enmod ssl && \
    a2enmod php8.3

# Set PHP file upload limits
RUN echo "upload_max_filesize = 500M" >> /etc/php/8.3/apache2/php.ini && \
    echo "post_max_size = 500M" >> /etc/php/8.3/apache2/php.ini

# Add ITFlow from GitHub
WORKDIR /var/www/html
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html

# Expose ports
EXPOSE 80 443

# Start Apache and MariaDB services
CMD service apache2 start && service mysql start && tail -f /dev/null
