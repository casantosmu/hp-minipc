#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="/home/carlos/hp-minipc"
BACKUPS_DIR="/mnt/storage/backups"
RESTIC_IMAGE="restic/restic:0.19.1"
HEALTHCHECKS_URL="$(cat "${PROJECT_DIR}/secrets/healthchecks_backup_url")"

run_restic() {
    /usr/bin/docker run --rm \
        --user 1000:1000 \
        --hostname "$(hostname)" \
        --volume "${BACKUPS_DIR}/repository:/repo" \
        --volume "${BACKUPS_DIR}/cache:/cache" \
        --volume "${PROJECT_DIR}/secrets/restic_password:/restic_password:ro" \
        --volume "${PROJECT_DIR}:/data:ro" \
        "${RESTIC_IMAGE}" \
        --repo /repo \
        --cache-dir /cache \
        --password-file /restic_password \
        "$@"
}

finish() {
    local status=$?

    echo "Starting Docker Compose services..."
    /usr/bin/docker compose --project-directory "${PROJECT_DIR}" start || true

    /usr/bin/curl -fsSL -m 10 --retry 5 -o /dev/null "${HEALTHCHECKS_URL}/${status}" 2> >(/usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >&2) || true

    exit "${status}"
}

trap finish EXIT

echo "Stopping Docker Compose services..."
/usr/bin/docker compose --project-directory "${PROJECT_DIR}" stop

echo "Creating backup..."
run_restic backup /data \
    --exclude-caches \
    --exclude ".git"

echo "Applying retention policy..."
run_restic forget \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 1 \
    --prune

echo "Backup completed."
