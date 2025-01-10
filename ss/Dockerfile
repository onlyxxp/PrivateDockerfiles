#FROM --platform=$BUILDPLATFORM debian:bullseye-slim AS builder
FROM --platform=$BUILDPLATFORM  frolvlad/alpine-glibc  AS builder
LABEL maintainer="debian <i@i-debian.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=2.0
ARG SNELL_VERSION=4.1.1

#RUN ldd --version

#RUN apt-get update && apt-get install -y wget unzip  dumb-init  xz-utils unzip tar
RUN apk apk update && apk add --no-cache wget unzip  dumb-init  xz unzip tar

RUN mkdir -p /user/local/temp-build

################ download & install  ###############
##snell 
RUN wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-v$SNELL_VERSION-linux-amd64.zip \
  && unzip snell-server.zip \
  && mv snell-server /user/local/temp-build/snell-server

RUN /user/local/temp-build/snell-server --help

##shadow-tls
RUN wget  -O /user/local/temp-build/shadow-tls https://github.com/ihciah/shadow-tls/releases/latest/download/shadow-tls-x86_64-unknown-linux-musl \
    && chmod +x /user/local/temp-build/shadow-tls

##ss 
RUN TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | cut -d '"' -f4)  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/$TAG/shadowsocks-$TAG.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv ssserver /user/local/temp-build/ssserver

RUN /user/local/temp-build/ssserver --help

##v2ray plugin 
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && \
    tar xf *.gz && \
    mv v2ray-plugin_linux_amd64 /user/local/temp-build/v2ray-plugin && \
    chmod +x /user/local/temp-build/v2ray-plugin  && \
    /user/local/temp-build/v2ray-plugin -version


################ pack clean image ###############
#FROM debian:bullseye-slim AS ss-server-v2ray
FROM frolvlad/alpine-glibc AS ss-server-v2ray

COPY --from=builder /user/local/temp-build/* /usr/bin/

COPY snell-server.conf /etc/snell/snell-server.conf
RUN /usr/bin/snell-server --help


COPY config.json /etc/shadowsocks-rust/
RUN /usr/bin/ssserver --help 
COPY entrypoint.sh  /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh


ENV TZ=Asia/Shanghai
# snell
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    SNELL_LISTEN=9000
# shadow_tls
ENV SHADOW_PORT=1010 \
    SHADOW_PWD=JsJeWtjiUyJ5ye \
    SHADOW_HOST=publicassets.cdn-apple.com
# SS
ENV SERVER=0.0.0.0 \
    SERVER_PORT=8388 \
    PWD=12aa.345g  \
    METHOD=aes-256-gcm \
    MOD=tcp_and_udp  \
    TIMEOUT=600

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "echo", "hello!" ]
