FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx
FROM frolvlad/alpine-glibc:alpine-3.16 AS builder
#FROM --platform=$BUILDPLATFORM alpine:3.21 AS builder
COPY --from=xx / /

# export TARGETPLATFORM (or other TARGET*)
ARG TARGETPLATFORM
ARG VERSION=2.6

RUN set -x &&  xx-info env && apk add --no-cache xz

#snell 
ENV SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip
RUN wget --no-check-certificate -O snell-server.zip $SNELL_URL && unzip snell-server.zip && 	rm -f snell-server.zip && 	chmod +x snell-server  && mv snell-server /usr/bin/
##shadow-tls
RUN wget  -O /usr/bin/shadow-tls https://github.com/ihciah/shadow-tls/releases/latest/download/shadow-tls-x86_64-unknown-linux-musl && chmod +x /usr/bin/shadow-tls
#ss 
RUN TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | cut -d '"' -f4)  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/$TAG/shadowsocks-$TAG.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip && mv -v ssserver /usr/bin/ssserver  && ls -l /usr/bin/ssserver
##v2ray plugin 
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/teddysun/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/teddysun/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && tar xf *.gz && \
    mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin && chmod +x /usr/bin/v2ray-plugin  && /usr/bin/v2ray-plugin -version


#########################  pack image ########################
FROM frolvlad/alpine-glibc:alpine-3.16

RUN apk add --update --no-cache libstdc++

COPY --from=builder /usr/bin/snell-server /usr/bin/
COPY --from=builder /usr/bin/ssserver     /usr/bin/
COPY --from=builder /usr/bin/v2ray-plugin /usr/bin/
COPY --from=builder /usr/bin/shadow-tls   /usr/bin/

COPY snell-server.conf /etc/snell/snell-server.conf
COPY config.json /etc/shadowsocks-rust/
COPY entrypoint.sh  /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# dry run
RUN set -x && ls -l /usr/bin/snell-server && snell-server --help
RUN set -x && ls -l /usr/bin/ssserver && /usr/bin/ssserver --help

# 添加默认环境变量
#ENV TZ=Asia/Shanghai
#timezone
RUN apk add --no-cache tzdata && echo "Asia/Shanghai" > /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK SNELL_LISTEN=9000
ENV SHADOW_PORT=1010    SHADOW_PWD=JsJeWtjiUyJ5ye   SHADOW_HOST=publicassets.cdn-apple.com   MONOIO_FORCE_LEGACY_DRIVER=1
ENV SERVER=0.0.0.0 SERVER_PORT=8388 PWD=12aa.345g    METHOD=aes-128-gcm  MOD=tcp_and_udp  TIMEOUT=600

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "echo", "hello!" ]
