#!/bin/bash
# -*- coding: utf-8 -*-
#
# Run Jupyter notebook

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/python-env.sh

print_colored_line $color_cyan "[DOING] Run Jupyter Notebook locally ..."
${BIN_PIP} install jupyter
${BIN_JUPYTER} notebook
