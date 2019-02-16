#!/bin/bash

DIR_PROJECT_ROOT="/Users/sanhehu/Documents/GitHub/learn_awslambda-project"
DIR_CONTAINER_WORKSPACE="/var/task"
docker run -dt --name lbd -v ${DIR_PROJECT_ROOT}:${DIR_CONTAINER_WORKSPACE} --rm lambci/lambda:build-python3.6 bash
docker exec -it lbd bash


virtualenv /root/venvs/python/3.6.2/learn_awslambda_venv

/root/venvs/python/3.6.2/learn_awslambda_venv/bin/pip install .
