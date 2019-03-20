FROM jenkins/jenkins:alpine

USER root

ADD https://github.com/just-containers/s6-overlay/releases/download\
/v1.21.7.0/s6-overlay-amd64.tar.gz \
/tmp/

RUN apk add --no-cache docker shadow \
 && gpasswd docker -a jenkins

RUN mkdir -p /etc/services.d/docker /etc/services.d/jenkins /etc/services.d/cron \
 && printf "%s\n%s" \
    "#!/usr/bin/execlineb -P"\
    "dockerd" > /etc/services.d/docker/run \
 && printf "%s\n%s\n%s\n%s\n%s"\
    '#!/usr/bin/execlineb -P'\
    'with-contenv'\
    's6-setuidgid jenkins'\
    's6-env HOME=/var/jenkins_home'\
    '/usr/local/bin/jenkins.sh' > /etc/services.d/jenkins/run \
 && printf "%s\n%s\n%s"\
    '#!/usr/bin/execlineb -S1'\
    'if { s6-test ${1} -eq 0 }'\
    's6-svscanctl -t /var/run/s6/services' > /etc/services.d/jenkins/finish \
 && printf "%s\n%s"\
    '#!/usr/bin/execlineb -P'\
    'crond -f' > /etc/services.d/cron/run \
 && printf "%s\n%s"\
    '#!/bin/sh'\
    'nice find /var/jenkins_home/workspace -type d -regex ".\+_ws-cleanup_[0-9]\+" -prune -exec rm -rf {} \;' > /etc/periodic/15min/async-cleanup \
 && chmod +x /etc/periodic/15min/async-cleanup \
 && gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

ENTRYPOINT ["/init"]
