#!/bin/sh
set -e

# Removal commands:
# docker rm -f devdb
# docker network rm devnet
# docker rm -f devdbseeder
# docker rmi devdbseederimage
# docker volume prune -f 

docker network create --label joeomahony devnet

# Database.log from the samplelogs dir shows PostgreSQL 18.6 being used
docker run -d --label joeomahony --network devnet --name devdb \
    -e POSTGRES_USER=devdbuser \
    -e POSTGRES_PASSWORD=devdbpassword \
    -e POSTGRES_DB=musicstore \
    postgres:18.6

# Current way of checking that the database is ready is to follow the docker logs for postgres and grep the ready message. 
# Once the message is found, the docker process for following logs is killed.
docker logs -f devdb 2>&1 | (grep -iF --max-count=1 "[1] LOG:  database system is ready to accept connections"; pkill -f "docker logs -f devdb")

docker build -t devdbseederimage --label joeomahony --target seeder .

SQLITE_FILE=/app/Chinook.db
DATABASE_URL=postgresql://devdbuser:devdbpassword@devdb:5432/musicstore

docker run --rm --network devnet --name devdbseeder --label joeomahony \
    -e DATABASE_URL=$DATABASE_URL \
    -e SQLITE_FILE=$SQLITE_FILE \
    -v "$(pwd)/Chinook.db:/app/Chinook.db" \
    devdbseederimage
