##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM bureau14/qdb-pkg-rpm/qdb-api

RUN yum install -y curl

COPY qdb-utils-*.rpm .
RUN rpm -i qdb-utils-*.rpm
