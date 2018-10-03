$dockername = "fabric.docker.dnstester"

docker stop $dockername
docker rm $dockername

docker build -t healthcatalyst/$dockername .

docker run --rm --name $dockername -t healthcatalyst/$dockername