# Deluge BitTorrent Client CentOS Container

## Configuration
| Command | Config   | Description
| ------- | -------- | -----
| ENV     | PUID     | UID of the runtime user (Default: 1001)
| ENV     | PGID     | GID of the runtime group (Default: 1001)
| ENV     | TZ       | Timezone (Default: Australia/Melbourne)
| VOLUME  | /videos  | Videos directory, including 'downloads/'
| VOLUME  | /config  | Configuration directory
| EXPOSE  | 8112/tcp | HTTP port for deluge-web

## Instructions

Build and run:
```shell script
PUID=1001
PGID=1001
TZ=Australia/Melbourne
VIDEOS_DIR=/videos
DELUGE_CONFIG_DIR=/etc/config/deluge
DELUGE_IMAGE=localhost/deluge # Or damiantroy/deluge if running from docker.io

sudo mkdir -p ${VIDEOS_DIR} ${DELUGE_CONFIG_DIR}
sudo chown -R ${PUID}:${PGID} ${VIDEOS_DIR} ${DELUGE_CONFIG_DIR}

# You an skip the build if you're running from docker.io
sudo podman build -t deluge .

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
