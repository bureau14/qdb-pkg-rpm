##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM bureau14/qdb-pkg-rpm/qdb-api

RUN yum install -y openssl \
    && yum clean all

COPY qdb_rest-*.rpm .
RUN rpm -i qdb_rest-*.rpm
RUN systemctl enable qdb_rest
