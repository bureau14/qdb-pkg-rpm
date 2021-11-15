#!/bin/bash -eu

PACKAGE_TARBALL=$(readlink -e $1); shift

cd $(dirname $0)
../common/pack.sh qdb-server.spec \
                  $PACKAGE_TARBALL \
                  qdbd.service \
                  qdbd_sysctl.conf \
                  qdbd_logrotate.conf
