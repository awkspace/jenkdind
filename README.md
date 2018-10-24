# JenkDind: A Dockerized Jenkins with Dind

This is a simple image based on `jenkins/jenkins:lts-alpine` with Docker
installed beside Jenkins. This means the Jenkins running inside has full Docker
capabilities – building, running, pushing, and using as agents for Declarative
Pipeline. It’s meant for people who want to run a single Jenkins instance with
Docker in as self-contained a manner as possible. It is in no way recommended
for any serious workload.

JenkDind is powered by
[s6-overlay](https://github.com/just-containers/s6-overlay) and a healthy
disrespect for single-process Docker design patterns.

There are other ways to let a containerized Jenkins instance use Docker – like
mounting the host Docker socket or running DIND as a sidecar container – but
this is one of the least-effort, most-isolated ways to get the job done. The
entire build system lives in a single container that can be shut down at any
moment without leaving cruft behind on the Docker host itself, and two Docker
volumes allow for easy backup (in the case of `jenkins_home`) or cache clearing
(in the case of `docker_store`).

Jenkins runs as uid 1000 (`jenkins`) with no sudo privileges and Docker runs as
uid 1 (`root`) to mimic a “real” installation as closely as possible. It’s
intended that anything which would work in a proper installation would also work
in JenkDind.

## Usage

``` sh
docker run \
  --name jenkins \
  -e TZ=America/New_York \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  -v docker_store:/var/lib/docker \
  --privileged \
  -d \
  awkspace/jenkdind
```

## Backup

The included `backup.sh` stops the `jenkins` container and outputs a compressed
`.tar.gz` of the `jenkins_home` to standard out. It produces a stream instead of
a file since JenkDind is intended to be run in environments where resources
might be scarce, including drive space. The script output can therefore be
directly streamed to a remote location such as S3.

``` sh
# Backup to S3
./backup.sh | aws s3 cp - s3://my-backup-bucket/jenkins-`date +%s`.tar.gz

# Backup to local file
./backup.sh > /mnt/backup/jenkins-`date +%s`.tar.gz
```

## License

JenkDind is licensed under MIT.
