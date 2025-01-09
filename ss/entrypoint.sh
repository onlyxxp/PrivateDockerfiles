#!/bin/bash

echo "start_apps begin"

echo "[snell-server]
listen = $LISTEN
psk = $PSK
ipv6 = false" > /etc/snell/snell-server.conf

cat /etc/snell/snell-server.conf
snell-server -c /etc/snell/snell-server.conf&



echo '{
    "server":"::",
    "server_port": '"$SS_LISTEN"',
    "mode":"'"$SS_MOD"'",
    "password": "'"$PASSWORD"'",
    "timeout": "'"$SS_TIMEOUT"'",
    "method": "'"$SS_METHOD"'"
}' > /etc/shadowsocks-rust/config.json
cat /etc/shadowsocks-rust/config.json

exec "$@"
