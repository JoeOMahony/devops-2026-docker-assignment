#!/bin/sh
set -e

# Removal commands:
# docker rm -f devdb
# docker network rm devnet
# docker volume prune -f

docker network create --label joeomahony devnet

# Conn String format from README: postgres://[DATABASE_USERNAME]:[DATABASE_PASSWORD]@[DATABASE_DOMAIN_NAME]:5432/[DATABASE_NAME]
# Database.log from the samplelogs dir shows PostgreSQL 18.6 being used
docker run -d --label joeomahony --network devnet --name devdb \
    -e POSTGRES_USER=devdbuser \
    -e POSTGRES_PASSWORD=devdbpassword \
    -e POSTGRES_DB=musicstore \
    postgres:18.6

# Current way of checking that the database is ready is to follow the docker logs for postgres and grep the ready message. 
# Once the message is found, the docker process for following logs is killed.
# ==> Bug fixes from yesterday:
# Bug 1:  Postgres outputs its logs to stderr, not stdout, so you must redirect stderr to stdout to pipe the logs to grep.
# Bug 2:  grep exited correctly, but then docker logs kept following. You need to explicitly kill that follow after grep has returned
# Note:   I will have to clarify whether the timeout command is able to be used as it's not shipped as standard on Mac. Excluding for now.
docker logs -f devdb 2>&1 | (grep -iF --max-count=1 "[1] LOG:  database system is ready to accept connections"; pkill -f "docker logs -f devdb")
