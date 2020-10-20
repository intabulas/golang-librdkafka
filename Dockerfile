FROM amd64/ubuntu:devel

LABEL name="Go Node Bedrock"
LABEL maintainer="mlussier@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  # librdkafka-dev \
  pkg-config \
  curl \
  gcc \
  g++ \
  git \
  wget \
  libc6-dev \
  libpcre++-dev \
  make \
  libsasl2-dev \
  xz-utils \
  libssl-dev \
  libzstd-dev \
  software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://github.com/edenhill/librdkafka/archive/v1.5.2.tar.gz \
  && tar -xvf v1.5.2.tar.gz  \
  && cd librdkafka-1.5.2 \
  && ./configure --install-deps \
  && make \
  && make install


RUN curl -O https://dl.google.com/go/go1.15.3.linux-amd64.tar.gz \
  && tar -xvf go1.15.3.linux-amd64.tar.gz \
  && mv go /usr/local

RUN mkdir /go
ENV GOPATH /go
ENV PATH "$GOPATH/bin:/usr/local/go/bin:$PATH"

RUN export GOOS="$(go env GOOS)"
ENV export GOARCH="$(go env GOARCH)"
ENV export GOHOSTOS="$(go env GOHOSTOS)"
ENV export GOHOSTARCH="$(go env GOHOSTARCH)"

RUN curl -fsSLO --compressed "https://github.com/goreleaser/nfpm/releases/download/v1.8.0/nfpm_1.8.0_Linux_x86_64.tar.gz" \
  && tar -xzvf "nfpm_1.8.0_Linux_x86_64.tar.gz" -C /usr/local/bin  --no-same-owner

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH
