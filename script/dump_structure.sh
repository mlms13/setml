#!/usr/bin/env bash
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
eval `script/db_env.sh`
>&2 echo "${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
PGPASSWORD="$DB_PASS" \
  pg_dump \
    -sFp \
    --no-acl \
    --no-owner \
    --host "$DB_HOST" \
    --port "$DB_PORT" \
    --user "$DB_USER" \
    "$DB_NAME"
