FROM bureau14/qdb-pkg-rpm/qdb-rest

COPY qdb-dashboard*.rpm .
RUN rpm -i qdb-dashboard*.rpm

RUN cat /etc/qdb/qdb_rest.conf \
    | jq ".assets = \"/var/lib/qdb/assets\"" \
    > /tmp/qdb_rest.conf.new && \
    mv /tmp/qdb_rest.conf.new /etc/qdb/qdb_rest.conf && \
    chown qdb:qdb /etc/qdb/qdb_rest.conf
