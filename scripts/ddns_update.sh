#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="/home/carlos/hp-minipc"
API_TOKEN_FILE="${PROJECT_DIR}/secrets/cloudflare_api_token"
HEALTHCHECKS_URL="$(cat "${PROJECT_DIR}/secrets/healthchecks_ddns_url")"

finish() {
    local status=$?
    /usr/bin/curl -fsSL -m 10 --retry 5 -o /dev/null "${HEALTHCHECKS_URL}/${status}" 2> >(/usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >&2) || true
    exit "${status}"
}

trap finish EXIT

/usr/bin/docker run --rm \
    --user 1000:1000 \
    --mount type=bind,src="${API_TOKEN_FILE}",dst=/run/secrets/cloudflare_api_token,ro \
    ghcr.io/casantosmu/ddns-updater:main \
    --zone casantosmu.com \
    --record jellyfin.casantosmu.com \
    --api-token-file /run/secrets/cloudflare_api_token
