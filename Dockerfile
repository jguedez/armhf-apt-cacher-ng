# https://docs.docker.com/engine/examples/apt-cacher-ng/
# Build: docker build -t aptcache .
# Run: docker run -d -p 3142:3142 --name aptcache
#
# and then you can run containers with:
#   echo 'Acquire::http { Proxy "http://aptcache:3142"; };' >> /etc/apt/apt.conf.d/01proxy
# Here, `aptcache` is the IP address or FQDN of a host running the Docker daemon
# which acts as an APT proxy server.
FROM debian:stable-slim

# PassThroughPattern needed to proxy 3rd party https repos
RUN apt-get update && apt-get install -y --no-install-recommends apt-cacher-ng=3.2-2 \
 && echo 'PassThroughPattern: .*' >> /etc/apt-cacher-ng/acng.conf \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 3142
# hadolint ignore=DL3025
CMD chmod 777 /var/cache/apt-cacher-ng && /etc/init.d/apt-cacher-ng start && tail -f /var/log/apt-cacher-ng/*
