#!/bin/bash

. scripts/Utils.sh

# 0. 환경설정
export FABRIC_CFG_PATH=~/fabric-samples/config

CC_NAME="basic"
CC_SRC_PATH="../contract/fabcar-clone"
CC_RUNTIME_LANGUAGE="golang"
CC_VERSION="1"
CHANNEL_NAME="mychannel"

# 1. 패키징
infoln "Packaging Chaincode"
set -x
peer lifecycle chaincode package ${CC_NAME}.tar.gz \
    --path ${CC_SRC_PATH} \
    --lang ${CC_RUNTIME_LANGUAGE} \
    --label ${CC_NAME}_${CC_VERSION}
set +x

# 2. 설치
# 2.1 org1에 설치
infoln "Installing chaincode on peer0.org1.example.com"
setOrg1
set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz
{ set +x; } 2>/dev/null
# 2.2 org2에 설치
infoln "Installing chaincode on peer0.org2.example.com"
setOrg2
set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz
{ set +x; } 2>/dev/null

# 3. 승인
# 3.1 체인코드 ID 가져오기
set -x
peer lifecycle chaincode queryinstalled >&log.txt  
{ set +x; } 2>/dev/null
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

# 3.2 org1로 부터 승인
infoln "approve the definition on peer0.org1.example.com"

ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

setOrg1

set -x
peer lifecycle chaincode approveformyorg \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls \
    --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${PACKAGE_ID} \
    --sequence 1

{ set +x; } 2>/dev/null

sleep 3

# 3.3 org2로 부터 승인
info "approve the definition on peer0.org2.example.com"

setOrg2

set -x
peer lifecycle chaincode approveformyorg \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls \
    --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${PACKAGE_ID} \
    --sequence 1

{ set +x; } 2>/dev/null

# 4. commit 
infoln "commit the chaincode definition"

# 4.1 각 피어에 연결시 사용하는 연결정보
PEER_CONN_PARMS="--peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"


# 4.2 commit
set -x
peer lifecycle chaincode commit \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls \
    --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name ${CC_NAME} $PEER_CONN_PARMS \
    --version ${CC_VERSION} \
    --sequence 1

{ set +x; } 2>/dev/null

sleep 3

# 5. 테스트
# 5.1 invoke - createcar
infoln "TEST1 : Invoking the chaincode"
set -x
peer chaincode invoke \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n $CC_NAME \
    $PEER_CONN_PARMS \
    -c '{"function":"CreateCar","Args",["CAR0","BMW","Z4","WHITE","BSTUDENT"]}'
{ set +x; } 2>/dev/null

sleep 3

# 5.2 query - querycar
infoln "TEST2 : Query the chaincode"
set -x
peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Args":["QueryCar","CAR0"]}'
{ set +x; } 2>/dev/null
