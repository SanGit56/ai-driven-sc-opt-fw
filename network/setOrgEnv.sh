#!/usr/bin/env bash

ORG=${1:-Org1}
PEER=${2:-0}

set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
PEER0_ORG1_CA=${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
PEER1_ORG1_CA=${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
PEER2_ORG1_CA=${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt

if [[ ${ORG,,} == "org1" || ${ORG,,} == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=Org1MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

   # adjust hostname
   if [ "$PEER" -eq 0 ]; then
      export CORE_PEER_ADDRESS=10.125.169.93:7051
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    elif [ "$PEER" -eq 1 ]; then
      export CORE_PEER_ADDRESS=10.125.169.12:8051
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
    elif [ "$PEER" -eq 2 ]; then
      export CORE_PEER_ADDRESS=10.125.169.6:9051
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER2_ORG1_CA
    else
      errorln "Peer${PEER} in Org1 not recognized"
    fi
else
   echo "Unknown \"$ORG\", please choose Org1/Digibank or Org2/Magnetocorp"
   echo "For example to get the environment variables to set upa Org2 shell environment run:  ./setOrgEnv.sh Org2"
   echo "This can be automated to set them as well with:"
   echo 'export $(./setOrgEnv.sh Org2 | xargs)'
   exit 1
fi

# output the variables that need to be set
export "CORE_PEER_TLS_ENABLED=true"
export "ORDERER_CA=${ORDERER_CA}"
export "PEER0_ORG1_CA=${PEER0_ORG1_CA}"
export "PEER1_ORG1_CA=${PEER1_ORG1_CA}"
export "PEER2_ORG1_CA=${PEER2_ORG1_CA}"

export "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
export "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
export "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

export "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
