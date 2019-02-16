#!/bin/bash

DIR_REPO=$(git rev-parse --show-toplevel)
source ${DIR_REPO}/make/env-var.sh

resolve_lambda_devops()
{
    aws s3 s3://${BUCKET_LAMBDA_DEPLOY}/lbd-deploy/${GITHUB_ACCOUNT}/${REPO_NAME}/
}