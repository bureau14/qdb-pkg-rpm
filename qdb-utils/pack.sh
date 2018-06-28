#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1)
BENCHMARK_TARBALL=$(readlink -e *qdb-benchmark-*.tar.gz)
RAILGUN_TARBALL=$(readlink -e *qdb-railgun-*.tar.gz)

echo "RAILGUN_TARBALL: $RAILGUN_TARBALL"

cd $(dirname $0)
../common/pack.sh qdb-utils.spec $PACKAGE_TARBALL $BENCHMARK_TARBALL $RAILGUN_TARBALL