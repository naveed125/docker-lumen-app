FROM alpine:3.14

# Install packages and remove default server definition
RUN apk --no-cache add \
  curl \
  nginx \
  php8 \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-fpm \
  php8-gd \
  php8-intl \
  php8-json \
  php8-mbstring \
  php8-mysqli \
  php8-opcache \
  php8-openssl \
  php8-phar \
  php8-session \
  php8-xml \
  php8-xmlreader \
  php8-zlib \
  php8-redis \
  supervisor

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/php8 /usr/bin/php

# Configure nginx
COPY container/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY container/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY container/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord and entrypoint
COPY container/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY container/supervisord.conf /etc/supervisord.conf
COPY container/entrypoint.sh /

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
COPY --chown=nobody src/ /var/www/

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/entrypoint.sh"]
