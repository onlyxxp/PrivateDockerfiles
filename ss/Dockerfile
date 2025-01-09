FROM debian:bullseye-slim

LABEL maintainer="123123123" \
      shadowsocks-rust="https://github.com/shadowsocks/shadowsocks-rust" \
      v2ray-plugin="https://github.com/shadowsocks/v2ray-plugin"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.22.0


ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 1080
ENV PASSWORD    password
ENV METHOD      aes-128-gcm
ENV OBFS_PLUGIN v2ray-plugin
ENV OBFS_OPTS   server
ENV ARGS=

RUN apt-get update \
  && apt-get install -y \
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
  && wget -O shadowsocks.tar.xz https://github.com/shadowsocks/shadowsocks-rust/releases/download/v$VERSION/shadowsocks-v$VERSION.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvzf shadowsocks.tar.xz -C /root \
  &&  mv /root/ssserver /usr/local/bin/ssserver \
  && rm -rf shadowsocks.tar.xz \
  && ssserver --help \
  \
  && apt-get remove -y \
    wget \
    unzip \
  && rm -rf /var/lib/apt/lists/*



USER nobody

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
