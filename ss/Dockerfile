FROM debian:bullseye-slim
LABEL maintainer="metowolf <i@i-meto.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.22.0

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
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/v$VERSION/shadowsocks-v$VERSION.$SNELL_ARCH-unknown-linux-gnu.tar.xz \
  && tar xzvf shadowsocks.zip \
  && mv ssserver /usr/local/bin/  \
  && rm -rf shadowsocks.zip  \
  && ssserver --help \
  \
  && apt-get remove -y \
    wget \
    unzip \
  && rm -rf /var/lib/apt/lists/*

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
