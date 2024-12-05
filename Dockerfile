# Use the official Debian base image (for Ubuntu, you can use ubuntu:latest)
FROM debian:bullseye-slim

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update apt repository and install required packages
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    mariadb-server \
    php \
    php-intl \
    php-imap \
    php-mailparse \
    php-mysqli \
    php-curl \
    php-gd \
    php-mbstring \
    libapache2-mod-php \
    git \
    whois \
    ufw \
    curl && \
    apt-get clean

# Harden MariaDB and set it up
#RUN mysql_secure_installation --use-default --skip-test-db

# Enable required Apache modules (SSL, PHP, etc.)
# RUN a2enmod ssl && \
#     a2enmod php8.3

# Set PHP file upload limits
RUN echo "upload_max_filesize = 500M" >> /etc/php/8.3/apache2/php.ini && \
    echo "post_max_size = 500M" >> /etc/php/8.3/apache2/php.ini

# Configure SSL (using Let's Encrypt or your own certificates)
# RUN mkdir -p /etc/ssl/certs /etc/ssl/private && \
#     touch /etc/ssl/certs/public.pem /etc/ssl/private/private.key

# Configure Apache SSL settings
# RUN sed -i 's|SSLCertificateKeyFile /etc/ssl/certs/ssl-cert-snakeoil.key|SSLCertificateKeyFile /etc/ssl/private/private.key|' /etc/apache2/sites-available/default-ssl.conf && \
#     sed -i 's|SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem|SSLCertificateFile /etc/ssl/certs/public.pem|' /etc/apache2/sites-available/default-ssl.conf

# Add ITFlow from GitHub
WORKDIR /var/www/html
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html

# # Set the database for ITFlow
# RUN mysql -u root -e "CREATE DATABASE itflow;" && \
#     mysql -u root -e "CREATE USER 'itflow'@'localhost' IDENTIFIED BY 'supersecurepassword';" && \
#     mysql -u root -e "GRANT ALL PRIVILEGES ON itflow.* TO 'itflow'@'localhost';" && \
#     mysql -u root -e "FLUSH PRIVILEGES;"

# Expose ports
EXPOSE 80 443

# Configure firewall (Optional for Docker, this might need to be handled externally)
# RUN ufw allow ssh && \
#     ufw allow "Apache Full" && \
#     ufw enable

# Start Apache and MariaDB services
CMD service apache2 start && service mysql start && tail -f /dev/null
