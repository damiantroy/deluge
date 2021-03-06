# Deluge BitTorrent Client CentOS Container

This is a CentOS 7 container for [Deluge](https://deluge-torrent.org/), a lightweight, Free Software, cross-platform BitTorrent client.

## Building

To build and test the image, run:

```shell script
make all # build test
```

## Running

### Configuration

| Command | Config   | Description
| ------- | -------- | -----
| ENV     | PUID     | UID of the runtime user (Default: 1001)
| ENV     | PGID     | GID of the runtime group (Default: 1001)
| ENV     | TZ       | Timezone (Default: Australia/Melbourne)
| VOLUME  | /videos  | Videos directory, including 'downloads/'
| VOLUME  | /config  | Configuration directory
| EXPOSE  | 8112/tcp | HTTP port for deluge-web

```shell script
PUID=1001
PGID=1001
TZ=Australia/Melbourne
VIDEOS_DIR=/videos
DELUGE_CONFIG_DIR=/etc/config/deluge
DELUGE_IMAGE=localhost/deluge # Or damiantroy/deluge if deploying from docker.io

sudo mkdir -p ${VIDEOS_DIR} ${DELUGE_CONFIG_DIR}
sudo chown -R ${PUID}:${PGID} ${VIDEOS_DIR} ${DELUGE_CONFIG_DIR}

sudo podman run -d \
    --pod video \
    --name=deluge \
    -e PUID=${PUID} \
    -e PGID=${PGID} \
    -e TZ=${TZ} \
    -v ${DELUGE_CONFIG_DIR}:/config:Z \
    -v ${VIDEOS_DIR}:/videos:z \
    ${DELUGE_IMAGE}
```
