#!/bin/sh

# Default HTML folder path
HTML_DIR=${HTML_DIR:-/home/nginx/uploads}

# Path to the nginx config file
CONF_FILE="/etc/nginx/conf.d/default.conf"

# Modify default.conf to point to the correct HTML directory
if sed -i "s|root[[:space:]]*/usr/share/nginx/html;|root $HTML_DIR;|" "$CONF_FILE"; then
    echo "$(date) - Successfully updated root directive in $CONF_FILE to $HTML_DIR" >> /var/log/nginx/setup.log
else
    echo "$(date) - Error: Failed to update root directive in $CONF_FILE" >> /var/log/nginx/setup.log
    exit 1
fi

# Start Nginx
nginx -g "daemon off;"
