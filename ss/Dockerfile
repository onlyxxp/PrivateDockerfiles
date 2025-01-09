#FROM alpine:3.21
#FROM debian:bullseye-slim AS builder
FROM --platform=$BUILDPLATFORM rust:alpine3.20 AS builder
RUN set -x \
    && apk add --no-cache wget unzip dumb-init tar xz

LABEL maintainer="metowolf <i@i-meto.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.22.0.1
ARG SS_VERSION=1.22.0
ARG PLUGIN_VERSION=1.3.2
ARG SNELL_VERSION=4.1.1


################snell ###############
RUN apt-get update \
  && apt-get install -y \
    wget \
    unzip \
    dumb-init \
  \
  && case "$TARGETARCH" in \
       "amd64") SNELL_ARCH="amd64" ;; \
       "arm64") SNELL_ARCH="aarch64" ;; \
       *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
     esac \
  \
  && wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-v$SNELL_VERSION-$TARGETOS-$SNELL_ARCH.zip \
  && unzip snell-server.zip \
  && mv snell-server /usr/bin

RUN /usr/bin/snell-server --help

################ss ###############
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
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/v$SS_VERSION/shadowsocks-v$SS_VERSION.$SNELL_ARCH-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv ssserver /usr/bin/ 

RUN /usr/bin/ssserver --help
  
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && \
    tar xf *.gz && \
    rm *.gz && \
    mv v2ray* /usr/bin/v2ray-plugin && \
    chmod +x /usr/bin/v2ray-plugin  && \
    v2ray-plugin -version

################ss ###############


FROM alpine:3.21 AS ss-server-v2ray
COPY --from=builder /usr/bin/snell-server /usr/bin/
COPY snell-server.conf /etc/snell/snell-server.conf
RUN ls /usr/bin/s*
RUN /usr/bin/snell-server --help

COPY --from=builder /usr/bin/ssserver /usr/bin/
COPY config.json /etc/shadowsocks-rust/
COPY entrypoint.sh  /usr/bin/
RUN /usr/bin/ssserver --help 
COPY --from=builder /usr/bin/v2ray-plugin /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh


# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    LISTEN=0.0.0.0:9000

# 添加默认环境变量
ENV SS_LISTEN=8388 \
    SS_PWD=12aa.345g \
    SS_METHOD=aes-256-gcm \
    SS_MOD=tcp_and_udp \ 
    SS_TIMEOUT=600



ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "ssserver", "--log-without-time", "-a", "nobody", "-c", "/etc/shadowsocks-rust/config.json" ]
# 更新入口脚本，支持环境变量
