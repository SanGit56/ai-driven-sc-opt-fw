#!/usr/bin/env bash

export FABRIC_CFG_PATH=../config
export CORE_PEER_ID=peer1.org1.example.com
export CORE_PEER_ADDRESS=10.125.168.247:7051
export CORE_PEER_LISTENADDRESS=0.0.0.0:7051
export CORE_PEER_CHAINCODEADDRESS=10.125.168.247:7052
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=10.125.168.247:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=../organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp

peer node start