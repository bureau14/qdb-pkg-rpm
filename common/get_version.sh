#!/usr/bin/env bash

INPUT_VERSION=$1;shift

VERSION="${INPUT_VERSION}"

if [[ "${INPUT_VERSION}" =~ ([0-9.]+)master ]]
then
    # Nightly
    DATE=$(date +'%Y%m%d')
    VERSION="${BASH_REMATCH[1]}~${DATE}"
fi

echo ${VERSION}
