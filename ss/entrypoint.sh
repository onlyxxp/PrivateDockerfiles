#!/bin/sh
# vim:sw=4:ts=4:et

echo ":::entrypoint begin:::"

echo "[snell-server]
listen = $LISTEN
psk = $PSK
ipv6 = false" > /etc/snell/snell-server.conf

cat /etc/snell/snell-server.conf
snell-server -c /etc/snell/snell-server.conf&



echo '{
    "server": "'"$SERVER"'",
    "server_port": '"$SERVER_PORT"',
    "mode": "'"$MOD"'",
    "password": "'"$PASSWORD"'",
    "timeout": '"$TIMEOUT"',
    "method": "'"$METHOD"'",
    "plugin" : "'"$PLUGIN"'",
    "plugin_opts" : "'"$PLUGIN_OPTS"'"
}' > /etc/shadowsocks-rust/config.json
cat /etc/shadowsocks-rust/config.json
echo ":::entrypoint end:::"
exec "$@"
#REAL CMD
ssserver --log-without-time -a nobody -c /etc/shadowsocks-rust/config.json





