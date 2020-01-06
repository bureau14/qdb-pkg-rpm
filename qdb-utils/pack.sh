#!/bin/bash -eu

PACKAGE_TARBALL=$(readlink -e $1); shift

cd $(dirname $0)
../common/pack.sh qdb-utils.spec $PACKAGE_TARBALL