#FROM alpine:3.21
FROM debian:bullseye-slim
#FROM --platform=$BUILDPLATFORM rust:alpine3.20 AS builder
LABEL maintainer="metowolf <i@i-meto.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.22.0
ARG PLUGIN_VERSION=1.3.2

RUN apt-get update \
  && apt-get install -y \
    xz-utils \
    tar \
    wget \
    unzip \
    dumb-init \
  \
  && case "$TARGETARCH" in \
       "amd64") SNELL_ARCH="x86_64" ;; \
       "arm64") SNELL_ARCH="aarch64" ;; \
       *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
     esac \
  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/v$VERSION/shadowsocks-v$VERSION.$SNELL_ARCH-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv ssserver /usr/local/bin/  \
  && rm -rf shadowsocks.zip  \
  && ssserver --help 
  
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && \
    tar xf *.gz && \
    rm *.gz && \
    mv v2ray* /usr/bin/v2ray-plugin && \
    chmod +x /usr/bin/v2ray-plugin  && \
    v2ray-plugin -version

RUN apt-get remove -y \
    wget \
    unzip \
  && rm -rf /var/lib/apt/lists/*

COPY config.json /etc/shadowsocks-rust/
COPY entrypoint.sh  /

chmod +x /entrypoint.sh

# 添加默认环境变量
ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 1080
ENV PASSWORD    password
ENV METHOD      aes-128-gcm
ENV OBFS_PLUGIN v2ray-plugin
ENV OBFS_OPTS   server
ENV ARGS=

# 更新入口脚本，支持环境变量
CMD [ "ssserver", "--log-without-time", "-a", "nobody", "-c", "/etc/shadowsocks-rust/config.json" ]
ENTRYPOINT [ "dumb-init", "--", "/entrypoint.sh" ]
