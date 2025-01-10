FROM --platform=$BUILDPLATFORM debian:bullseye-slim AS builder
LABEL maintainer="debian <i@i-debian.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.24.1
ARG SNELL_VERSION=4.1.1

RUN apt-get update && apt-get install -y wget unzip  dumb-init  xz-utils unzip tar

RUN mkdir -p /user/local/temp-build

################ download & install  ###############
##snell 
RUN wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-v$SNELL_VERSION-linux-amd64.zip \
  && unzip snell-server.zip \
  && mv snell-server /user/local/temp-build/

RUN /user/local/temp-build/snell-server --help

##shadow-tls
RUN wget  -O /user/local/temp-build/shadow-tls https://github.com/ihciah/shadow-tls/releases/latest/download/shadow-tls-x86_64-unknown-linux-musl \
    && chmod +x /user/local/temp-build/shadow-tls

##ss 
RUN TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | cut -d '"' -f4)  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/$TAG/shadowsocks-$TAG.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv ssserver /user/local/temp-build/

RUN /user/local/temp-build/ssserver --help

##v2ray plugin 
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && \
    tar xf *.gz && \
    mv v2ray* /user/local/temp-build/v2ray-plugin && \
    chmod +x /user/local/temp-build/v2ray-plugin  && \
    /user/local/temp-build/v2ray-plugin -version


################ pack clean image ###############
FROM debian:bullseye-slim AS ss-server-v2ray

COPY --from=builder /user/local/temp-build/* /usr/bin/

COPY snell-server.conf /etc/snell/snell-server.conf
RUN /usr/bin/snell-server --help
# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    LISTEN=0.0.0.0:9000

COPY config.json /etc/shadowsocks-rust/
RUN /usr/bin/ssserver --help 
COPY entrypoint.sh  /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
# 添加默认环境变量
ENV SS_LISTEN=8388 \
    SS_PWD=12aa.345g \
    SS_METHOD=aes-256-gcm \
    SS_MOD=tcp_and_udp \ 
    SS_TIMEOUT=600

ENV TZ=Asia/Shanghai

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "echo", "hello!" ]
