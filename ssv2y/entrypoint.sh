#!/bin/sh
# vim:sw=4:ts=4:et

echo -e  "\033[32m :::entrypoint begin::: \033[0m"

# shadow-tls
if [ "${ENABLE_SHADOW_TLS}"  = "true" ]; then
  echo -e  "\033[33m The environment ENABLE_SHADOW_TLS is set to: ${ENABLE_SHADOW_TLS}\033[0m"
  shadow-tls --fastopen --v3 server --listen ::0:$SHADOW_PORT --server 127.0.0.1:$SNELL_LISTEN --tls  $SHADOW_HOST --password $SHADOW_PWD &
else
  echo -e  "\033[33m The environment ENABLE_SHADOW_TLS is  ${ENABLE_SHADOW_TLS}， not set true. not start shadow tls\033[0m"
fi

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
snell-server --loglevel=info -c /etc/snell/snell-server.conf&

/bin/sh

#exec "$@"



