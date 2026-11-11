##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM centos/systemd

COPY qdb-rest-*.rpm .
RUN yum install -y qdb-rest-*.rpm
RUN systemctl enable qdb_rest

# Every configuration key is also an environment variable, so the image
# sets its two keys in a drop-in and leaves the packaged file as it is.
RUN mkdir -p /etc/systemd/system/qdb_rest.service.d \
    && printf '%s\n' \
        '[Service]' \
        'Environment=QDB_REST_CLUSTER_URI=qdb://qdb-server:2836' \
        'Environment=QDB_REST_LISTEN_HTTP=:40080' \
        > /etc/systemd/system/qdb_rest.service.d/compose.conf
