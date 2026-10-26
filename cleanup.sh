#!/bin/sh

docker container stop $(docker ps -a -q --filter "label=joeomahony")
docker rm -v $(docker ps -a -q --filter "label=joeomahony")

docker rmi $(docker images -q --filter "label=joeomahony")

# The assignment spec asks to remove built images (done above). The three images below are pulled, not built.
# I'm unsure if they qualify, but leaning towards not. If they should be removed, uncomment out the directive below to remove them.
# docker rmi postgres:18.6 docker/mcp-gateway:latest $(docker images -q mcp/cockroachdb)

docker network rm $(docker network ls -q --filter "label=joeomahony")