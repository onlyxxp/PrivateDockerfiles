#!/bin/sh
# vim:sw=4:ts=4:et


# ss-2022
echo -e  "\033[32m  run ss-2022 \033[0m"
ssserver  -c /etc/conf/conf_ss.json&


#tuic 
echo -e  "\033[32m  run tuic-v5 \033[0m"
tuic -c /etc/conf/conf_tuic.toml&


# 初始化snell v5
echo -e  "\033[32m  run snell v5 \033[0m"
# snell v4
snell-server --loglevel=info -c /etc/conf/conf_snellv5.conf&


# 初始化snell v3
echo -e  "\033[32m  run snell v3 \033[0m"
# snell v3
snell-server3 --loglevel=info -c /etc/conf/conf_snellv3.conf



#exec "$@"



