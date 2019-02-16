#!/bin/bash

DIR_REPO=$(git rev-parse --show-toplevel)
source ${DIR_REPO}/make/env-var.sh

SCRIPT_BUILD_DEPLOY_PKG=${DIR_CONTAINER_WORKSPACE}/make/build-lbd-deploy-pkg-from-container.sh

docker run -v ${DIR_REPO}:${DIR_CONTAINER_WORKSPACE} --rm ${DOCKER_BUILD_IMAGE} bash ${SCRIPT_BUILD_DEPLOY_PKG}
