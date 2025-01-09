#!/bin/sh
# vim:sw=4:ts=4:et

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
    "timeout": '"$SS_TIMEOUT"',
    "method": "'"$SS_METHOD"'",
    "plugin" : "'"$PLUGIN"'",
    "plugin_opts" : "'"$PLUGIN_OPTS"'"
}' > /etc/shadowsocks-rust/config.json
cat /etc/shadowsocks-rust/config.json
ssserver --log-without-time -a nobody -c /etc/shadowsocks-rust/config.json
#exec "$@"


echo "end ~~~~"
