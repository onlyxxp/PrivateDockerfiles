FROM --platform=$BUILDPLATFORM debian:bullseye-slim AS builder
LABEL maintainer="debian <i@i-debian.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.24.1
ARG SNELL_VERSION=4.1.1

RUN apt-get update && apt-get install -y wget unzip  dumb-init  xz-utils unzip tar

################snell ###############
RUN wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-v$SNELL_VERSION-linux-amd64.zip \
  && unzip snell-server.zip \
  && mv snell-server /usr/bin

RUN /usr/bin/snell-server --help

################ss ###############
RUN TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | cut -d '"' -f4)  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/$TAG/shadowsocks-$TAG.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv ssserver /usr/bin/ 

RUN /usr/bin/ssserver --help

################ v2ray ###############
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && \
    tar xf *.gz && \
    rm *.gz && \
    mv v2ray* /usr/bin/v2ray-plugin && \
    chmod +x /usr/bin/v2ray-plugin  && \
    v2ray-plugin -version


################ pack clean image ###############
FROM debian:bullseye-slim AS ss-server-v2ray

COPY --from=builder /usr/bin/snell-server /usr/bin/
COPY snell-server.conf /etc/snell/snell-server.conf
RUN ls /usr/bin/s*
RUN /usr/bin/snell-server --help
# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    LISTEN=0.0.0.0:9000

COPY --from=builder /usr/bin/ssserver /usr/bin/
COPY config.json /etc/shadowsocks-rust/
RUN /usr/bin/ssserver --help 
COPY --from=builder /usr/bin/v2ray-plugin /usr/bin/
COPY entrypoint.sh  /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
# 添加默认环境变量
ENV SS_LISTEN=8388 \
    SS_PWD=12aa.345g \
    SS_METHOD=aes-256-gcm \
    SS_MOD=tcp_and_udp \ 
    SS_TIMEOUT=600

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "echo", "hello!" ]
