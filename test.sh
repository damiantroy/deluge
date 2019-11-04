#!/usr/bin/env bash
set -x

curl http://localhost:8112/ |grep '<title>Deluge: Web UI'
RESULT=$?

if [[ ${RESULT} -eq 0 ]]; then
    echo "* Test successful"
else
    echo "* Test failed!"
fi

exit ${RESULT}

