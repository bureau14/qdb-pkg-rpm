##
# Docker image that installs our RPM, launches the server and detaches
# into systemd init.

FROM bureau14/qdb-pkg-rpm/qdb-api

RUN yum update -y \
    && yum install -y openssl \
                      net-tools \
                      wget \
    && yum clean all

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq


COPY qdb-rest-*.rpm .
RUN rpm -i qdb-rest-*.rpm
RUN systemctl enable qdb_rest

RUN cat /etc/qdb/qdb_rest.conf \
    | jq ".allowed_origins = [\"http://0.0.0.0:3449\"]" \
    | jq ".cluster_uri = \"qdb://qdb-server:2836\"" \
    | jq ".tls_port = 40443" \
    | jq ".host = \"0.0.0.0\"" \
    | jq ".port = 40080" \
    > /tmp/qdb_rest.conf.new && \
    mv /tmp/qdb_rest.conf.new /etc/qdb/qdb_rest.conf && \
    chown qdb:qdb /etc/qdb/qdb_rest.conf
