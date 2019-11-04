# Deluge BitTorrent Client CentOS Container

## Configuration
| Command | Config   | Description
| ------- | -------- | -----
| ENV     | PUID     | UID of the runtime user (Default: 1001)
| ENV     | PGID     | GID of the runtime group (Default: 1001)
| ENV     | TZ       | Timezone (Default: Australia/Melbourne)
| VOLUME  | /config  | Configuration directory
| VOLUME  | /videos  | Videos directory, including 'downloads/'
| EXPOSE  | 8112/tcp | deluge-web

## Example
```shell script
TZ=Australia/Melbourne
PUID=1001
PGID=1001

sudo podman build -t deluge .

sudo podman run \
    --pod video \
    --name=deluge \
    -e PUID=${PUID} \
    -e PGID=${PGID} \
    -e TZ=${TZ} \
    -v /etc/config/deluge:/config:Z \
    -v /videos:/videos:z \
    -d localhost/deluge
```
