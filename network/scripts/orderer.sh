#!/usr/bin/env bash

NETWORK_DIR=${NETWORK_DIR:-${PWD}}
export ORDERER_CA=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
CHANNEL_NAME=$1

if [ -z "$CHANNEL_NAME" ]; then
  echo "Error: CHANNEL_NAME not provided to orderer.sh"
  exit 1
fi

export PATH=${ROOTDIR}/../bin:${PWD}/../bin:$PATH
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

if [ -z "$ORDERER_CA" ]; then
  echo "Error: ORDERER_CA is not set in environment"
  exit 1
fi

osnadmin channel join --channelID "$CHANNEL_NAME" --config-block ./configtx/channel-artifacts/${CHANNEL_NAME}.block -o 10.125.168.232:7050 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"