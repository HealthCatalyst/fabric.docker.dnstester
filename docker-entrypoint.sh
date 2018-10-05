#!/bin/bash

version="2018.10.05.01"
echo "$(date -Iseconds) Starting docker-entrypoint.sh version $version"

if [[ -z "$SERVER1" ]]; then
    echo "ERROR: SERVER1 is empty"
    exit 1
fi

if [[ -z "$ENVNAME" ]]; then
    echo "ERROR: ENVNAME is empty"
    exit 1
fi

if [[ -z "$SLACKURL" ]]; then
    echo "SLACKURL is empty"
    SLACKURL="https://hooks.slack.com/services/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"
fi

if [[ -z "$SLEEPINTERVAL" ]]; then
    echo "SLEEPINTERVAL is empty"
    SLEEPINTERVAL="5"
fi


if [[ -z "$INTERVALBETWEENMESSAGES" ]]; then
    echo "INTERVALBETWEENMESSAGES is empty"
    INTERVALBETWEENMESSAGES="5"
fi

echo "Testing DNS..."

echo "$(date -Iseconds) --- resolv.conf ---"
cat /etc/resolv.conf

curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$ENVNAME Started monitoring DNS every $SLEEPINTERVAL seconds"'"}' "$SLACKURL"

declare -i numberOfTimesFailed
declare -i sleepTimeInSeconds

declare -i timeLastSentSlackMessage
declare -i intervalBetweenSendingSlackMessages

timeLastSentSlackMessage=0

sleepTimeInSeconds=$SLEEPINTERVAL
intervalBetweenSendingSlackMessages=$INTERVALBETWEENMESSAGES

hasFailed=false

while true
do
	echo "Press [CTRL+C] to stop.."

    failedservers=()
    failuremessages=()

    echo "--- using dig for kubernetes ---"
    server="$SERVER1"
    myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
    # myip=$(dig $server A +short)
    echo "$(date -Iseconds) result:$?"
    if [ -z "$myip" ]; then
        echo "$(date -Iseconds) nslookup to $server failed"
        failedservers+=("$server")
        failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
    else
        echo "$(date -Iseconds) nslookup to $server returned ip: $myip"
    fi

    if [[ ! -z "$SERVER2" ]]; then
        server="$SERVER2"
        myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
        echo "$(date -Iseconds) $server result:$?"
        if [ -z "$myip" ]; then
            echo "$(date -Iseconds) nslookup to $server failed"
            failedservers+=("$server")
            failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
        else
            echo "$(date -Iseconds) nslookup to $server returned ip: $myip"
        fi
    fi

    if [[ ! -z "$SERVER3" ]]; then
        server="$SERVER3"
        myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
        echo "$(date -Iseconds) $server result:$?"
        if [ -z "$myip" ]; then
            echo "$(date -Iseconds) nslookup to $server failed"
            failedservers+=("$server")
            failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
        else
            echo "$(date -Iseconds) nslookup to $server returned ip: $myip"
        fi
    fi

    if [[ ! -z "$SERVER4" ]]; then
        server="$SERVER4"
        myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
        echo "$(date -Iseconds) $server result:$?"
        if [ -z "$myip" ]; then
            echo "$(date -Iseconds) nslookup to $server failed"
            failedservers+=("$server")
            failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
        else
            echo "$(date -Iseconds) nslookup to $server returned ip: $myip"
        fi
    fi

    if [[ ! -z "$SERVER5" ]]; then
        server="$SERVER5"
        myip=$(nslookup "$server" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
        echo "$(date -Iseconds) $server result:$?"
        if [ -z "$myip" ]; then
            echo "$(date -Iseconds) nslookup to $server failed"
            failedservers+=("$server")
            failuremessages+=("$(nslookup "$server") $(dig $server A +trace +search +all)")
        else
            echo "$(date -Iseconds) nslookup to $server returned ip: $myip"
        fi
    fi

    total=${#failedservers[*]}
    echo "$(date -Iseconds) Total failed servers=$total"

    if [ "$total" -gt 0 ]; then
        hasFailed=true
        numberOfTimesFailed=$numberOfTimesFailed+1
        timeSinceLastSentSlackMessage=$((SECONDS - timeLastSentSlackMessage))
        echo "Time since last sent slack message: $timeSinceLastSentSlackMessage"
        if [[ $timeSinceLastSentSlackMessage -gt $intervalBetweenSendingSlackMessages ]]; then
            for (( i=0; i<=$(( $total -1 )); i++ ))
            do 
                failedserver="${failedservers[$i]}"
                failuremessage="${failuremessages[$i]}"
                echo "$(date -Iseconds) Sending slack message. failed server ($i): $failedserver, numberofTimesFailed=$numberOfTimesFailed"

                curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$ENVNAME DNS Failed($numberOfTimesFailed): $failedserver"'", "attachments":[{"text":"'"$failuremessage"'"}]}' "$SLACKURL"
                echo ""
            done
            timeLastSentSlackMessage=$SECONDS
        else
            echo "Cannot send slack message since we sent one $timeSinceLastSentSlackMessage seconds ago and the minimum interval is  $intervalBetweenSendingSlackMessages"
        fi
    else
        echo "$(date -Iseconds) All is good now"
        numberOfTimesFailed=0
        if [ "$hasFailed" = true ] ; then
            curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$ENVNAME DNS is now working"'"}' "$SLACKURL"
            hasFailed=""
        fi
    fi

    echo "$(date -Iseconds) sleeping for $sleepTimeInSeconds"
    sleep $sleepTimeInSeconds
done

#     echo "To troubleshoot dig: https://www.madboa.com/geek/dig/"

# echo  "--- testing if we can access external network ---"
# wget www.google.com



