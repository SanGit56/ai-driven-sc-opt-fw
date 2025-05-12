#!/usr/bin/env bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
TEST_NETWORK_HOME=${TEST_NETWORK_HOME:-${PWD}}
. ${TEST_NETWORK_HOME}/scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${TEST_NETWORK_HOME}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

export PEER_ORG1_CA=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER1_ORG1_CA=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export PEER2_ORG1_CA=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt

# Set environment variables for peerN.org1
setGlobals() {
  local PEER=$1
  local ORG=$2

  if [ -z "$ORG" ]; then
    ORG=1
  fi

  infoln "Using Org${ORG} Peer${PEER}"

  if [ "$ORG" -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_MSPCONFIGPATH=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

    # adjust hostname
    if [ "$PEER" -eq 0 ]; then
      export CORE_PEER_ADDRESS=localhost:7051
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    elif [ "$PEER" -eq 1 ]; then
      export CORE_PEER_ADDRESS=localhost:8051
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
    elif [ "$PEER" -eq 2 ]; then
      export CORE_PEER_ADDRESS=localhost:9051
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER2_ORG1_CA
    else
      errorln "Peer${PEER} in Org1 not recognized"
    fi
  else
    errorln "Organization ${ORG} not recognized"
  fi

  if [ "$VERBOSE" = "true" ]; then
    env | grep CORE
  fi
}

# Helper function to build peer connection parameters
# Usage: parsePeerConnectionParameters peerID1 orgID1 peerID2 orgID2 ...
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 1 ]; do
    PEER=$1
    ORG=$2
    setGlobals $PEER $ORG
    PEER_LABEL="peer${PEER}.org${ORG}"

    if [ -z "$PEERS" ]; then
      PEERS="$PEER_LABEL"
    else
      PEERS="$PEERS $PEER_LABEL"
    fi

    PEER_CONN_PARMS+=("--peerAddresses" "$CORE_PEER_ADDRESS")

    CA=PEER${PEER}_ORG${ORG}_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS+=("${TLSINFO[@]}")

    shift 2
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
