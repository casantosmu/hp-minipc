#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="/home/carlos/hp-minipc"
API_TOKEN="$(cat "${PROJECT_DIR}/secrets/cloudflare_api_token")"
HEALTHCHECKS_URL="$(cat "${PROJECT_DIR}/secrets/healthchecks_ddns_url")"

finish() {
    local status=$?
    /usr/bin/curl -fsS -m 10 --retry 5 -o /dev/null "${HEALTHCHECKS_URL}/${status}" || true
    exit "${status}"
}

trap finish EXIT

/usr/bin/docker run --rm \
    --user 1000:1000 \
    --env ZONE_NAME=casantosmu.com \
    --env RECORD_NAME=jellyfin.casantosmu.com \
    --env API_TOKEN="${API_TOKEN}" \
    ghcr.io/casantosmu/ddns-updater:main
