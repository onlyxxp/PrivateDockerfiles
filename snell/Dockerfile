#FROM debian:bullseye-slim  AS builder
#FROM --platform=$BUILDPLATFORM rust:.20 AS builder
#FROM zyallday/snell-server:v4  AS builder
#FROM alpine:3.20   AS builder
FROM --platform=$BUILDPLATFORM rust:alpine3.20 AS builder
#FROM frolvlad/alpine-glibc  AS builder
#FROM frolvlad/alpine-glibc:alpine-3.19_glibc-2.34 AS builder

LABEL maintainer="metowolf <i@i-meto.com>"


ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.1
ARG SNELL_VERSION=4.0.1



RUN set -x \
    && apk add --no-cache build-base cmake llvm15-dev clang15-libclang clang15 rust-bindgen

ENV GLIBC_VERSION 2.35-r1

# Download and install glibc
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add --force-overwrite glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  apk del curl && \
  rm -rf /var/cache/apk/* glibc.apk glibc-bin.apk

#RUN set -x  && apk add libstdc++6 libstdc++

#RUN set -x \
#   && apk add --no-cache build-base cmake llvm15-dev clang15-libclang clang15 rust-bindgen  unzip dumb-init  wget
# NOTE: Glibc 2.35 package is broken: https://github.com/sgerrand/alpine-pkg-glibc/issues/176, so we stick to 2.34 for now
#RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
#RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk

RUN cd /tmp

#ss 
RUN TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | cut -d '"' -f4)  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/$TAG/shadowsocks-$TAG.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv ssserver /usr/bin/ssserver
#RUN set -x && ssserver --help

#snell 
ENV SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip
RUN wget --no-check-certificate -O snell-server.zip $SNELL_URL && unzip snell-server.zip && 	rm -f snell-server.zip && 	chmod +x snell-server  && mv snell-server /usr/bin/
#RUN set -x  && snell-server --help



FROM rust:alpine3.21 as snell
#FROM alpine:3.20
#FROM zyallday/snell-server:v4
#FROM frolvlad/alpine-glibc
#FROM frolvlad/alpine-glibc:alpine-3.19_glibc-2.34


COPY --from=builder /usr/bin/snell-server /usr/bin/
COPY --from=builder /usr/bin/ssserver /usr/bin/
# 添加默认环境变量
ENV PSK=uYQwNqZbaIOMiZ6Zni8v5x0M09Y8bSK \
    LISTEN=0.0.0.0:9000

VOLUME /etc/snell
ENV TZ=Asia/Shanghai
CMD [ "snell-server", "-c", "/etc/snell/snell-server.conf" ]
ENTRYPOINT [ "dumb-init", "--", "/entrypoint.sh" ]
