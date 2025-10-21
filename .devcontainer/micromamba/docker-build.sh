#!/usr/bin/env bash

# build the docker image from the docker file and map uid and gid via build args

# docker build -t miseegs-dev --build-arg USER_NAME=$(id -un) --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) .
IMAGE_NAME=dsc-tutorials-dev

docker build -t ${IMAGE_NAME} .
