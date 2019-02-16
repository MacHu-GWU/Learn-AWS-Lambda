#!/bin/bash
# -*- coding: utf-8 -*-
#
# This script should be sourced to use.

# 你要创建 3.6.8 版本的虚拟环境, 那么你必须得有一个基础的 3.6.8 版本的环境.
# GitHub
GITHUB_ACCOUNT="MacHu-GWU"
GITHUB_REPO_NAME="learn_awslambda-project"


# Python
PACKAGE_NAME="learn_awslambda"
PY_VER_MAJOR="3"
PY_VER_MINOR="6"
PY_VER_MICRO="2"
USE_PYENV="Y" # "Y" or "N"
SUPPORTED_PY_VERSIONS="2.7.13 3.6.2" # "2.7.13 3.6.2"


#--- AWS
AWS_PROFILE="sanhe" # aws profile in ~/.aws/credentials

# html doc will be upload to:
# "s3://${S3_BUCKET_DOC_HOST}/docs/${PACKAGE_NAME}/${PACKAGE_VERSION}"
S3_BUCKET_DOC_HOST="sanherabbit.com"


# deployment package file will be upload to:
# "s3://${S3_BUCKET_LAMBDA_DEPLOY}/lambda/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}/${PACKAGE_NAME}-${PACKAGE_VERSION}.zip"
S3_BUCKET_LAMBDA_DEPLOY="sanhe-learn-aws-lambda-with-sls-deploy"


# Docker
DOCKER_IMAGE_FOR_BUILD="lambci/lambda:build-python3.6"
DOCKER_IMAGE_FOR_RUN="lambci/lambda:python3.6"
DIR_CONTAINER_WORKSPACE="/var/task"

