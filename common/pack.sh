#!/bin/bash

set -eux

SPEC_FILE=$1; shift
PACKAGE_TARBALL=$1; shift

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# PACKAGE_ARCH is x86_64 by default, but aarch64 if the tarball contains
# that name.
PACKAGE_ARCH="x86_64"
if [[ $PACKAGE_TARBALL == *"aarch64"* ]]; then
    PACKAGE_ARCH="aarch64"
fi

PACKAGE_VERSION=$(${MYDIR}/get_version.sh)
PACKAGE_NAME=$(basename "$SPEC_FILE" '.spec')

echo "PACKAGE_VERSION: $PACKAGE_VERSION"
echo "PACKAGE_NAME: $PACKAGE_NAME"
echo "PACKAGE_TARBALL: $PACKAGE_TARBALL"
echo "PACKAGE_ARCH: $PACKAGE_ARCH"

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv "$PACKAGE_TARBALL" "$HOME/rpmbuild/SOURCES"
for EXTRA in "$@"; do
    cp -fv "$EXTRA" "$HOME/rpmbuild/SOURCES"
done

rpmbuild -v -bb "$SPEC_FILE" 2>&1
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;
