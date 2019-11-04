# Deluge BitTorrent Client CentOS Container

| Resource | Exported |
| --- | ----- |
| Volumes | /config, /videos
| Ports | 8112

Example to run inside an existing pod:
```shell script
TZ=Australia/Melbourne
PUID=1001
PGID=1001

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
