#!/bin/bash

# Fix PHP Extensions (Install mailparse)
# --------------------------------------
# For Debian/Ubuntu-based systems:
apt-get update && apt-get install -y php-mailparse

# Adjust PHP Configuration
# ------------------------
PHP_INI=$(php -i | grep 'Loaded Configuration File' | awk '{print $NF}')
[[ -z "$PHP_INI" ]] && PHP_INI="/etc/php/8.3/cli/php.ini"

sed -i "s/^\(upload_max_filesize\s*=\s*\).*\$/\1500M/" "$PHP_INI"
sed -i "s/^\(post_max_size\s*=\s*\).*\$/\1500M/" "$PHP_INI"

# Install Missing Shell Tools
# ---------------------------
apt-get install -y whois dnsutils git

# Clone Repository if Missing
# ---------------------------
APP_DIR="/app"
GIT_REPO="https://github.com/Qwerty-Systems/itflow"

if [[ ! -d "$APP_DIR/.git" ]]; then
    echo "Cloning application repository..."
    
    if [ -z "$(ls -A $APP_DIR)" ]; then
        # Directory is empty, safe to clone
        git clone "$GIT_REPO" "$APP_DIR"
    else
        # Directory contains files, init repo and pull
        echo "Initializing git in existing directory..."
        cd "$APP_DIR" || exit 1
        git init
        git remote add origin "$GIT_REPO"
        git fetch
        git checkout main  # or your branch name
    fi
fi

# Fix File Permissions
# --------------------
WEB_USER="www-data"
chown -R $WEB_USER:$WEB_USER "$APP_DIR"
find "$APP_DIR" -type d -exec chmod 755 {} \;
find "$APP_DIR" -type f -exec chmod 644 {} \;

# Special write permissions
chmod -R 775 "$APP_DIR/storage"
chmod -R 775 "$APP_DIR/bootstrap/cache"

# Update Git Permissions
if [[ -d "$APP_DIR/.git" ]]; then
    chown -R $WEB_USER:$WEB_USER "$APP_DIR/.git"
    find "$APP_DIR/.git" -type d -exec chmod 755 {} \;
    find "$APP_DIR/.git" -type f -exec chmod 644 {} \;
fi

# Restart PHP service
systemctl restart php8.3-fpm

echo "Post-install script completed"
