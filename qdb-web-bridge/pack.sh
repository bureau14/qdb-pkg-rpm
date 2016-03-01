#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1)

cd $(dirname $0)
../common/pack.sh qdb-web-bridge.spec $PACKAGE_TARBALL qdb_httpd_init.sh
