FROM openjdk:8-alpine

ARG GPG_KEY=1603F3DE01E476E57860CCA8CAA41D28149202E6
ARG GEODE_VERSION=1.11.0
ARG GEODE_DIST=apache-geode-$GEODE_VERSION

RUN set -x \
    && apk add gnupg axel \
    && apk add --no-cache --upgrade bash \
    && addgroup -g 1000 -S geode \
    && adduser --system -g geode --uid=1000 geode \
    && axel -q --insecure "https://archive.apache.org/dist/geode/$GEODE_VERSION/$GEODE_DIST.tgz" \
    && axel -q --insecure "https://archive.apache.org/dist/geode/$GEODE_VERSION/$GEODE_DIST.tgz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" || \
       gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" || \
       gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY" \
    && gpg "$GEODE_DIST.tgz.asc" \
    && rm -rf "$GNUPGHOME" \
	&& tar --extract --file "$GEODE_DIST.tgz" \
	&& rm -fr "$GEODE_DIST.tgz.asc" "$GEODE_DIST.tgz" \
	&& chown -R geode:geode "/$GEODE_DIST"

USER geode
WORKDIR /$GEODE_DIST
ENV PATH=$PATH:/$GEODE_DIST/bin

ENTRYPOINT ["gfsh", "version"]