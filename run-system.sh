#!/bin/sh

# Removes resources created for testing on re-runs
docker network rm devnetwork 

set -e 

docker network create --label joeomahony devnet