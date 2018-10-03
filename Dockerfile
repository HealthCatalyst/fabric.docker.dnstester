FROM healthcatalyst/fabric.docker.centos.tomcat:latest
LABEL maintainer="Health Catalyst"
LABEL version="1.0"

ADD docker-entrypoint.sh ./docker-entrypoint.sh

RUN dos2unix ./docker-entrypoint.sh \
	&& chmod a+x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]


