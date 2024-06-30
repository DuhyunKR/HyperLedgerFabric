#!/bin/bash

# 0. 환경변수 설정
export FABRIC_CFG_PATH=${PWD}/config

# 1. identity 생성
cryptogen generate --config=./config/crypto-config.yaml --output="organizations"

# 2. genesis.block 생성
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block

# 3. docker-compose 수행
IMAGE_TAG=latest docker-compose -f docker/docker-compose.yaml up -d
