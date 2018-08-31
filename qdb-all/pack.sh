#!/bin/sh -eu

set -e

SPEC_FILE="qdb-all.spec"
PACKAGE_TARBALL=$(readlink -e $1)
PACKAGE_NAME="qdb-all"
PACKAGE_VERSION=$(echo "$PACKAGE_TARBALL" | sed -r 's/.*qdb-(.*)-linux-.*/\1/')

cd $(dirname $0)

export SOURCE_C_API=$(ls ../*-c-api.tar.gz)
export SOURCE_SERVER=$(ls ../*-server.tar.gz)
export SOURCE_UTILS=$(ls ../*-utils.tar.gz)
export SOURCE_WEB_BRIDGE=$(ls ../*-web-bridge.tar.gz)
export SOURCE_API_REST=$(ls ../*-api-rest.tar.gz)

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv ../*.tar.gz "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_init.sh "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_limits.conf "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_sysctl.conf "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-web-bridge/qdb_httpd_init.sh "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-api-rest/qdb_api_rest_init.sh "$HOME/rpmbuild/SOURCES"

rpmbuild -v -bb "$SPEC_FILE" 2>&1
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;
