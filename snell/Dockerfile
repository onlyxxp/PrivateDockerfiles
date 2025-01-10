#FROM debian:bullseye-slim

FROM --platform=$BUILDPLATFORM rust:alpine3.20 AS builder

ARG TARGETARCH

RUN set -x \
    && apk add --no-cache build-base cmake llvm15-dev clang15-libclang clang15 rust-bindgen  unzip dumb-init  wget

LABEL maintainer="metowolf <i@i-meto.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.0
ARG SNELL_VERSION=4.1.1

##snell 
RUN cd /tmp
RUN wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-v$SNELL_VERSION-linux-amd64.zip 
RUN  unzip snell-server.zip 
RUN ls -l
RUN pwd
RUN  mv /tmp/snell-server /user/bin/snell-server

RUN /user/local/bin/snell-server --help

# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    LISTEN=0.0.0.0:9000

# 更新入口脚本，支持环境变量
RUN echo '#!/bin/sh\n\
mkdir -p /etc/snell\n\
echo "[snell-server]\n\
listen = $LISTEN\n\
psk = $PSK\n\
ipv6 = false" > /etc/snell/snell-server.conf\n\
exec "$@"' > /entrypoint.sh \
  && chmod +x /entrypoint.sh

VOLUME /etc/snell
ENV TZ=Asia/Shanghai
CMD [ "snell-server", "-c", "/etc/snell/snell-server.conf" ]
ENTRYPOINT [ "dumb-init", "--", "/entrypoint.sh" ]
