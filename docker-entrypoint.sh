#!/bin/sh

version="2018.04.01.01"
echo "starting docker-entrypoint.sh version $version"

echo "testing DNS..."

echo "--- resolv.conf ---"
cat /etc/resolv.conf

echo "--- testing if we can access internal (pod) network ---"
nslookup kubernetes.default

echo  "--- testing if we can access external network ---"
wget www.google.com

curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World from Docker!"}' https://hooks.slack.com/services/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


