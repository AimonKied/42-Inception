#!/bin/bash

set -e

# Generate self-signed SSL cert if not present
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=DE/ST=BW/L=Heilbronn/O=42/CN=${DOMAIN_NAME}"
fi

exec nginx -g "daemon off;"
