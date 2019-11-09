# Base
FROM centos:7
LABEL maintainer="Damian Troy <github@black.hole.com.au>"
RUN yum -y update && yum clean all

# Common
VOLUME /config
ENV PUID=1001
ENV PGID=1001
RUN groupadd -g ${PGID} videos && \
    useradd -u ${PUID} -g videos -d /config -M videos
RUN chown -R videos:videos /config
ENV TZ=Australia/Melbourne
COPY test.sh /usr/local/bin/

# App
VOLUME /videos
EXPOSE 8112
RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    yum -y install epel-release http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
    yum -y install nmap-ncat deluge-web && \
    yum clean all
COPY start.sh /usr/local/bin/

# Runtime
USER videos
CMD ["/usr/local/bin/start.sh"]

