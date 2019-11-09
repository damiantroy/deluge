#!/usr/bin/env bash
#set -x

echo "*** Start debug test.sh"

echo "id"
id

echo "ls -la /tmp"
ls -la /tmp

echo "ls -la /config"
ls -la /config

echo "mount"
mount

echo "*** End debug test.sh"

function usage() {
    echo "Usage: $0 -t <timeout> -u <url> [-e <expect_string>]"
    exit 1
}


# Check the required executables are in the path
REQUIRED_EXEC="awk timeout nc sleep curl grep"
for EXEC in $REQUIRED_EXEC; do
    if ! command -v $EXEC >/dev/null 2>&1; then
        echo "*** Test failed: '$EXEC' is not in the path" >&2
        MISSING_EXEC=1
    fi
done
if [[ $MISSING_EXEC -ne 0 ]]; then exit 2; fi


while getopts "t:u:e:" OPT; do
    case "$OPT" in
        t) TIMEOUT=$OPTARG ;;
        u) URL=$OPTARG ;;
        e) EXPECT=$OPTARG ;;
        *) usage ;;
    esac
done

if [[ -z "$TIMEOUT" || -z "$URL" ]]; then
    usage
fi


# Extract the port from the URL
PROTO_REGEX='^([[:alnum:]]+)://'
PORT_REGEX=':([[:digit:]]+)'
if [[ $URL =~ $PORT_REGEX  ]]; then
    PORT=${BASH_REMATCH[1]}
elif [[ $URL =~ $PROTO_REGEX ]]; then
        PROTO=${BASH_REMATCH[1]}
        PORT=$(getent services $PROTO |awk '{split($2,a,"/");print a[1]}')
fi
if [[ -z "$PORT" ]]; then
    echo "*** Test failed: Unable to determine port from URL"
    exit 3
fi


# Wait for the port to be up until timeout is reached
HOST=$(echo ${URL} | awk -F[/:] '{print $4}')
timeout ${TIMEOUT} sh -c "while ! nc -z ${HOST} ${PORT}; do sleep 1; done"
NC_RESULT=$?
if [[ ${NC_RESULT} -ne 0 ]]; then
    echo "*** Test failed: Connection timed out to ${HOST}:${PORT}/tcp"
    exit ${NC_RESULT}
fi


# Check for expected string
if [[ -n "${EXPECT}" ]]; then
    curl -sS4 $URL |grep -q "${EXPECT}"
    CURL_RESULT=$?
else
    curl -sS4f $URL > /dev/null
    CURL_RESULT=$?
fi
if [[ ${CURL_RESULT} -ne 0 ]]; then
    echo "*** Test failed: curl did not get an expected result"
    exit ${CURL_RESULT}
fi


# Exit cleanly if we've made it this far
echo "*** Test successful"
exit 0

