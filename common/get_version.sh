#!/usr/bin/env bash

TARBALL=$1

# Check if there is only version without branch name (e.g. master or qdb-1234)
if [[ ${TARBALL} =~ -[0-9.]+- ]]
then
    # Release
    VERSION=$(echo ${TARBALL} | sed -r 's/.*qdb-([0-9\.]+)-linux-.*/\1/')
    echo ${VERSION}
else
    # Dev
    VERSION=$(echo ${TARBALL} | sed -r 's/.*qdb-([0-9\.]+)([0-9\.a-z_]+)-linux-.*/\1/')
    DATE=$(date +'%Y%m%d')
    echo "${VERSION}master_${DATE}"
fi
