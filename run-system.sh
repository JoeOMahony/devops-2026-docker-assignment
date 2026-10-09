#!/bin/sh
set -e

docker network create --label joeomahony devnet

# Conn String format from README: postgres://[DATABASE_USERNAME]:[DATABASE_PASSWORD]@[DATABASE_DOMAIN_NAME]:5432/[DATABASE_NAME]
# Database.log from the samplelogs dir shows PostgreSQL 18.6 being used
docker run -d --label joeomahony --network devnet --name devdb \
    -e POSTGRES_USER=devdbuser \
    -e POSTGRES_PASSWORD=devdbpassword \
    -e POSTGRES_DB=musicstore \
    postgres:18.6

# Current way of checking ready is to follow the docker logs and grep the ready message
docker logs -f devdb | grep -iF --max-count=1 "[1] LOG:  database system is ready to accept connections"