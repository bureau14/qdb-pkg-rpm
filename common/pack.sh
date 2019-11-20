#!/bin/bash

set -eux

SPEC_FILE=$1; shift
PACKAGE_TARBALL=$1; shift
PACKAGE_VERSION=$1; shift

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PACKAGE_VERSION=$(${MYDIR}/get_version.sh ${PACKAGE_VERSION})

PACKAGE_NAME=$(basename "$SPEC_FILE" '.spec')

echo "PACKAGE_VERSION: $PACKAGE_VERSION"
echo "PACKAGE_NAME: $PACKAGE_NAME"
echo "PACKAGE_TARBALL: $PACKAGE_TARBALL"

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv "$PACKAGE_TARBALL" "$HOME/rpmbuild/SOURCES"
for EXTRA in "$@"; do
    cp -fv "$EXTRA" "$HOME/rpmbuild/SOURCES"
done

rpmbuild -v -bb "$SPEC_FILE" 2>&1
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;
