#!/bin/sh
# vim:sw=4:ts=4:et

echo ":::entrypoint begin:::"

# 添加默认环境变量
export SS_LISTEN=8388
export SS_PWD=12aa.345g 
export SS_METHOD=aes-256-gcm
export SS_MOD=tcp_and_udp 
export SS_TIMEOUT=600

# 添加默认环境变量
export PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK
export LISTEN=0.0.0.0:9000

echo "[snell-server]
listen = $LISTEN
psk = $PSK
ipv6 = false" > /etc/snell/snell-server.conf

cat /etc/snell/snell-server.conf
snell-server -c /etc/snell/snell-server.conf&

export SHADOW_PORT=8443
#shadow-tls --fastopen --v3 server --listen ::0:$SHADOW_PORT --server 127.0.0.1:18080 --tls  publicassets.cdn-apple.com --password JsJeWtjiUyJ5ye &

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



