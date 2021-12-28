#!/bin/sh

if [ -z "$1" ]; then
  /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
else
  $*
fi
