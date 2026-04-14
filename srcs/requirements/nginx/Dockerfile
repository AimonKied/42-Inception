FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/wordpress
RUN ln -sf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress \
    && rm -f /etc/nginx/sites-enabled/default

COPY tools/setup-nginx.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-nginx.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/setup-nginx.sh"]
