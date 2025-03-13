#!/bin/bash

# Fix PHP Extensions
apt-get update && apt-get install -y php8.3-mailparse

# PHP Configuration
PHP_INI=$(php -i | grep 'Loaded Configuration File' | awk '{print $NF}')
[[ -z "$PHP_INI" ]] && PHP_INI="/etc/php/8.3/fpm/php.ini"

sed -i "s/^\(upload_max_filesize\s*=\s*\).*\$/\1500M/" "$PHP_INI"
sed -i "s/^\(post_max_size\s*=\s*\).*\$/\1500M/" "$PHP_INI"

# File Permissions
APP_DIR="/app"
WEB_USER="www-data"

# Set ownership and base permissions
chown -R $WEB_USER:$WEB_USER "$APP_DIR"
find "$APP_DIR" -type d -exec chmod 755 {} \;
find "$APP_DIR" -type f -exec chmod 644 {} \;

# Specific write permissions for required directories
declare -a WRITABLE_DIRS=(
    "storage"
    "bootstrap/cache"
    "public/uploads"
    "tmp"
)

for dir in "${WRITABLE_DIRS[@]}"; do
    full_path="$APP_DIR/$dir"
    if [[ -d "$full_path" ]]; then
        chmod -R 775 "$full_path"
        chown -R $WEB_USER:$WEB_USER "$full_path"
    fi
done

# Git Configuration
git config --global --add safe.directory "$APP_DIR"

# Initialize Git repository if missing
if [[ ! -d "$APP_DIR/.git" ]]; then
    cd "$APP_DIR" || exit 1
    git init
    git remote add origin https://github.com/Qwerty-Systems/itflow
    git fetch --depth=1
    git reset --hard origin/main
    git config core.fileMode false
fi

# Final permissions cleanup
chown -R $WEB_USER:$WEB_USER "$APP_DIR/.git"
find "$APP_DIR/.git" -type d -exec chmod 755 {} \;
find "$APP_DIR/.git" -type f -exec chmod 644 {} \;

# Restart PHP-FPM (container-safe)
if command -v php-fpm8.3 &> /dev/null; then
    kill -USR2 1  # Graceful restart for PHP-FPM in containers
fi

echo "Setup completed successfully"
