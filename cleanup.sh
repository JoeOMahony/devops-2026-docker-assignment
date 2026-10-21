#!/bin/sh

docker container stop $(docker ps -a -q --filter "label=joeomahony")
docker rm -v $(docker ps -a -q --filter "label=joeomahony")

docker rmi $(docker images -q --filter "label=joeomahony")
docker rmi postgres:18.6 docker/mcp-gateway:latest $(docker images -q mcp/cockroachdb)

# Alternative is to use docker network prune --force with a filter for 'label=joeomahony', but I'll stay with my command substitution convention 
docker network rm $(docker network ls -q --filter "label=joeomahony")