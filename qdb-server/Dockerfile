##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM centos/systemd

RUN yum install -y iproute \
                   less \
                   net-tools \
                   wget \
                   which && \
    yum clean all

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq

COPY qdb-server-*.rpm .
RUN rpm -i qdb-server-*.rpm
RUN systemctl enable qdbd


COPY fix-config.sh /

# Hack for /fix-config.sh
RUN chmod 777 /etc/qdb/qdbd.conf
RUN chmod 777 /fix-config.sh

RUN cat /usr/lib/systemd/system/qdbd.service \
    | sed '/\[Service\]/a ExecStartPre=/fix-config.sh' \
    | grep -v 'User=' \
    | grep -v 'Group=' \
    > /usr/lib/systemd/system/qdbd.service.new \
    && mv /usr/lib/systemd/system/qdbd.service.new /usr/lib/systemd/system/qdbd.service
