#FROM debian:bullseye-slim
#FROM zyallday/snell-server:v4
#FROM --platform=$BUILDPLATFORM rust:.20 AS builder

FROM frolvlad/alpine-glibc
LABEL maintainer="metowolf <i@i-meto.com>"

/bin/sh -c ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" &&     ALPINE_GLIBC_PACKAGE_VERSION="2.34-r0" &&     ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" &&     ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" &&     ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" &&     apk add --no-cache --virtual=.build-dependencies wget ca-certificates &&     echo         "-----BEGIN PUBLIC KEY-----        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m        y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu        tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp        m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY        KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc        Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m        1QIDAQAB        -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub" &&         wget             "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME"             "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME"             "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" &&         apk add --no-cache libstdc++             "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME"             "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME"             "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" &&         rm "/etc/apk/keys/sgerrand.rsa.pub" &&         /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true &&         echo "export LANG=$LANG" > /etc/profile.d/locale.sh &&                 apk del glibc-i18n &&         rm "/root/.wget-hsts" &&         apk del .build-dependencies &&         rm             "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME"             "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME"             "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

#RUN set -x \
#    && apk add --no-cache build-base cmake llvm15-dev clang15-libclang clang15 rust-bindgen  unzip dumb-init  wget



ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.0
ARG SNELL_VERSION=4.1.1

ENV SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip
RUN /bin/sh -c wget --no-check-certificate -O snell.zip $SNELL_URL && 	unzip snell.zip && 	rm -f snell.zip && 	chmod +x snell-server && 	mv snell-server /usr/bin/  # buildkit

##snell 
#RUN cd /tmp
#RUN wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-v$SNELL_VERSION-linux-amd64.zip 
#RUN unzip snell-server.zip 
#RUN ls -l
#RUN pwd
#RUN  mv /tmp/snell-server /user/bin/snell-server

#RUN /user/local/bin/snell-server --help

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
