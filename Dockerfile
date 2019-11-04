# Base
FROM centos:7
MAINTAINER Damian Troy <github@black.hole.com.au>
RUN yum -y update && yum clean all

# Common
VOLUME /config
ENV PUID=1001
ENV PGID=1001
RUN groupadd -g ${PGID} videos && \
    useradd -u ${PUID} -g videos -d /config -M videos
ENV TZ=Australia/Melbourne

# App
VOLUME /videos
EXPOSE 8112
RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    yum -y install epel-release http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
    yum -y install nmap-ncat deluge-web && \
    yum clean all

# Runtime
USER videos
CMD /usr/bin/deluged -c /config
CMD while ! nc -z 127.0.0.1 58846; do sleep 0.1; done
CMD /usr/bin/deluge-web -c /config

