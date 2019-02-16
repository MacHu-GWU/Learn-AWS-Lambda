#!/bin/bash
# NOTE: This file should be sourced for use

GITHUB_ACCOUNT="MacHu-GWU"
PACKAGE_NAME="learn_awslambda"
PY_VER_MAJOR="3"
PY_VER_MINOR="6"
PY_VER_MICRO="2"
USE_PYENV="Y"

# -- AWS Lambda

AWS_PROFILE="sanhe"
DOCKER_BUILD_IMAGE="lambci/lambda:build-python3.6"
DIR_CONTAINER_WORKSPACE="/var/task"
LAMBDA_DEPLOY_PKG_FILENAME="tmp-deployment-package.zip"
BUCKET_LAMBDA_DEPLOY="sanhe-learn-aws-lambda-with-sls-deploy"

resolve_lambda_deploy()
{
    TMP_BUCKET_LAMBDA_DEPLOY
}


# -- derive other variable
# Virtualenv Name
VENV_NAME="${PACKAGE_NAME}_venv"

# Full Python Version
PY_VERSION="${PY_VER_MAJOR}.${PY_VER_MINOR}.${PY_VER_MICRO}"
PY_VERSION_MAJOR_AND_MINOR="${PY_VER_MAJOR}.${PY_VER_MINOR}"

# Project Root Directory
DIR_REPO=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename ${DIR_REPO})


resolve_repo_files()
{
    local TMP_DIR_REPO=$1

    PATH_README=${TMP_DIR_REPO}/README.rst
    PATH_SPHINX_CONFIG=${TMP_DIR_REPO}/docs/source/conf.py
    PATH_SPHINX_INDEX_HTML=${TMP_DIR_REPO}/docs/build/html/index.html
    PATH_LAMBDA_DEPLOY_PKG_FILE=${TMP_DIR_REPO}/${LAMBDA_DEPLOY_PKG_FILENAME}
}

resolve_repo_files ${DIR_REPO}


resolve_venv_bin()
{
    local TMP_DIR_VENV_BIN=$1

    BIN_ACTIVATE="${TMP_DIR_VENV_BIN}/activate"
    BIN_PYTHON="${TMP_DIR_VENV_BIN}/python"
    BIN_PIP="${TMP_DIR_VENV_BIN}/pip"
    BIN_PYTEST="${TMP_DIR_VENV_BIN}/pytest"
    BIN_SPHINX_START="${TMP_DIR_VENV_BIN}/sphinx-quickstart"
    BIN_TWINE="${TMP_DIR_VENV_BIN}/twine"
    BIN_TOX="${TMP_DIR_VENV_BIN}/tox"
    BIN_JUPYTER="${TMP_DIR_VENV_BIN}/jupyter"
    BIN_AWS="${TMP_DIR_VENV_BIN}/aws"
}

resolve_other_venv_dir_on_windows()
{
    local TMP_DIR_VENV=$1

    DIR_VENV_BIN="${TMP_DIR_VENV}/Scripts"
    DIR_VENV_SITE_PACKAGES="${TMP_DIR_VENV}/Lib/site-packages"
    DIR_VENV_SITE_PACKAGES64="${TMP_DIR_VENV}/Lib64/site-packages"
}

resolve_other_venv_dir_on_darwin_or_linux()
{
    local TMP_DIR_VENV=$1
    local TMP_PY_VERSION_MAJOR_AND_MINOR=$2

    DIR_VENV_BIN="${TMP_DIR_VENV}/bin"
    DIR_VENV_SITE_PACKAGES="${TMP_DIR_VENV}/lib/python${TMP_PY_VERSION_MAJOR_AND_MINOR}/site-packages"
    DIR_VENV_SITE_PACKAGES64="${TMP_DIR_VENV}/lib64/python${TMP_PY_VERSION_MAJOR_AND_MINOR}/site-packages"
}

# ---
resolve_windows_venv()
{
    local TMP_VENV_NAME=$1
    local TMP_PY_VERSION_MAJOR_AND_MINOR=$2

    local TMP_DIR_ENVS="${HOMEPATH}/venvs/python/${TMP_PY_VERSION_MAJOR_AND_MINOR}"
    mkdir -p ${TMP_DIR_ENVS}
    DIR_VENV="${TMP_DIR_ENVS}/${TMP_VENV_NAME}"
    resolve_other_venv_dir_on_windows ${DIR_VENV}
    resolve_venv_bin ${DIR_VENV_BIN}
}


resolve_mac_pyenv()
{
    local TMP_VENV_NAME=$1
    local TMP_PY_VERSION=$2
    local TMP_PY_VERSION_MAJOR_AND_MINOR=$3

    DIR_VENV="${HOME}/.pyenv/versions/${TMP_PY_VERSION}/envs/${TMP_VENV_NAME}"
    resolve_other_venv_dir_on_darwin_or_linux ${DIR_VENV} ${TMP_PY_VERSION_MAJOR_AND_MINOR}
    resolve_venv_bin ${DIR_VENV_BIN}
}


resolve_mac_venv()
{
    local TMP_VENV_NAME=$1
    local TMP_PY_VERSION=$2
    local TMP_PY_VERSION_MAJOR_AND_MINOR=$3

    mkdir -p "${HOME}/venvs/python/versions/${TMP_PY_VERSION}/envs"
    DIR_VENV="${HOME}/venvs/python/versions/${TMP_PY_VERSION}/envs/${TMP_VENV_NAME}"
    resolve_other_venv_dir_on_darwin_or_linux ${DIR_VENV} ${TMP_PY_VERSION_MAJOR_AND_MINOR}
    resolve_venv_bin ${DIR_VENV_BIN}
}


if [ "$USE_PYENV" = "Y" ]
then
    resolve_mac_pyenv ${VENV_NAME} ${PY_VERSION} ${PY_VERSION_MAJOR_AND_MINOR}
else
    resolve_mac_venv ${VENV_NAME} ${PY_VERSION} ${PY_VERSION_MAJOR_AND_MINOR}
fi

get_pkg_version()
{
    local TMP_BIN_PIP=$1
    local TMP_PACKAGE_NAME=$2
    PKG_VERSION=$(${TMP_BIN_PIP} show ${TMP_PACKAGE_NAME} | grep Version)
    PKG_VERSION=${PKG_VERSION:9:100}
}

resolve_lambda_devops()
{
    aws s3 s3://${BUCKET_LAMBDA_DEPLOY}/lbd-deploy/${GITHUB_ACCOUNT}/${REPO_NAME}/
}

