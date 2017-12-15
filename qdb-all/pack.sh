#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1)

cd $(dirname $0)
../common/pack.sh qdb-all.spec $PACKAGE_TARBALL ../qdb-server/qdbd_init.sh ../qdb-server/qdbd_limits.conf ../qdb-server/qdbd_sysctl.conf ../qdb-web-bridge/qdb_httpd_init.sh

#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1)

cd $(dirname $0)
../common/pack.sh qdb-server.spec $PACKAGE_TARBALL qdbd_init.sh qdbd_limits.conf qdbd_sysctl.conf
