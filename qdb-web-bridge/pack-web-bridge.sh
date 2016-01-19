#!/bin/sh

set -eu

cd $(dirname $0)

PACKAGE_TARBALL=$(readlink -e $1)
PATH=$PATH:../common

pack.sh qdb-web-bridge.spec $PACKAGE_TARBALL qdb_httpd_init.sh
