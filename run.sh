#!/bin/bash

set -euo pipefail

DATA_PATH=$(realpath "./data")
ENV_FILE=".env"

if [[ ! -f ${ENV_FILE} ]]; then
	echo "Missing ${ENV_FILE}. Copy .env.example to .env and set TS_AUTHKEY."
	exit 1
fi

echo "Ensuring data path exists!"
if [[ ! -d ${DATA_PATH} ]]; then
	echo "Data path '${DATA_PATH}' does not exist, creating now!"
	mkdir -p ${DATA_PATH}
fi

echo "Starting the stack now!"
docker compose up -d --build
