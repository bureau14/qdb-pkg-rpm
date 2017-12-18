#!/bin/sh -eu


SPEC_FILE="qdb-all.spec"
PACKAGE_TARBALL=$(readlink -e $1)
PACKAGE_NAME="qdb-all"
PACKAGE_VERSION=$(echo "$PACKAGE_TARBALL" | sed -r 's/.*qdb-(.*)-linux-.*/\1/')

cd $(dirname $0)

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

export SOURCE_C_API=$(*-c-api.tar.gz)
export SOURCE_SERVER=$(*-server.tar.gz)
export SOURCE_UTILS=$(*-utils.tar.gz)
export SOURCE_WEB_BRIDGE=$(*-web-bridge.tar.gz)

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv ../*.tar.gz "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_init.sh "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_limits.conf "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_sysctl.conf "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-web-bridge/qdb_httpd_init.sh "$HOME/rpmbuild/SOURCES"

rpmbuild -v -bb "$SPEC_FILE" 2>&1
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;
