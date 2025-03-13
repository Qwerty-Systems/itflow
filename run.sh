#!/bin/bash

# Set Git configuration
git config --global --add safe.directory /app
git config --global init.defaultBranch main

APP_DIR="/app"
GIT_REPO="https://github.com/Qwerty-Systems/itflow"
WEB_USER="www-data"

# Initialize Git repository (only if missing)
if [[ ! -d "$APP_DIR/.git" ]]; then
    echo "Initializing Git repository..."
    cd "$APP_DIR" || exit 1
    
    # Initialize bare repository
    git init
    
    # Configure remote
    git remote add origin "$GIT_REPO"
    
    # Fetch repository metadata without checking out files
    git fetch --depth=1
    
    # Set branch reference without modifying working tree
    git symbolic-ref HEAD refs/remotes/origin/main
    git reset --hard HEAD
fi

# Set permissions for entire application directory
echo "Setting permissions..."
chown -R $WEB_USER:$WEB_USER "$APP_DIR"
find "$APP_DIR" -type d -exec chmod 755 {} \;
find "$APP_DIR" -type f -exec chmod 644 {} \;

# Special permissions for storage/cache directories (if they exist)
declare -a WRITABLE_DIRS=(
    "storage"
    "bootstrap/cache"
    "public/uploads"
    "tmp"
)

for dir in "${WRITABLE_DIRS[@]}"; do
    if [[ -d "$APP_DIR/$dir" ]]; then
        chmod -R 775 "$APP_DIR/$dir"
        chown -R $WEB_USER:$WEB_USER "$APP_DIR/$dir"
    fi
done

# Specific Git directory permissions
if [[ -d "$APP_DIR/.git" ]]; then
    chown -R $WEB_USER:$WEB_USER "$APP_DIR/.git"
    find "$APP_DIR/.git" -type d -exec chmod 755 {} \;
    find "$APP_DIR/.git" -type f -exec chmod 644 {} \;
fi

echo "Permissions and Git repository configured successfully"
