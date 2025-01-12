#FROM debian:bullseye-slim  AS builder
#FROM --platform=$BUILDPLATFORM rust:.20 AS builder
#FROM zyallday/snell-server:v4  AS builder
#FROM alpine:3.20   AS builder
FROM --platform=$BUILDPLATFORM alpine:3.21 AS builder
#FROM frolvlad/alpine-glibc  AS builder
#FROM frolvlad/alpine-glibc:alpine-3.19_glibc-2.34 AS builder

LABEL maintainer="metowolf <i@i-meto.com>"


ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.1
ARG SNELL_VERSION=4.0.1



RUN set -x \
    && apk add --no-cache xz


#ss 
RUN TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | cut -d '"' -f4)  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/$TAG/shadowsocks-$TAG.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv -v ssserver /usr/bin/ssserver
  && ls -l /usr/bin/ssserver
#RUN set -x && ssserver --help

#snell 
ENV SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip
RUN wget --no-check-certificate -O snell-server.zip $SNELL_URL && unzip snell-server.zip && 	rm -f snell-server.zip && 	chmod +x snell-server  && mv snell-server /usr/bin/
#RUN set -x  && snell-server --help



FROM alpine:3.21 AS snell
#FROM alpine:3.20
#FROM zyallday/snell-server:v4
#FROM frolvlad/alpine-glibc
#FROM frolvlad/alpine-glibc:alpine-3.19_glibc-2.34


COPY --from=builder /usr/bin/snell-server /usr/bin/
COPY --from=builder /usr/bin/ssserver /usr/bin/

RUN set -x && /usr/bin/ssserver --help

# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    LISTEN=0.0.0.0:9000

VOLUME /etc/snell
ENV TZ=Asia/Shanghai
CMD [ "snell-server", "-c", "/etc/snell/snell-server.conf" ]
ENTRYPOINT [ "dumb-init", "--", "/entrypoint.sh" ]
