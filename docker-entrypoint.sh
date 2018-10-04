#!/bin/sh

version="2018.04.01.01"
echo "starting docker-entrypoint.sh version $version"

echo "testing DNS..."

echo "--- resolv.conf ---"
cat /etc/resolv.conf

echo "testing if we can access internal (pod) network"
nslookup kubernetes.default

echo  "testing if we can access external network"
wget www.google.com



