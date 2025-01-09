FROM shadowsocks/ssserver-rust:latest

LABEL maintainer="123123123" \
      shadowsocks-rust="https://github.com/shadowsocks/shadowsocks-rust" \
      v2ray-plugin="https://github.com/shadowsocks/v2ray-plugin"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.3.2




ENV HOST        mydomain.me

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 1080
ENV PASSWORD    password
ENV METHOD      chacha20-ietf-poly1305
ENV OBFS_PLUGIN v2ray-plugin
ENV OBFS_OPTS   server
ENV ARGS=

USER root

RUN set -ex \
 && apk add --no-cache --virtual .build-deps tar \
 && wget -cq -O /root/v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.0/v2ray-plugin-linux-amd64-8cea1a3.tar.gz \
 && tar xvzf /root/v2ray-plugin.tar.gz -C /root \
 && mv /root/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin \
 && rm -f /root/v2ray-plugin.tar.gz \
 && apk del .build-deps



RUN apt-get update \
  && apt-get install -y \
    tar \
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
  && wget -O v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v$VERSION/v2ray-plugin-$TARGETOS-$SNELL_ARCH-v$VERSION.tar.gz \
  && tar xvzf v2ray-plugin.tar.gz -C /root \
  &&  mv /root/v2ray-plugin_linux_$SNELL_ARCH /usr/local/bin/v2ray-plugin \
  && rm -rf v2ray-plugin.tar.gz \
  && v2ray-plugin --help \
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
