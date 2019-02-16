#!/bin/bash
# -*- coding: utf-8 -*-
#
# Build lambda deployment package in container locally

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/lambda-env.sh

print_colored_line $color_cyan "[DOING] build lambda deployment package at ${PATH_LAMBDA_DEPLOY_PKG_FILE} in container ${DOCKER_IMAGE_FOR_BUILD} ..."
mkdir -p ${PATH_BUILD_LAMBDA_DIR}
SCRIPT_BUILD_DEPLOY_PKG=${DIR_CONTAINER_WORKSPACE}/bin/build-lbd-deploy-pkg-in-container.sh
docker run -v ${DIR_PROJECT_ROOT}:${DIR_CONTAINER_WORKSPACE} --rm ${DOCKER_IMAGE_FOR_BUILD} bash ${SCRIPT_BUILD_DEPLOY_PKG}
