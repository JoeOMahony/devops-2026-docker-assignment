#!/bin/sh

docker container stop $(docker ps -a -q --filter "label=joeomahony")
docker rm -v $(docker ps -a -q --filter "label=joeomahony")

docker rmi $(docker images -q --filter "label=joeomahony")
docker rmi postgres:18.6 docker/mcp-gateway:latest $(docker images -q mcp/cockroachdb)

docker network rm $(docker network ls -q --filter "label=joeomahony")