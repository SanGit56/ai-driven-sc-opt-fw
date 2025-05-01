#!/usr/bin/env bash

export PATH=$PATH:../bin
export FABRIC_CFG_PATH=../config
export CORE_PEER_ID=peer2.org1.example.com
export CORE_PEER_ADDRESS=192.168.1.103:7051
export CORE_PEER_LISTENADDRESS=0.0.0.0:7051
export CORE_PEER_CHAINCODEADDRESS=192.168.1.103:7052
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=192.168.1.103:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=/home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp

peer node start