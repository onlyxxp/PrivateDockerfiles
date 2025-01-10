#!/bin/sh
# vim:sw=4:ts=4:et

echo ":::entrypoint begin:::"

# 初始化snell config
echo "[snell-server]
listen = 0.0.0.0:$SNELL_LISTEN
psk = $PSK
ipv6 = false" > /etc/snell/snell-server.conf
cat /etc/snell/snell-server.conf
# snell
snell-server -c /etc/snell/snell-server.conf&

# shadow-tls
shadow-tls --fastopen --v3 server --listen ::0:$SHADOW_PORT --server 127.0.0.1:$SNELL_LISTEN --tls  $SHADOW_HOST --password $SHADOW_PWD &

# 初始化ss config
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
#SSSS
ssserver --log-without-time -a nobody -c /etc/shadowsocks-rust/config.json

#exec "$@"



