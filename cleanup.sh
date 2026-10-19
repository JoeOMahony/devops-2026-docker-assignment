#!/bin/sh

# -----Relevant resources to delete: (what was created on my clean machine through run-system)-----
# ===> Network to remove:
# fdac31a5fac6   devnet    bridge    local

docker container stop $(docker ps -a -q --filter "label=joeomahony")

docker rm -v $(docker ps -a -q --filter "label=joeomahony")

# Removes devagentimage and devdbseederimage
docker rmi $(docker images -q --filter "label=joeomahony")

# Still need to remove: postgres:18.6 / docker/mcp-gateway:latest / mcp/cockroachdb@sha256:4863594a246c6f86a5c4c87383a679353e9a6b4d85c3327c48464669cd236b1emm