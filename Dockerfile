# 3proxy docker

FROM alpine:latest as builder

# STEP 1 build executable binary
MAINTAINER Riftbit ErgoZ <ergozru@riftbit.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=0.8.12


LABEL org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.name="3proxy Socks5 Proxy Container" \
	org.label-schema.description="3proxy Socks5 Proxy Container" \
	org.label-schema.url="https://riftbit.com/" \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/riftbit/docker-3proxy" \
	org.label-schema.vendor="Riftbit Studio" \
	org.label-schema.version=$VERSION \
	org.label-schema.schema-version="1.0" \
	maintainer="Riftbit ErgoZ"

RUN apk add --update alpine-sdk wget bash && \
    cd / && \
    wget -q  https://github.com/z3APA3A/3proxy/archive/${VERSION}.tar.gz && \
    tar -xf ${VERSION}.tar.gz && \
    cd 3proxy-${VERSION} && \
    make -f Makefile.Linux && \
    chmod 777 src/3proxy
    
COPY docker-entrypoint.sh /


# STEP 2 build a small image
FROM alpine:latest

# STEP 1 build executable binary
MAINTAINER Riftbit ErgoZ <ergozru@riftbit.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=0.8.12


LABEL org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.name="3proxy Socks5 Proxy Container" \
	org.label-schema.description="3proxy Socks5 Proxy Container" \
	org.label-schema.url="https://riftbit.com/" \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/riftbit/docker-3proxy" \
	org.label-schema.vendor="Riftbit Studio" \
	org.label-schema.version=$VERSION \
	org.label-schema.schema-version="1.0" \
	maintainer="Riftbit ErgoZ"

RUN mkdir /etc/3proxy/

COPY --from=builder /3proxy-${VERSION}/src/3proxy /etc/3proxy/
COPY --from=builder /docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3128:3128/tcp 1080:1080/tcp

CMD ["start_proxy"]
