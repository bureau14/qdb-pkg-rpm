#!/bin/bash

set -eux

SPEC_FILE=$1; shift
PACKAGE_TARBALL=$1; shift
FULL_VERSION=$1; shift


MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PACKAGE_NAME=$(basename "$SPEC_FILE" '.spec')

if [[ ${FULL_VERSION} == "nightly" ]]; then
    PACKAGE_VERSION=$(${MYDIR}/get_version.sh ${PACKAGE_TARBALL})
    PACKAGE_RELEASE=0.0
    echo "No package version provided. Setting PACKAGE_VERSION: ${PACKAGE_VERSION}"
else
    IFS='.-' read -ra VERSION_PARTS <<< "${FULL_VERSION}"
    PACKAGE_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.${VERSION_PARTS[2]}"
    
    IFS='-' read -ra RELEASE_PARTS <<< "${FULL_VERSION}"
    PACKAGE_RELEASE="${RELEASE_PARTS[1]}"
fi

echo "PACKAGE_VERSION: $PACKAGE_VERSION"
echo "PACKAGE_NAME: $PACKAGE_NAME"
echo "PACKAGE_TARBALL: $PACKAGE_TARBALL"
echo "PACKAGE_RELEASE: $PACKAGE_RELEASE"

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL PACKAGE_RELEASE
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv "$PACKAGE_TARBALL" "$HOME/rpmbuild/SOURCES"
for EXTRA in "$@"; do
    cp -fv "$EXTRA" "$HOME/rpmbuild/SOURCES"
done

rpmbuild -v -bb "$SPEC_FILE" 2>&1
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;
