FROM debian:11.2-slim as builder

ENV GOLANG_VERSION=go1.18.9.linux-amd64
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin
#ENV CGO_CFLAGS="${CGO_CFLAGS} -I$(go env GOPATH)/deps/dqlite/include/ -I$(go env GOPATH)/deps/raft/include/"
#ENV CGO_LDFLAGS="${CGO_LDFLAGS} -L$(go env GOPATH)/deps/dqlite/.libs/ -L$(go env GOPATH)/deps/raft/.libs/"
#ENV LD_LIBRARY_PATH="$(go env GOPATH)/deps/dqlite/.libs/:$(go env GOPATH)/deps/raft/.libs/:${LD_LIBRARY_PATH}"
#ENV CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"


RUN apt update && apt install -y liblz4-dev wget curl build-essential shellcheck git dh-autoreconf libsqlite3-dev

RUN cd /opt && wget https://dl.google.com/go/$GOLANG_VERSION.tar.gz && \
    tar xf $GOLANG_VERSION.tar.gz
RUN ln -s /opt/go/bin/go /usr/bin/go
RUN mkdir -p $GOPATH
RUN echo -n "GO version: " && go version
RUN echo -n "GOPATH: " && echo $GOPATH


RUN mkdir -p $GOPATH/src/
COPY .  $GOPATH/src/

WORKDIR $GOPATH/src/

RUN make deps 
