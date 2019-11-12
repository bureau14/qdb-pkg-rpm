#!/bin/bash

set -e

SPEC_FILE=$1; shift
PACKAGE_TARBALL=$1; shift

if [[ $# == 3 ]]; then
    PACKAGE_VERSION=$1; shift
else
    PACKAGE_VERSION=$(get_version ${PACKAGE_TARBALL})
    echo "No package version provided. Setting PACKAGE_VERSION: ${PACKAGE_VERSION}"
fi

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PACKAGE_NAME=$(basename "$SPEC_FILE" '.spec')

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv "$PACKAGE_TARBALL" "$HOME/rpmbuild/SOURCES"
for EXTRA in "$@"; do
    cp -fv "$EXTRA" "$HOME/rpmbuild/SOURCES"
done

rpmbuild -v -bb "$SPEC_FILE" 2>&1
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;
