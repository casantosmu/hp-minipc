#!/bin/sh
set -eu

token=/run/secrets/aria2_token
if [ ! -f "$token" ] || [ ! -s "$token" ]; then
    echo "Missing or empty RPC token: $token" >&2
    exit 1
fi

config=/tmp/aria2.conf
cp /etc/aria2/aria2.conf "$config"
chmod 600 "$config"
printf '\nrpc-secret=' >> "$config"
cat "$token" >> "$config"

exec aria2c --conf-path="$config"
