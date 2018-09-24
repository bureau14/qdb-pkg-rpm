#!/usr/bin/env bash

TARBALL=$1

if [[ ${TARBALL} = *"master"* ]]
then
    VERSION=$(echo ${TARBALL} | sed -r 's/.*qdb-([0-9\.a-z_]+)-linux-.*/\1/')
    DATE=$(date +'%Y%m%d')
    echo "${VERSION}-${DATE}"
else
    echo ${TARBALL} | sed -r 's/.*qdb-([0-9\.a-z_]+)-linux-.*/\1/'
fi
