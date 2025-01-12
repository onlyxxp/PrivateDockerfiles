#!/bin/sh
# vim:sw=4:ts=4:et

echo "\033[32m :::entrypoint begin::: \033[0m"

# shadow-tls
if [ "${ENABLE_SHADOW_TLS}"  = "true" ]; then
  echo "The environment ENABLE_SHADOW_TLS is set to: ${ENABLE_SHADOW_TLS}"
  shadow-tls --fastopen --v3 server --listen ::0:$SHADOW_PORT --server 127.0.0.1:$SNELL_LISTEN --tls  $SHADOW_HOST --password $SHADOW_PWD &
else
  echo "The environment ENABLE_SHADOW_TLS is  ${ENABLE_SHADOW_TLS}， not set true. not start shadow tls"
fi

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



