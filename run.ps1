$dockername = "fabric.docker.dnstester"

docker stop $dockername
docker rm $dockername

docker build -t healthcatalyst/$dockername .

docker run -e ENVNAME="HCUT" -e SERVER1='kubernetes.default' -e SERVER2='www.cnn.com' -e SERVER3='www.cnn.com2' -e SLACKURL='https://hooks.slack.com/services/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' -e SLEEPINTERVAL="5" --rm --name $dockername -t healthcatalyst/$dockername