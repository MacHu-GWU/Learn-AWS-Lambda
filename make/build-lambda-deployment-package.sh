#!/bin/bash

GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
source ${GIT_ROOT_DIR}/make/env-var.sh
docker run -dt --name lbd --mount type=bind,source=/Users/sanhehu/Documents/GitHub/learn_awslambda-project,target=/workspace/learn_awslambda-project lambci/lambda:build-python3.6 bash