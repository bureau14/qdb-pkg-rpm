#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1)
BENCHMARK_TARBALL=$(readlink -e *qdb-benchmark-*.tar.gz)

cd $(dirname $0)
../common/pack.sh qdb-utils.spec $PACKAGE_TARBALL $BENCHMARK_TARBALL