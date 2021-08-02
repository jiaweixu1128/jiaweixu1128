#!/bin/bash

cd /home/docker/actions-runner

./config.sh --url https://github.com/jiaweixu1128/jiaweixu1128 --token AUGUWIMTL6N7Z6VARXZY3YDBADPO2
#./svc.sh install
cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token AUGUWIMTL6N7Z6VARXZY3YDBADPO2
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./bin/runsvc.sh & wait $!
