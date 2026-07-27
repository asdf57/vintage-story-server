#!/bin/bash

set -euo pipefail

DATA_PATH=$(realpath "./data")
ENV_FILE=".env"
SERVER_CONFIG="${DATA_PATH}/serverconfig.json"
SERVER_CONFIG_TIMEOUT_SECS=60
TMP_SERVER_CONFIG="${SERVER_CONFIG}.tmp"

if [[ ! -f ${ENV_FILE} ]]; then
	echo "Missing ${ENV_FILE}. Copy .env.example to .env and set TS_AUTHKEY."
	exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
	echo "Missing required dependency: jq"
	exit 1
fi

echo "Ensuring data path exists!"
if [[ ! -d ${DATA_PATH} ]]; then
	echo "Data path '${DATA_PATH}' does not exist, creating now!"
	mkdir -p ${DATA_PATH}
fi

if [[ ! -w ${DATA_PATH} ]]; then
	echo "Fixing ownership on '${DATA_PATH}' for $(id -un)..."
	sudo chown -R "$(id -u):$(id -g)" "${DATA_PATH}"
fi

if [[ ! -w ${DATA_PATH} ]]; then
	echo "Data path '${DATA_PATH}' is still not writable by $(id -un)."
	exit 1
fi

echo "Starting the stack now!"
docker compose up -d --build

echo "Waiting for '${SERVER_CONFIG}' to be created..."
for ((i = 0; i < SERVER_CONFIG_TIMEOUT_SECS; i++)); do
	if [[ -f ${SERVER_CONFIG} ]]; then
		break
	fi

	sleep 1
done

if [[ ! -f ${SERVER_CONFIG} ]]; then
	echo "Timed out waiting for '${SERVER_CONFIG}'."
	exit 1
fi

echo "Setting WhitelistMode to 1 in '${SERVER_CONFIG}'..."
jq '.WhitelistMode = 1' "${SERVER_CONFIG}" > "${TMP_SERVER_CONFIG}"
mv "${TMP_SERVER_CONFIG}" "${SERVER_CONFIG}"
