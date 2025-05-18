#!/usr/bin/env bash

NETWORK_DIR=${NETWORK_DIR:-${PWD}}
export ORDERER_CA=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

export ORDERER_ADMIN_TLS_SIGN_CERT=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/client.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/client.key

if [ -z "$ORDERER_CA" ]; then
  echo "Error: ORDERER_CA is not set in environment"
  exit 1
fi

osnadmin channel join --channelID kanal-fabric --config-block ./configtx/channel-artifacts/kanal-fabric.block -o orderer.example.com:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"