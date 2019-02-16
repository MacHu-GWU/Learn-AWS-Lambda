#!/bin/bash
# NOTE: This script should be executed inside of the container

DIR_REPO=$(git rev-parse --show-toplevel)
source ${DIR_REPO}/make/env-var.sh

VENV_NAME=${VENV_NAME}_tmp
resolve_repo_files ${DIR_REPO}
resolve_mac_venv ${VENV_NAME} ${PY_VERSION} ${PY_VERSION_MAJOR_AND_MINOR}

rm -r ${DIR_VENV}
rm -r ${PATH_LAMBDA_DEPLOY_PKG_FILE}

cd ${DIR_REPO}

echo "Create virtual env..."
virtualenv ${DIR_VENV}
echo "Create virtual env complete!"

echo "Pip install dependencies..."
${BIN_PIP} install .
echo "Install dependencies complete!"

cd ${DIR_VENV_SITE_PACKAGES}

echo "Zip dependencies..."
zip ${PATH_LAMBDA_DEPLOY_PKG_FILE} * -r -9 -q -x boto3\* botocore\* setuptools\* pip\* wheel\* twine\*_pytest\* pytest\*;
echo "Build deployment package complete!"

rm -r ${DIR_VENV}
