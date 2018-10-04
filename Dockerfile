FROM centos:centos7
LABEL maintainer="Health Catalyst"
LABEL version="1.0"

RUN yum -y install dos2unix bind-utils wget

ADD docker-entrypoint.sh ./docker-entrypoint.sh

RUN dos2unix ./docker-entrypoint.sh \
	&& chmod a+x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]


