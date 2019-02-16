#!/bin/bash
# -*- coding: utf-8 -*-
#
# Build lambda deployment package in container locally

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/lambda-env.sh

#print_colored_line $color_cyan "[DOING] build lambda deployment package at ${PATH_LAMBDA_DEPLOY_PKG_FILE} ..."

deploy_function "numpy_ver" "arn:aws:iam::663351365541:role/service-role/LambdaFunction"
