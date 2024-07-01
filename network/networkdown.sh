#!/bin/bash

# 도커 다운
docker-compose -f docker/docker-compose.yaml down -v

# 체인코드 이미지 삭제

# organization 아이덴티티 준비물 삭제
rm -rf organizations/ordererOrganizations
rm -rf organizations/peerOrganizations

# genesis.block 삭제
rm -rf system-genesis-block

# channel 준비물 삭제
rm -rf channel-artifacts
