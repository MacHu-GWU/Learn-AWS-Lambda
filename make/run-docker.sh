source env-var.sh
CONTAINER_ID=$(docker run -dt \
    --mount type=bind,source=${ROOT},target=/lambda/${ROOT_BASENAME} \
    kilna/python-lambda:3.6)

