#!/bin/sh

if [ ! -d ./vendor ]; then
  composer install
fi

if [ -z "$1" ]; then
  /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
else
  $*
fi
