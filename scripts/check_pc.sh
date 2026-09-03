#!/usr/bin/env bash

set -euo pipefail

HEALTHCHECKS_URL="$(cat "/home/carlos/hp-minipc/secrets/healthchecks_pc_url")"
/usr/bin/curl -fsSL -m 10 --retry 5 -o /dev/null "${HEALTHCHECKS_URL}" 2> >(/usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >&2)
