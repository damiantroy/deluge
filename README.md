# Deluge BitTorrent Client CentOS Container

| Config | Value |
| --- | ----- |
| -e PUID | UID of the non-root user (Default: 1001)
| -e PGID | GID of the non-root group (Default: 1001)
| -e TZ | Timezone (Default: Australia/Melbourne)
| -v /config | Configuration directory
| -v /videos | Videos base directory

Example build and run inside a pod:
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
