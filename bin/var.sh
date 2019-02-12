#!/bin/bash

PACKAGE_NAME="learn_awslambda"
GITHUB_ACCOUNT="MacHu-GWU"

ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename ${ROOT})
GITHUB_REPO="https://github.com/${GITHUB_ACCOUNT}/${REPO_NAME}"
DIR_HANDLERS=${ROOT}/${PACKAGE_NAME}/handlers





