#!/bin/bash
# -*- coding: utf-8 -*-

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/python-env.sh

print_colored_line $color_cyan "[DOING] Run tests in ${PATH_TEST_DIR} ..."
cd ${DIR_PROJECT_ROOT}
${BIN_PYTEST} ${PATH_TEST_DIR} -s
