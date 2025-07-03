#!/usr/bin/env bash

NETWORK_DIR=${NETWORK_DIR:-${PWD}}
. ${NETWORK_DIR}/scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER_ORG1_CA=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

setGlobals() {
  local ORG=$1
  local PEER=$2

  if [ -z "$ORG" ]; then
    ORG=1
  fi

  infoln "Using Org${ORG} Peer${PEER}"

  if [ "$ORG" -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

    echo $CORE_PEER_LOCALMSPID
    echo $CORE_PEER_TLS_ROOTCERT_FILE
    echo $CORE_PEER_MSPCONFIGPATH

    if [ "$PEER" -eq 0 ]; then
      export CORE_PEER_ADDRESS=10.125.178.58:7051
      echo $CORE_PEER_ADDRESS
    elif [ "$PEER" -eq 1 ]; then
      export CORE_PEER_ADDRESS=10.125.176.96:8051
      echo $CORE_PEER_ADDRESS
    elif [ "$PEER" -eq 2 ]; then
      export CORE_PEER_ADDRESS=10.125.178.62:9051
      echo $CORE_PEER_ADDRESS
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
