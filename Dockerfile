# 3proxy docker

FROM alpine:latest as builder

ARG VERSION=0.9.3

RUN apk add --update alpine-sdk linux-headers wget bash && \
    cd / && \
    wget -q  https://github.com/z3APA3A/3proxy/archive/${VERSION}.tar.gz && \
    tar -xf ${VERSION}.tar.gz && \
    cd 3proxy-${VERSION} && \
    make -f Makefile.Linux

# STEP 2 build a small image
FROM alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=0.9.3

LABEL org.label-schema.build-date=$BUILD_DATE 

RUN mkdir /etc/3proxy/

COPY --from=builder /3proxy-${VERSION}/src/3proxy /etc/3proxy/
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk update && \
    apk upgrade && \
    apk add bash wireguard-tools curl nano && \
    mkdir -p /etc/3proxy/cfg/traf &&\
    chmod +x /docker-entrypoint.sh && \
    chmod -R +x /etc/3proxy/3proxy

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME ["/etc/3proxy/cfg/"]

EXPOSE 3128:3128/tcp 1080:1080/tcp 8080:8080/tcp

CMD ["start"]
