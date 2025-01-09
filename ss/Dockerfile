FROM debian:bullseye-slim
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
  && ssserver --help \
  && wget -O v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v$PLUGIN_VERSION/v2ray-plugin-linux-$TARGETARCH-v$PLUGIN_VERSION.tar.gz \
  && tar xzvf v2ray-plugin.tar.gz \
  && mv v2ray-plugin_linux_$TARGETARCH /usr/local/bin/v2ray-plugin  \
  && rm -rf v2ray-plugin.tar.gz  \
  && v2ray-plugin -version  \
  \
  && apt-get remove -y \
    wget \
    unzip \
  && rm -rf /var/lib/apt/lists/*

# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    LISTEN=0.0.0.0:9000

# 更新入口脚本，支持环境变量
CMD exec ss-server \
      -s $SERVER_ADDR \
      -p $SERVER_PORT \
      -k $PASSWORD \
      -m $METHOD \
      --fast-open \
      -u \
      --plugin $OBFS_PLUGIN \
      --plugin-opts $OBFS_OPTS \
      $ARGS
