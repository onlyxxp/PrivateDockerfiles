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



# ss-old
echo -e  "\033[32m  run ss-old \033[0m"
ssserver  -c /etc/conf/ss_old.json&

# ss-2022
echo -e  "\033[32m  run ss-2022 \033[0m"
ssserver  -c /etc/conf/ss_2022.json&


#tuic 
echo -e  "\033[32m  run tuic-v5 \033[0m"
tuic -c /etc/conf/tuic_config.toml&


# 初始化snell v4 config
# dns = 1.1.1.1, 8.8.8.8, 2001:4860:4860::8888
echo "[snell-server]
listen = 0.0.0.0:$SNELL_LISTEN
psk = $PSK
ipv6 = false" > /etc/snell/snell-serverv4.conf
cat /etc/snell/snell-serverv4.conf
echo -e  "\033[32m  run snell v4 \033[0m"
# snell v4
snell-server --loglevel=info -c /etc/snell/snell-serverv4.conf&



# 初始化snell v3 config
# dns = 1.1.1.1, 8.8.8.8, 2001:4860:4860::8888
echo "[snell-server]
listen = 0.0.0.0:$SNELL_LISTEN_V3
psk = $PSK
ipv6 = false" > /etc/snell/snell-serverv3.conf
cat /etc/snell/snell-serverv3.conf
echo -e  "\033[32m  run snell v3 \033[0m"
# snell v3
snell-server3 --loglevel=info -c /etc/snell/snell-serverv3.conf



#exec "$@"



