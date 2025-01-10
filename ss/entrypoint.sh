#!/bin/sh
# vim:sw=4:ts=4:et

echo ":::entrypoint begin:::"



# 添加默认环境变量
export PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK
export LISTEN=9000
# 初始化snell config
echo "[snell-server]
listen = 0.0.0.0:$SNELL_LISTEN
psk = $PSK
ipv6 = false" > /etc/snell/snell-server.conf

cat /etc/snell/snell-server.conf
snell-server -c /etc/snell/snell-server.conf&

#shadow_tls
export SHADOW_PORT=1010
export SHADOW_PWD=JsJeWtjiUyJ5ye
export SHADOW_HOST=publicassets.cdn-apple.com
#shadow-tls --fastopen --v3 server --listen ::0:$SHADOW_PORT --server 127.0.0.1:$SNELL_LISTEN --tls  $SHADOW_HOST --password $SHADOW_PWD &


# 添加默认环境变量
export SERVER=0.0.0.0
export SERVER_PORT=8388
export PWD=12aa.345g 
export METHOD=aes-256-gcm
export MOD=tcp_and_udp 
export TIMEOUT=600
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

#REAL CMD
ssserver --log-without-time -a nobody -c /etc/shadowsocks-rust/config.json

#exec "$@"



