$dockername = "fabric.docker.dnstester"

docker stop $dockername
docker rm $dockername

docker build -t healthcatalyst/$dockername .

docker run -e SERVER1='kubernetes.default' -e SERVER2='www.cnn.com' -e SERVER3='www.cnn.com2' --rm --name $dockername -t healthcatalyst/$dockername