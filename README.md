# JenkDIND: A Dockerized Jenkins with DIND

This is a simple image based on `jenkins/jenkins:alpine` with DIND (Docker-
in-Docker) running alongside Jenkins. All of Jenkins’s Docker capabilities
should be operational by default.

JenkDIND is powered by
[s6-overlay](https://github.com/just-containers/s6-overlay) and a healthy
disrespect for the single-process Docker design pattern.

Jenkins runs as uid 1000 (`jenkins`) with no sudo privileges and Docker runs as
uid 1 (`root`) to mimic a “real” installation as closely as possible. It’s
expected that anything which would work in a proper installation should also
work in JenkDIND.

For further reading, see the associated blog post “[Jenkins in a
Box](https://awk.space/blog/jenkins-in-a-box).”

## Usage

``` sh
docker run \
  --name jenkins \
  -e TZ=America/New_York \
  -e MAX_BUILD_AGE=30 \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  -v docker_store:/var/lib/docker \
  --privileged \
  -d \
  awkspace/jenkdind
```

## Options

### `MAX_BUILD_AGE`

How long, in days, old builds should be kept.

If unset, builds will remain indefinitely.

## Backup

The included `backup.sh` stops the `jenkins` container and outputs a compressed
`.tar.gz` of the `jenkins_home` to standard out. The script output can therefore
be streamed directly to a remote location such as S3 and avoid taking up
precious local disk space.

``` sh
# Backup to S3
./backup.sh | aws s3 cp - s3://my-backup-bucket/jenkins-`date +%s`.tar.gz

# Backup to local file, if space is not a concern
./backup.sh > /mnt/backup/jenkins-`date +%s`.tar.gz
```

## Clear Docker cache

To clear the Docker cache, stop the container, `docker volume rm docker_store`,
and start the container again.

## License

JenkDIND is licensed under [MIT](LICENSE).
