FROM alpine:edge AS builder
MAINTAINER Michalski Luc <lmichalski@evolutive-business.com>

RUN apk add --no-cache --no-progress cmake make gcc g++ musl-dev mariadb-connector-c-dev zlib-dev glib-dev libressl-dev pkgconfig mariadb-client

WORKDIR /opt/service
COPY . .

RUN mkdir build && \
    cd build && \
    pkg-config gthread-2.0 && \
    pkg-config glib-2.0 && \
    cmake -DCMAKE_BUILD_TYPE=Release -DGLIB2_LIBRARIES=/usr/lib -DGLIB2_INCLUDE_DIR=/usr/include/glib-2.0 -DGTHREAD2_LIBRARIES=/usr/lib -DBUILD_DOCS=OFF .. && \
    make -j$(grep processor /proc/cpuinfo | wc -l) && \
    make install

#FROM alpine:3.12 AS runtime
#COPY --from:builder 
#ENV PATH=$PATH:/usr/local/bin
#ENTRYPOINT ["mydumper"]

