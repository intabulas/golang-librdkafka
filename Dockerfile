FROM amd64/ubuntu:devel

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  librdkafka-dev \
  golang \
  pkg-config \
  gcc \
  g++ \
  git \
  libc6-dev \
  libpcre++-dev \
  make \
  xz-utils \
  software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /go

ENV GOPATH /go
RUN export GOOS="$(go env GOOS)"
ENV export GOARCH="$(go env GOARCH)"
ENV export GOHOSTOS="$(go env GOHOSTOS)"
ENV export GOHOSTARCH="$(go env GOHOSTARCH)"
ENV PATH "$GOPATH/bin:/usr/local/go/bin:$PATH"

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get -u github.com/golang/dep/cmd/dep
WORKDIR $GOPATH
