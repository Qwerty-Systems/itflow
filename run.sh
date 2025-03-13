#!/bin/bash
#set -e  # Exit on error

# Install PHP mailparse via PECL
#apt-get update
# apt-get install -y php8.3-dev php-pear
# pecl install mailparse
# echo "extension=mailparse.so" > /etc/php/8.3/mods-available/mailparse.ini
# phpenmod mailparse

# Configure PHP
PHP_INI=$(php --ini | awk -F': ' '/Loaded Configuration File/{print $2}')
if [[ -z "$PHP_INI" || "$PHP_INI" == "(none)" ]]; then
    echo "Error: PHP configuration file not found!"
    exit 1
fi

sed -i "s/^\(upload_max_filesize\s*=\s*\).*\$/\1500M/" "$PHP_INI"
sed -i "s/^\(post_max_size\s*=\s*\).*\$/\1500M/" "$PHP_INI"

# Apache Configuration
# a2enmod ssl rewrite
# a2ensite default-ssl
# systemctl restart apache2

# Git Configuration
git config --global init.defaultBranch master
git config --global --add safe.directory /app

# Repository Setup
APP_DIR="/app"
if [[ ! -d "$APP_DIR/.git" ]]; then
    cd "$APP_DIR"
    git init
    git remote add origin https://github.com/Qwerty-Systems/itflow
    git fetch --depth=1 origin master  # Ensure 'main' exists in repo
    git checkout -f master
fi

# Set Permissions
chown -R www-data:www-data "$APP_DIR"
find "$APP_DIR" -type d -exec chmod 777 {} \;
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

# Secure config.php
chmod 644 "${APP_DIR}/config.php"

# Restart Services
systemctl restart apache2

echo "Installation completed successfully!"
