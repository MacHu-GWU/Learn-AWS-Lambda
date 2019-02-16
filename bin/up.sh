#!/bin/bash
# -*- coding: utf-8 -*-

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/python-env.sh

print_colored_line $color_cyan "[DOING] create virtualenv for ${VENV_NAME} at ${DIR_VENV} ..."
if [ ${USE_PYENV} == "Y" ]; then
    pyenv virtualenv ${PY_VERSION} ${VENV_NAME}
    ${BIN_PIP} install --upgrade pip
else
    virtualenv -p ${BIN_GLOBAL_PYTHON} ${DIR_VENV}
    ${BIN_PIP} install --upgrade pip
fi
