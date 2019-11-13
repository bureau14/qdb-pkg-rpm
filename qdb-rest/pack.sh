#!/bin/bash -eu

PACKAGE_TARBALL=$(readlink -e $1); shift
PACKAGE_VERSION=$1; shift

cd $(dirname $0)
../common/pack.sh qdb-rest.spec $PACKAGE_TARBALL $PACKAGE_VERSION qdb_rest.service
