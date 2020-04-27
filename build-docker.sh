#!/usr/bin/env sh


if ! test -f "artifacts/MITIE-models-v0.2.tar.bz2"; then
    wget -O - http://sourceforge.net/projects/mitie/files/binaries/MITIE-models-v0.2.tar.bz2 > artifacts/MITIE-models-v0.2.tar.bz2
fi

DT=$(date +"%Y%m%d")
GIT=${DT}.git.$(git rev-parse --short HEAD)
VERSION="0.1"
IMAGE=mitie

docker build -t "${IMAGE}:dev" -t "${IMAGE}:${VERSION}" -t "${IMAGE}:${GIT}" .
