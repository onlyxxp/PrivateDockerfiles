#!/bin/sh

if [ ! -z "$PSK" ]; then
  sed -i "s/psk = .*/psk = $PSK/" /etc/snell/snell-server.conf
fi

if [ ! -z "$LISTEN" ]; then
  sed -i "s/listen = .*/listen = $LISTEN/" /etc/snell/snell-server.conf
fi

exec "$@"