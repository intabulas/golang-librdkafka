FROM amd64/ubuntu:devel

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

RUN wget https://github.com/edenhill/librdkafka/archive/v1.2.1.tar.gz \
  && tar -xvf v1.2.1.tar.gz  \
  && cd librdkafka-1.2.1 \
  && ./configure --install-deps \
  && make \
  && make install



RUN curl -O https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz \
  && tar -xvf go1.13.1.linux-amd64.tar.gz \
  && mv go /usr/local

RUN mkdir /go
ENV GOPATH /go
ENV PATH "$GOPATH/bin:/usr/local/go/bin:$PATH"

RUN export GOOS="$(go env GOOS)"
ENV export GOARCH="$(go env GOARCH)"
ENV export GOHOSTOS="$(go env GOHOSTOS)"
ENV export GOHOSTARCH="$(go env GOHOSTARCH)"


RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -u github.com/goreleaser/nfpm/...
WORKDIR $GOPATH
