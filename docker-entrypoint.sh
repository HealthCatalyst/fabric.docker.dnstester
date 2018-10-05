#!/bin/sh

version="2018.04.01.01"
echo "starting docker-entrypoint.sh version $version"

echo "testing DNS..."

echo "--- resolv.conf ---"
cat /etc/resolv.conf

# echo "--- testing if we can access internal (pod) network ---"
# nslookup kubernetes.default

if [[ -z "$SERVER1" ]]; then
    echo "SERVER1 is empty"
    exit 1
fi

failedservers=()
failuremessages=()

echo "--- using dig for kubernetes ---"
server="$SERVER1"
myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
# myip=$(dig $server A +short)
echo "result:$?"
if [ -z "$myip" ]; then
    echo "nslookup to $server failed"
    failedservers+=("$server")
    failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
else
    echo "nslookup to $server returned ip: $myip"
fi

if [[ ! -z "$SERVER2" ]]; then
    server="$SERVER2"
    myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
    echo "result:$?"
    if [ -z "$myip" ]; then
        echo "nslookup to $server failed"
        failedservers+=("$server")
        failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
    else
        echo "nslookup to $server returned ip: $myip"
    fi
fi

if [[ ! -z "$SERVER3" ]]; then
    server="$SERVER3"
    myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
    echo "result:$?"
    if [ -z "$myip" ]; then
        echo "nslookup to $server failed"
        failedservers+=("$server")
        failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
    else
        echo "nslookup to $server returned ip: $myip"
    fi
fi

if [[ ! -z "$SERVER4" ]]; then
    server="$SERVER4"
    myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
    echo "result:$?"
    if [ -z "$myip" ]; then
        echo "nslookup to $server failed"
        failedservers+=("$server")
        failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
    else
        echo "nslookup to $server returned ip: $myip"
    fi
fi

if [[ ! -z "$SERVER5" ]]; then
    server="$SERVER5"
    myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
    echo "result:$?"
    if [ -z "$myip" ]; then
        echo "nslookup to $server failed"
        failedservers+=("$server")
        failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
    else
        echo "nslookup to $server returned ip: $myip"
    fi
fi

total=${#failedservers[*]}
echo "Total=$total"
for (( i=0; i<=$(( $total -1 )); i++ ))
do 
    failedserver="${failedservers[$i]}"
    failuremessage="${failuremessages[$i]}"
    echo "here $i: $failedserver = $failuremessage"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"'"DNS Failed: $failedserver"'", "attachments":[{"text":"'"$failuremessage"'"}]}' "https://hooks.slack.com/services/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"
done

#     echo "To troubleshoot dig: https://www.madboa.com/geek/dig/"

# echo  "--- testing if we can access external network ---"
# wget www.google.com



