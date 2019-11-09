#!/usr/bin/env bash

/usr/bin/deluged -c /config
while ! nc -z 127.0.0.1 58846; do sleep 0.1; done
/usr/bin/deluge-web -c /config
