#!/usr/bin/env bash

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

# -> Change 0.0.0.0 to actual hostname or IP used by orderer inside the network
osnadmin channel join --channelID "$CHANNEL_NAME" --config-block ./channel-artifacts/${CHANNEL_NAME}.block -o 0.0.0.0:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"