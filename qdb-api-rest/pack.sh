#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1)

cd $(dirname $0)
../common/pack.sh qdb_rest.spec $PACKAGE_TARBALL qdb_rest.service