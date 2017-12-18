#!/bin/sh -eu


SPEC_FILE="qdb-all.spec"
PACKAGE_TARBALL=$(readlink -e $1)
PACKAGE_NAME="qdb-all"
PACKAGE_VERSION=$(echo "$PACKAGE_TARBALL" | sed -r 's/.*qdb-(.*)-linux-.*/\1/')

cd $(dirname $0)

export PACKAGE_VERSION PACKAGE_NAME PACKAGE_TARBALL
envsubst < "$SPEC_FILE.in" > "$SPEC_FILE"

echo $PWD

ls -l ..

mkdir -p "$HOME/rpmbuild/SOURCES"
cp -fv ../*.tar.gz "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_init.sh "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_limits.sh "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-server/qdbd_sysctl.sh "$HOME/rpmbuild/SOURCES"
cp -fv ../qdb-web-bridge/qdb_httpd_init.sh "$HOME/rpmbuild/SOURCES"

rpmbuild -v -bb "$SPEC_FILE" 2>&1
find "$HOME/rpmbuild/RPMS" -name '*.rpm' -exec mv {} . \;
