FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx
FROM frolvlad/alpine-glibc:alpine-3.16 AS builder
#FROM --platform=$BUILDPLATFORM alpine:3.21 AS builder
COPY --from=xx / /

# export TARGETPLATFORM (or other TARGET*)
ARG TARGETPLATFORM
ARG VERSION=2.0

RUN set -x &&  xx-info env && apk add --no-cache xz  && mkdir -p /usr/tmp/bin

#snell v3
ENV SNELL_URL_V3=https://raw.githubusercontent.com/xOS/Others/master/snell/v3.0.1/snell-server-v3.0.1-linux-amd64.zip
RUN wget --no-check-certificate -O snell-serverv3.zip $SNELL_URL_V3 && unzip snell-serverv3.zip && 	rm -f snell-serverv3.zip && 	chmod +x snell-server  && mv snell-server /usr/tmp/bin/snell-server3
#snell v4  https://manual.nssurge.com/others/snell.html
ENV SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip
RUN wget --no-check-certificate -O snell-server.zip $SNELL_URL && unzip snell-server.zip && 	rm -f snell-server.zip && 	chmod +x snell-server  && mv snell-server /usr/tmp/bin/
#shadow-tls
RUN wget  -O /usr/tmp/bin/shadow-tls https://github.com/ihciah/shadow-tls/releases/latest/download/shadow-tls-x86_64-unknown-linux-musl && chmod +x /usr/tmp/bin/shadow-tls

##v2ray    https://github.com/v2fly/v2ray-core/releases
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/v2fly/v2ray-core/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget -O v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/$TAG/v2ray-linux-64.zip && unzip v2ray.zip && \
    chmod +x v2ray && mv v2ray /usr/tmp/bin && mkdir -p /etc/v2ray/ && mv config.json /etc/v2ray/  && /usr/tmp/bin/v2ray version 
   # && mv *.dat /usr/tmp/bin/

#########################  pack image ########################
FROM frolvlad/alpine-glibc:alpine-3.16

#stdc++
RUN apk add --update --no-cache libstdc++ curl && mkdir -p /etc/v2ray/
#timezone
RUN apk add --no-cache tzdata && echo "Asia/Shanghai" > /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

COPY --from=builder /usr/tmp/bin/*     /usr/bin/
COPY --from=builder /etc/v2ray/        /etc/v2ray/

COPY snell-server.conf /etc/snell/
COPY config.json       /etc/v2ray/
COPY entrypoint.sh  /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# dry run
RUN set -x && ls -l /usr/bin/snell-server && snell-server --help  && snell-server3 --help  && v2ray version 

# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK SNELL_LISTEN=9000  SNELL_LISTEN_V3=9001
ENV SHADOW_PORT=1010    SHADOW_PWD=JsJeWtjiUyJ5ye   SHADOW_HOST=publicassets.cdn-apple.com   MONOIO_FORCE_LEGACY_DRIVER=1
ENV SERVER=0.0.0.0 SERVER_PORT=8388 PWD=12aa.345g    METHOD=aes-128-gcm  MOD=tcp_and_udp  TIMEOUT=600

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "echo", "hello!" ]
