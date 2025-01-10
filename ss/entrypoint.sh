#!/bin/sh
# vim:sw=4:ts=4:et

echo ":::entrypoint begin:::"

echo "[snell-server]
listen = $LISTEN
psk = $PSK
ipv6 = false" > /etc/snell/snell-server.conf

cat /etc/snell/snell-server.conf
snell-server -c /etc/snell/snell-server.conf&

export SHADOW_PORT=8443
shadow-tls --fastopen --v3 server --listen ::0:$SHADOW_PORT --server 127.0.0.1:$LISTEN --tls  publicassets.cdn-apple.com &

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

#REAL CMD
ssserver --log-without-time -a nobody -c /etc/shadowsocks-rust/config.json

#exec "$@"



