FROM debian:11.2-slim as builder

ENV GOLANG_VERSION=go1.18.9.linux-amd64
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

RUN cd /opt && wget https://dl.google.com/go/$GOLANG_VERSION.tar.gz && \
    tar xf $GOLANG_VERSION.tar.gz
RUN ln -s /opt/go/bin/go /usr/bin/go
RUN mkdir -p $GOPATH
RUN echo -n "GO version: " && go version
RUN echo -n "GOPATH: " && echo $GOPATH

RUN apt update && apt install -y liblz4-dev wget curl build-essential

RUN mkdir -p $GOPATH/src/
COPY .  $GOPATH/src/

WORKDIR $GOPATH/src/

RUN make deps 
