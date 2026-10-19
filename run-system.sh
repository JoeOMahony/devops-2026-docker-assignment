#!/bin/sh

set -e

docker network create --label joeomahony devnet

docker run -d --label joeomahony --network devnet --name devdb \
    -e POSTGRES_USER=devdbuser \
    -e POSTGRES_PASSWORD=devdbpassword \
    -e POSTGRES_DB=musicstore \
    postgres:18.6

# Checking that the database is ready by following the devdb logs and using grep to find the Postgres ready message. 
# Once the message is found, the docker process for following the devdb logs is killed.
docker logs -f devdb 2>&1 | (grep -iF --max-count=1 "[1] LOG:  database system is ready to accept connections"; pkill -f "docker logs -f devdb")

docker build -t devdbseederimage --label joeomahony --target seeder .

SQLITE_FILE=/app/Chinook.db
DATABASE_URL=postgresql://devdbuser:devdbpassword@devdb:5432/musicstore

docker run --rm --network devnet --name devdbseeder --label joeomahony \
    -e DATABASE_URL=$DATABASE_URL \
    -e SQLITE_FILE=$SQLITE_FILE \
    -v "$(pwd)/Chinook.db:/app/Chinook.db" \
    devdbseederimage

docker run -d --name devmcpgateway --label joeomahony --network devnet \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd)/mcp_config.yaml:/mcp_config.yaml \
    -v $(pwd)/mcp_secret.env:/run/secrets/database-url \
    docker/mcp-gateway:latest \
    --transport=sse \
    --secrets=/run/secrets/database-url \
    --allow-unauthenticated \
    --servers=cockroachdb \
    --tools=execute_query \
    --config=/mcp_config.yaml

docker build -t devagentimage --label joeomahony --target agent .

# Outputs in foreground, so can --rm without worrying about losing logs
docker run --rm --name devagent --label joeomahony --network devnet \
    -v $(pwd)/secret.ollama-api-key:/run/secrets/openai-api-key \
    -e MCP_SERVER_URL=http://devmcpgateway:8811/sse \
    -e DATABASE_DIALECT=PostgreSQL \
    -e QUESTION='What are the top 3 albums by sales?' \
    -e OPENAI_API_BASE_URL=https://ollama.com/v1 \
    -e OPENAI_MODEL_NAME=gpt-oss:20b \
    devagentimage
