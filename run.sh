#!/bin/bash
set -e  # Exit on error

# Install Dependencies
apt-get update && apt-get install -y \
    apache2 \
    mariadb-server \
    php8.3 php8.3-intl php8.3-imap php8.3-mysqli php8.3-curl php8.3-gd php8.3-mbstring \
    libapache2-mod-php8.3 \
    git whois dnsutils \
    certbot python3-certbot-apache

# Install PHP mailparse via PECL
apt-get install -y php8.3-dev php-pear
pecl install mailparse
echo "extension=mailparse.so" > /etc/php/8.3/mods-available/mailparse.ini
phpenmod mailparse

# Configure PHP
PHP_INI="/etc/php/8.3/apache2/php.ini"
sed -i "s/^\(upload_max_filesize\s*=\s*\).*\$/\1500M/" "$PHP_INI"
sed -i "s/^\(post_max_size\s*=\s*\).*\$/\1500M/" "$PHP_INI"

# Apache Configuration
a2enmod ssl rewrite
a2ensite default-ssl
# Git Configuration
git config --global init.defaultBranch main
git config --global --add safe.directory /app

# Repository Setup
APP_DIR="/app"
if [[ ! -d "$APP_DIR/.git" ]]; then
    cd "$APP_DIR"
    git init
    git remote add origin https://github.com/Qwerty-Systems/itflow
    git fetch --depth=1 origin master  # Changed from main to master
    git reset --hard origin/master
    git branch -m master main  # Rename branch to main
fi


# Set Permissions
chown -R www-data:www-data "$APP_DIR"
find "$APP_DIR" -type d -exec chmod 755 {} \;
find "$APP_DIR" -type f -exec chmod 644 {} \;

# Writable Directories
declare -a WRITABLE_DIRS=(
    "storage"
    "bootstrap/cache"
    "uploads"
)

for dir in "${WRITABLE_DIRS[@]}"; do
    full_path="${APP_DIR}/${dir}"
    mkdir -p "$full_path"
    chmod -R 775 "$full_path"
    chown -R www-data:www-data "$full_path"
done

# Final Permissions
git config --global --add safe.directory "$APP_DIR"
chmod 640 "${APP_DIR}/config.php"

# Restart Services
systemctl restart apache2 php8.3-fpm

echo "Installation completed successfully!"
