#!/bin/bash

set -e

# Read passwords from Docker secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

WP_PATH=/var/www/html/wordpress

# Wait for MariaDB to be reachable
until bash -c "echo > /dev/tcp/mariadb/3306" 2>/dev/null; do
    sleep 1
done

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    # Download WordPress core
    wp core download --path="$WP_PATH" --allow-root

    # Create wp-config.php
    wp config create \
        --path="$WP_PATH" \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost=mariadb \
        --allow-root

    # Install WordPress
    wp core install \
        --path="$WP_PATH" \
        --url="https://$DOMAIN_NAME" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root

    # Create second user (editor role)
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --role=editor \
        --user_pass="$WP_USER_PASSWORD" \
        --path="$WP_PATH" \
        --allow-root

    chown -R www-data:www-data "$WP_PATH"
fi

# Start php-fpm in foreground
exec php-fpm8.2 -F
