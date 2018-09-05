##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM bureau14/qdb-pkg-rpm/qdb-api

COPY qdb-utils-*.rpm .
RUN rpm -i qdb-utils-*.rpm
