#!/bin/bash
# -*- coding: utf-8 -*-
#
# Deploy html doc to s3://<s3-bucket-name>/<dir-prefix>/<package-name>/<version>


DIR_BIN="$( cd "$(dirname "$0")" ; pwd -P )"
DIR_PROJECT_ROOT=$(dirname "${DIR_BIN}")

source ${DIR_BIN}/python-env.sh

print_colored_line $color_cyan "[DOING] deploy ${PATH_SPHINX_DOC_BUILD_HTML} to ${S3_URI_DOC_VERSIONED} ..."
deploy_doc_to_s3 ${PATH_SPHINX_DOC_BUILD_HTML} ${S3_URI_DOC_VERSIONED}
