#!/bin/bash
# -*- coding: utf-8 -*-

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/python-env.sh

print_colored_line $color_cyan "[DOING] Run test in python ${SUPPORTED_PY_VERSIONS} with tox ..."
${BIN_PIP} install tox
cd ${DIR_PROJECT_ROOT}
pyenv local ${SUPPORTED_PY_VERSIONS}
${BIN_TOX}
