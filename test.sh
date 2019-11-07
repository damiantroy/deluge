#!/usr/bin/env bash

id videos
USER_RESULT=$?

rpm -V deluge-web
RPM_RESULT=$?

RESULT=$((USER_RESULT + RPM_RESULT))

exit $RESULT

