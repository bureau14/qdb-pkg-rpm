##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM centos/systemd

COPY qdb-server-*.rpm .
RUN rpm -i qdb-server-*.rpm
RUN systemctl enable qdbd

RUN sed -i -e 's/"127.0.0.1:2836"/"172.17.0.2:2836"/g' /etc/qdb/qdbd.conf
