#!/bin/sh -eu

PACKAGE_TARBALL=$(readlink -e $1)

cd $(dirname $0)
../common/pack.sh qdb-api-rest.spec $PACKAGE_TARBALL qdb_api_rest_init.sh
