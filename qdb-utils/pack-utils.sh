#!/bin/sh

set -eu

PACKAGE_TARBALL=$1
PATH=$PATH:$(dirname $0)/../common
SPEC_FILE=$(dirname $0)/qdb-utils.spec

pack.sh $SPEC_FILE $PACKAGE_TARBALL