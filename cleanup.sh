#!/bin/sh

# -----Relevant resources to delete: (what was created on my clean machine through run-system)-----
# ===> Images to remove:
# devagentimage:latest                                                                      f57aa9ba7c37        477MB          116MB        
# devdbseederimage:latest                                                                   b2152defab50       64.1MB         28.5MB        
# docker/mcp-gateway:latest                                                                 f5a679a05fc3        139MB         38.8MB    U         
# mcp/cockroachdb@sha256:4863594a246c6f86a5c4c87383a679353e9a6b4d85c3327c48464669cd236b1e   4863594a246c        357MB         94.4MB        
# postgres:18.6  
# ===> Network to remove:
# fdac31a5fac6   devnet    bridge    local


docker container stop $(docker ps -a -q --filter "label=joeomahony")
# Since the two volumes to be removed are anonymous and pruning an unknown system is not appropriate, I researched how I would go about this.
# The first result, Docker documentation for 'docker compose down', specified that associated volumes can be removed with the -v flag.
# I then remembered this was mentioned in a lab, and so I am updating the below directive with the -v flag.
docker rm -v $(docker ps -a -q --filter "label=joeomahony")