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
  php8-xmlwriter \
  php8-tokenizer \
  php8-pdo \
  php8-pdo_mysql \
  supervisor

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/php8 /usr/bin/php

# Add composer
RUN curl -sS https://getcomposer.org/installer | php && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer

# Configure nginx
COPY container/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY container/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY container/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord and entrypoint
COPY container/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY container/entrypoint.sh /entrypoint.sh

# Add application
WORKDIR /var/www
COPY src/ /var/www/

# Install composer dependencies
RUN composer install --prefer-dist --no-dev

# Expose the port nginx is reachable on
EXPOSE 80

# Entrypoint script starts supervisord
# Use it for any processing during container launch
# Example generate .env file from a secrets manager
ENTRYPOINT ["/entrypoint.sh"]
