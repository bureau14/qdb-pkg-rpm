##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM centos/systemd

COPY qdb-api-*.rpm .
RUN yum install -y qdb-api-*.rpm
