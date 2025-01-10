#FROM debian:bullseye-slim
#FROM zyallday/snell-server:v4
#FROM --platform=$BUILDPLATFORM rust:.20 AS builder

FROM alpine:3.20
LABEL maintainer="metowolf <i@i-meto.com>"

ENV LANG=C.UTF-8

# NOTE: Glibc 2.35 package is broken: https://github.com/sgerrand/alpine-pkg-glibc/issues/176, so we stick to 2.34 for now
RUN set -x \
    && apk add --no-cache build-base cmake llvm15-dev clang15-libclang clang15 rust-bindgen  unzip dumb-init  wget



ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.0
ARG SNELL_VERSION=4.0.1

ENV SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip

#snell 
RUN wget --no-check-certificate -O snell-server.zip $SNELL_URL
RUN unzip snell-server.zip && 	rm -f snell-server.zip && 	chmod +x snell-server
RUN ls -l
RUN pwd
RUN  mv snell-server /usr/bin/

#RUN snell-server --help

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
