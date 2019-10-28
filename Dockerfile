FROM jenkins/jenkins:alpine

USER root

ADD https://github.com/just-containers/s6-overlay/releases/download\
/v1.22.1.0/s6-overlay-amd64.tar.gz \
/tmp/

COPY services.d /etc/services.d
COPY periodic/15min /etc/periodic/15min

RUN apk add --no-cache docker shadow \
    && gpasswd docker -a jenkins \
    && gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

ENTRYPOINT ["/init"]
