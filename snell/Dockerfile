FROM debian:buster-slim
LABEL maintainer="metowolf <i@i-meto.com>"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=4.0.1

RUN apt-get update \
  && apt-get install -y \
    wget \
    unzip \
    tini \
  \
  && if [ "$TARGETARCH" = "arm64" ]; then TARGETARCH="aarch64"; fi \
  \
  && wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-v$VERSION-$TARGETOS-$TARGETARCH.zip \
  && unzip snell-server.zip \
  && mv snell-server /usr/local/bin \
  && rm -rf snell-server.zip \
  && snell-server --help \
  \
  && apt-get remove -y \
    wget \
    unzip \
  && rm -rf /var/lib/apt/lists/*

COPY snell-server.conf /etc/snell/snell-server.conf
COPY entrypoint.sh /entrypoint.sh

VOLUME /etc/snell
ENV TZ=Asia/Shanghai
CMD [ "snell-server", "-c", "/etc/snell/snell-server.conf" ]
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]