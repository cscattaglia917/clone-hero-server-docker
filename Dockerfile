FROM debian:buster-slim AS build-env
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /clonehero
RUN apt-get update \
 && apt-get install --no-install-recommends -y ca-certificates wget unzip curl jq libicu63 \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir config

ARG BRANCH=test
ARG VERSION=v1.0.0.3747-maste

COPY ./startup.sh .
COPY ./server-settings.ini ./config/

RUN if [ -z ${VERSION} ]; then VERSION=$(curl -s "https://dl$BRANCH.b-cdn.net/linux-index.json" | jq -r .[0].version | sed "s/v0/v/"); fi \
 && wget -qO chserver.zip https://pubdl.clonehero.net/chserver/ChStandaloneServer-$VERSION.zip \
 && unzip chserver.zip \
 && rm ./chserver.zip \
 && mv ./ChStandaloneServer-* ./chserver \
 && mv ./chserver/linux-x64 ./chserver/linux-x86_64 \
 && mv ./chserver/linux-arm64 ./chserver/linux-aarch64 \
 && mv ./chserver/linux-arm ./chserver/linux-armv7l \
 && mv ./chserver/linux-$(arch)/* . \
 && rm -rf ./chserver \
 && chmod +x ./Server \
 && chown -R 1000 ./config

FROM debian:buster-slim

RUN apt-get update \
 && apt-get install --no-install-recommends -y ca-certificates libicu63 libgssapi-krb5-2 \
 && rm -rf /var/lib/apt/lists/* \
 && ln -sf /usr/src/clonehero/Server /usr/bin/cloneheroserver \
 && useradd -m clonehero

WORKDIR /usr/src/clonehero
COPY --from=build-env /clonehero .
USER clonehero

WORKDIR /usr/src/clonehero/config

EXPOSE 14242/udp
ENTRYPOINT ["../startup.sh"]
