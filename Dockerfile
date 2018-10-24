FROM jenkins/jenkins:lts-alpine

USER root

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz /tmp/

RUN apk add --no-cache docker shadow \
 && gpasswd docker -a jenkins \
 && mkdir -p /etc/services.d/docker /etc/services.d/jenkins \
 && printf "#!/usr/bin/execlineb -P\ndockerd" > /etc/services.d/docker/run \
 && printf "#!/usr/bin/execlineb -P\nwith-contenv\ns6-setuidgid jenkins\n/usr/local/bin/jenkins.sh" > /etc/services.d/jenkins/run \
 && gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

ENTRYPOINT ["/init"]
