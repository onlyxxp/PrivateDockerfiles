#!/bin/sh
# vim:sw=4:ts=4:et

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "${RED} :::entrypoint begin::: ${NC}"

# v2ray
v2ray run -c /etc/v2ray/config.json&

# 初始化snell config
# dns = 1.1.1.1, 8.8.8.8, 2001:4860:4860::8888
echo "[snell-server]
listen = 0.0.0.0:$SNELL_LISTEN
psk = $PSK

ipv6 = false" > /etc/snell/snell-server.conf
cat /etc/snell/snell-server.conf
# snell
snell-server --loglevel=info -c /etc/snell/snell-server.conf

#exec "$@"



