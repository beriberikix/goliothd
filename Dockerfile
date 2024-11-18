FROM debian:stable-slim AS build

WORKDIR /src

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  build-essential \
  ca-certificates \
  cmake \
  git \
  libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  git clone https://github.com/beriberikix/goliothd.git \
  && cd goliothd \
  && chmod +x build.sh \
  && ./build.sh

FROM debian:stable-slim

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  openssl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /src/goliothd/build/goliothd /usr/local/bin

CMD ["/usr/local/bin/goliothd"]
