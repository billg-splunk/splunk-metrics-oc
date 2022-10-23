#!/bin/bash
set -e

export PGPASSWORD="example"
psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "postgres" <<-EOSQL
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
EOSQL