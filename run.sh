#!/bin/bash

# Configuration
APP_DIR="/app"
GIT_REPO="https://github.com/Qwerty-Systems/itflow"
WEB_USER="www-data"

# Set safe directory for Git
git config --global --add safe.directory "$APP_DIR"
git config --global init.defaultBranch main

# Install dependencies
apt-get update && apt-get install -y \
    php-mailparse \
    whois \
    dnsutils \
    git

# PHP Configuration
PHP_INI=$(php -i | grep 'Loaded Configuration File' | awk '{print $NF}')
[[ -z "$PHP_INI" ]] && PHP_INI="/etc/php/8.3/cli/php.ini"
sed -i "s/^\(upload_max_filesize\s*=\s*\).*\$/\1500M/" "$PHP_INI"
sed -i "s/^\(post_max_size\s*=\s*\).*\$/\1500M/" "$PHP_INI"

# Initialize Git repository (if missing)
if [[ ! -d "$APP_DIR/.git" ]]; then
    echo "Initializing Git repository..."
    cd "$APP_DIR" || exit 1
    
    # Initialize empty repository
    git init
    
    # Add remote
    git remote add origin "$GIT_REPO"
    
    # Fetch metadata
    git fetch --depth=1 origin main
    
    # Reset to remote state without overwriting existing files
    git reset --mixed origin/main
fi

# Set directory permissions
echo "Setting permissions..."
chown -R "$WEB_USER":"$WEB_USER" "$APP_DIR"
find "$APP_DIR" -type d -exec chmod 775 {} \;  # Writable directories
find "$APP_DIR" -type f -exec chmod 664 {} \;  # Writable files

# Special permissions for Git directory
if [[ -d "$APP_DIR/.git" ]]; then
    chown -R "$WEB_USER":"$WEB_USER" "$APP_DIR/.git"
    find "$APP_DIR/.git" -type d -exec chmod 755 {} \;
    find "$APP_DIR/.git" -type f -exec chmod 644 {} \;
fi

# Verify write access
sudo -u "$WEB_USER" touch "$APP_DIR/permission_test.tmp" && rm "$APP_DIR/permission_test.tmp"

echo "Permissions configured:"
ls -ld "$APP_DIR"
ls -ld "$APP_DIR/.git"

# Restart PHP-FPM (Docker compatible)
if command -v php-fpm8.3 &> /dev/null; then
    pkill -o php-fpm && php-fpm8.3 -D
fi

echo "Setup completed successfully"
