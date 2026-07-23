#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="/home/carlos/hp-minipc"
DOCKER_NETWORK="container:gluetun_qbit"
QBIT_CONFIG="${PROJECT_DIR}/data/qbittorrent/qBittorrent/qBittorrent.conf"
HEALTHCHECKS_URL="$(cat "${PROJECT_DIR}/secrets/healthchecks_qbit_url")"
API_KEY="$(cat "${PROJECT_DIR}/secrets/portpeek_api_key")"

finish() {
    local status=$?
    /usr/bin/curl -fsS -m 10 --retry 5 -o /dev/null "${HEALTHCHECKS_URL}/${status}" || true
    exit "${status}"
}

trap finish EXIT

port="$(sed -n 's/^Session\\Port=//p' "$QBIT_CONFIG")"

result="$(
    /usr/bin/docker run --rm \
        --network "${DOCKER_NETWORK}" \
        curlimages/curl:latest \
        -fsS -m 10 --retry 5 \
        -H "X-API-Key: ${API_KEY}" \
        "https://portpeek.onrender.com/v1/check?port=${port}"
)"

if [[ "$result" != "OPEN" ]]; then
    echo "[ERROR] Unexpected port status for port ${port}: ${result}" >&2
    exit 1
fi
