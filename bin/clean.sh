#!/bin/bash
# -*- coding: utf-8 -*-
#
# Clean up all temp information

DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/lambda-env.sh

print_colored_line $color_cyan "[DOING] remove all temp files ..."

rm_if_exists ${PATH_COVERAGE_ANNOTATE_DIR}
rm_if_exists ${PATH_TOX_DIR}
rm_if_exists ${PATH_BUILD_DIR}
rm_if_exists ${PATH_DIST_DIR}
rm_if_exists ${PATH_EGG_DIR}
rm_if_exists ${PATH_PYTEST_CACHE_DIR}
rm_if_exists ${PATH_PYTEST_CACHE_DIR}
rm_if_exists ${PATH_LAMBDA_DEPLOY_PKG_FILE}
