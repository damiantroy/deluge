#!/usr/bin/env bash
set -x

# Check the required executables are in the path
REQUIRED_EXEC="getopts timeout nc curl awk"
for EXEC in $REQUIRED_EXEC; do
    if ! command -v $EXEC >/dev/null 2>&1; then
        echo "*** Test failed: : '$EXEC' is not in the path" >&2
        exit 2
    fi
done

function usage() {
    echo "Usage: $0 -t <timeout> -u <url> -e <expect_string>"
    exit 1
}

while getopts "t:u:e:" OPT; do
    case "$OPT" in
        t) TIMEOUT=$OPTARG ;;
        u) URL=$OPTARG ;;
        e) EXPECT=$OPTARG ;;
        *) usage ;;
    esac
done

# Get the port
PROTO_REGEX='^([[:alnum:]]+)://'
PORT_REGEX=':([[:digit:]]+)'
if [[ $URL =~ $PORT_REGEX  ]]; then
    PORT=${BASH_REMATCH[1]}
elif [[ $URL =~ $PROTO_REGEX ]]; then
        PROTO=${BASH_REMATCH[1]}
        PORT=$(getent services $PROTO |awk '{split($2,a,"/");print a[1]}')
fi
if [[ -z "$PORT" ]]; then
    echo "*** Test failed: Unable to determine port"
    exit 3
fi

# Wait for the port to be up
HOST=$(echo ${URL} | awk -F[/:] '{print $4}')
timeout ${TIMEOUT} sh -c "while ! nc -z ${HOST} ${PORT}; do sleep 1; done"
NC_RESULT=$?
if [[ ${NC_RESULT} -ne 0 ]]; then
    echo "*** Test failed: Connection timed out"
    exit ${NC_RESULT}
fi

# Check for expected string
curl -4 $URL |grep "${EXPECT}"
CURL_RESULT=$?
if [[ ${CURL_RESULT} -ne 0 ]]; then
    echo "*** Test failed: Could not find expected pattern"
    exit ${CURL_RESULT}
fi

echo "*** Test successful"
exit 0

