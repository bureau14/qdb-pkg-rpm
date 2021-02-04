#!/usr/bin/env bash

VERSION="3.9.7"

if [[ "${VERSION}" =~ ([0-9.]+)~nightly ]]
then
    # Nightly
    DATE=$(date +'%Y%m%d')
    VERSION="${BASH_REMATCH[1]}~${DATE}"
fi

echo ${VERSION}
