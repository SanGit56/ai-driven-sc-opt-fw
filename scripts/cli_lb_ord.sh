#!/usr/bin/env bash

export PATH=$PATH:../bin
export FABRIC_CFG_PATH=../config
export ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
export ORDERER_GENERAL_LISTENPORT=7050
export ORDERER_GENERAL_LOCALMSPID=OrdererMSP
export ORDERER_GENERAL_LOCALMSPDIR=/home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/ordererOrganizations/example.com/orderers/orderer.example.com/msp

orderer


# channel_name=$1

# export PATH=${ROOTDIR}/../bin:${PWD}/../bin:$PATH
# export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt /dev/null 2>&1
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key /dev/null 2>&1

# osnadmin channel join --channelID ${channel_name} --config-block ./channel-artifacts/${channel_name}.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >> log.txt 2>&1