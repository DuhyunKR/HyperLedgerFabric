#!/bin/bash

# function setOrg1() {
#     export CORE_PEER_TLS_ENABLED=true
#     export CORE_PEER_LOCALMSPID="Org1MSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
#     export CORE_PEER_ADDRESS=localhost:7051
# } 

# function setOrg2 {
#     export CORE_PEER_TLS_ENABLED=true
#     export CORE_PEER_LOCALMSPID="Org2MSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
#     export CORE_PEER_ADDRESS=localhost:9051
# }

. scripts/Utils.sh 

# 0. 환경설정
export FABRIC_CFG_PATH=${PWD}/config
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

CHANNEL_NAME="mychannel"
DELAY=3

# 1. channel 준비물생성
# 1.1 channel 트랜젝션 생성
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
# 1.2 anchor 트랜젝션 생성
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/${CHANNEL_NAME}Org1MSPAnchor.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/${CHANNEL_NAME}Org2MSPAnchor.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

# 2. channel 생성
setOrg1
export FABRIC_CFG_PATH=~/fabric-samples/config
peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA

sleep ${DELAY}

# 3. channel 조인
# 3.1 org1
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block

sleep ${DELAY}

# 3.2 org2
setOrg2
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block

sleep ${DELAY}

# 4. anchor update
# 4.1 org1
setOrg1
peer channel update -f ./channel-artifacts/${CHANNEL_NAME}Org1MSPAnchor.tx -c ${CHANNEL_NAME} -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA

sleep ${DELAY}

# 4.2 org2
setOrg2
peer channel update -f ./channel-artifacts/${CHANNEL_NAME}Org2MSPAnchor.tx -c ${CHANNEL_NAME} -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA

sleep ${DELAY}
