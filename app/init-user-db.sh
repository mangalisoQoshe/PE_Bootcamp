#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres <<-EOSQL
	
	CREATE DATABASE students;
	GRANT ALL PRIVILEGES ON DATABASE students TO admin;
EOSQL