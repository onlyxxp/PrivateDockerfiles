#FROM debian:bullseye-slim
#FROM zyallday/snell-server:v4
#FROM --platform=$BUILDPLATFORM rust:.20 AS builder
#FROM zyallday/snell-server:v4  AS builder
#FROM alpine:3.20
#FROM frolvlad/alpine-glibc  AS builder
FROM frolvlad/alpine-glibc:alpine-3.19_glibc-2.34 AS builder
LABEL maintainer="metowolf <i@i-meto.com>"


#RUN set -x  && apk add libstdc++6 libstdc++

#RUN set -x \
#   && apk add --no-cache build-base cmake llvm15-dev clang15-libclang clang15 rust-bindgen  unzip dumb-init  wget
# NOTE: Glibc 2.35 package is broken: https://github.com/sgerrand/alpine-pkg-glibc/issues/176, so we stick to 2.34 for now
#RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
#RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk


ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.1
ARG SNELL_VERSION=4.0.1

RUN cd /tmp

##shadow-tls
RUN wget  -O /usr/bin/shadow-tls https://github.com/ihciah/shadow-tls/releases/latest/download/shadow-tls-x86_64-unknown-linux-musl  && chmod +x /usr/bin/shadow-tls
   
RUN shadow-tls --help

#ss 
RUN TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | cut -d '"' -f4)  \
  && wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks-rust/releases/download/$TAG/shadowsocks-$TAG.x86_64-unknown-linux-gnu.tar.xz \
  && tar xvf shadowsocks.zip \
  && mv ssserver /usr/bin/ssserver

#snell 
ENV SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip
RUN wget --no-check-certificate -O snell-server.zip $SNELL_URL && unzip snell-server.zip && 	rm -f snell-server.zip && 	chmod +x snell-server  && mv snell-server /usr/bin/
RUN set -x  && snell-server --help

RUN ssserver --help
RUN rm -rf /tmp/* 



#FROM zyallday/snell-server:v4
#FROM frolvlad/alpine-glibc
FROM frolvlad/alpine-glibc:alpine-3.19_glibc-2.34
COPY --from=builder /usr/bin/snell-server /usr/bin/
COPY --from=builder /usr/bin/ssserver /usr/bin/
COPY --from=builder /usr/bin/shadow-tls /usr/bin/



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
