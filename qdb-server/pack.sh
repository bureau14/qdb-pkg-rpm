#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1); shift
PACKAGE_VERSION=$1; shift

cd $(dirname $0)
../common/pack.sh qdb-server.spec $PACKAGE_TARBALL qdbd.service qdbd_limits.conf qdbd_sysctl.conf
