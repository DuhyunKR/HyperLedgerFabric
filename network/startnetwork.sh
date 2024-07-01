#!/bin/bash

# 0. 환경변수 설정
export FABRIC_CFG_PATH=${PWD}/config

# 1. identity 생성
#cryptogen generate --config=./config/crypto-config.yaml --output="organizations"
IMAGE_TAG=latest docker-compose -f docker/docker-compose.yaml up -d ca_org1 ca_org2 ca_orderer

. scripts/registerEnroll.sh

echo "---   Create Org1 crypto material"
createOrg1

echo "---   Create Org2 crypto material"
createOrg2

echo "---   Create Orderer crypto material"
createOrderer

# 2. genesis.block 생성
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block

# 3. docker-compose 수행
IMAGE_TAG=latest docker-compose -f docker/docker-compose.yaml up -d orderer.example.com peer0.org1.example.com peer0.org2.example.com
