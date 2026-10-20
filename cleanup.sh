#!/bin/sh

# -----Relevant resources to delete: (what was created on my clean machine through run-system)-----
# ===> Network to remove:
# fdac31a5fac6   devnet    bridge    local

docker container stop $(docker ps -a -q --filter "label=joeomahony")

docker rm -v $(docker ps -a -q --filter "label=joeomahony")

docker rmi $(docker images -q --filter "label=joeomahony")
docker rmi postgres:18.6 docker/mcp-gateway:latest $(docker images -q mcp/cockroachdb)
