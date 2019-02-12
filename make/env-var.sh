#!/bin/bash

PACKAGE_NAME="learn_awslambda"
PY_VER_MAJOR="3"
PY_VER_MINOR="6"
PY_VER_MICRO="2"
USE_PYENV="Y"
DOCKER_BUILD_IMAGE="lambci/lambda:build-python3.6"
DOCKER_RUN_IMAGE="lambci/lambda:python3.6"

# -- derive other variable
# Virtualenv Name
VENV_NAME="${PACKAGE_NAME}_venv"

# Full Python Version
PY_VERSION="${PY_VER_MAJOR}.${PY_VER_MINOR}.${PY_VER_MICRO}"

# Project Root Directory
GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
ROOT_DIRNAME=$(basename ${GIT_ROOT_DIR})


resolve_pyenv()
{
    VENV_DIR="${HOME}/.pyenv/versions/${PY_VERSION}/envs/${VENV_NAME}"
    BIN_DIR="${VENV_DIR}/bin"
    SITE_PACKAGES="${VENV_DIR}/lib/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
    SITE_PACKAGES64="${VENV_DIR}/lib64/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
}

resolve_venv()
{
    VENV_DIR="${GIT_ROOT_DIR}/${VENV_NAME}"
    BIN_DIR="${VENV_DIR}/bin"
    SITE_PACKAGES="${VENV_DIR}/lib/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
    SITE_PACKAGES64="${VENV_DIR}/lib64/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
}


if [ "$USE_PYENV" = "Y" ]
then
    VENV_DIR_REAL="${HOME}/.pyenv/versions/${PY_VERSION}/envs/${VENV_NAME}"
    VENV_DIR_LINK="${HOME}/.pyenv/versions/${VENV_NAME}"
    BIN_DIR="${VENV_DIR_REAL}/bin"
    SITE_PACKAGES="${VENV_DIR_REAL}/lib/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
    SITE_PACKAGES64="${VENV_DIR_REAL}/lib64/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
else
    VENV_DIR_REAL="${ROOT_DIRNAME}/${VENV_NAME}"
    VENV_DIR_LINK="./${VENV_NAME}"
    BIN_DIR="${VENV_DIR_REAL}/bin"
    SITE_PACKAGES="${VENV_DIR_REAL}/lib/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
    SITE_PACKAGES64="${VENV_DIR_REAL}/lib64/python${PY_VER_MAJOR}.${PY_VER_MINOR}/site-packages"
fi

BIN_PYTHON="${BIN_DIR}/python"
BIN_PIP="${BIN_DIR}/pip"

