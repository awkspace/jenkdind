#!/usr/bin/env sh

docker stop ${CONTAINER:-jenkins} > /dev/null
docker run -v ${VOLUME:-jenkins_home}:/jenkins_home alpine /bin/sh -c \
    "cd /jenkins_home && tar --exclude='./workspace' -czf - ./"
docker start ${CONTAINER:-jenkins} > /dev/null
