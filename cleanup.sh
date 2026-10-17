#!/bin/sh

# -----Relevant resources to delete: (what was created on my clean machine through run-system)-----
# ===> Volumes:
# local     71a2accb5dbf776bbd4855a568615d1cb1e936199c3ff8a831af508086356fcb
# local     fbbf3a7db249924aea084f6d7eecf33f610056a284bf406a563a297a28cfedb6
# ===> Images:
# devagentimage:latest                                                                      f57aa9ba7c37        477MB          116MB        
# devdbseederimage:latest                                                                   b2152defab50       64.1MB         28.5MB        
# docker/mcp-gateway:latest                                                                 f5a679a05fc3        139MB         38.8MB    U         
# mcp/cockroachdb@sha256:4863594a246c6f86a5c4c87383a679353e9a6b4d85c3327c48464669cd236b1e   4863594a246c        357MB         94.4MB        
# postgres:18.6  
# ===> Network:
# fdac31a5fac6   devnet    bridge    local

# ==> Containers to remove:
# 76e44e1185e5   docker/mcp-gateway:latest   "/docker-mcp gateway…"   About a minute ago   Up About a minute              devmcpgateway
# a91113c725ac   postgres:18.6               "docker-entrypoint.s…"   About a minute ago   Up About a minute   5432/tcp   devdb
docker container stop $(docker ps -a -q --filter "label=joeomahony")
docker rm $(docker ps -a -q --filter "label=joeomahony")