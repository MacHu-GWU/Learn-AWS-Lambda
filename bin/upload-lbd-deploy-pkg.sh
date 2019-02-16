#!/bin/bash
# -*- coding: utf-8 -*-
#
# Upload lambda deployment package to s3

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/lambda-env.sh

print_colored_line $color_cyan "[DOING] upload lambda deployment package to s3 ..."
upload_deployment_package
