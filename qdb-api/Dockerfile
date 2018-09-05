##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM centos/systemd

COPY qdb-api-*.rpm .
RUN rpm -i qdb-api-*.rpm
