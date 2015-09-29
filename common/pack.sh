#!/bin/sh

set -e

SPEC_FILE=$1; shift
PACKAGE_TARBALL=$1; shift

PACKAGE_NAME=$(basename "$SPEC_FILE" '.spec')
PACKAGE_VERSION=$(echo "$PACKAGE_TARBALL" | sed -r 's/.*qdb-(.*)-linux-.*/\1/')

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv "$PACKAGE_TARBALL" "$HOME/rpmbuild/SOURCES"
for EXTRA in "$@"; do
    cp -fv "$EXTRA" "$HOME/rpmbuild/SOURCES"
done

rpmbuild -v -bb "$SPEC_FILE"
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;