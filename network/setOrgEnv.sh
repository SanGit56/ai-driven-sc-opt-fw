#!/usr/bin/env bash

ORG=${1:-Org1}
PEER=${2:-0}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ORDERER_CA="${DIR}/network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
PEER0_ORG1_CA="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"
PEER1_ORG1_CA="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt"
PEER2_ORG1_CA="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt"

ORG_LOWER=$(echo "$ORG" | tr '[:upper:]' '[:lower:]')

if [[ "$ORG_LOWER" == "org1" || "$ORG_LOWER" == "digibank" ]]; then

  export CORE_PEER_LOCALMSPID="Org1MSP"
  export PEER_TLS_CLIENT_ROOTCAs_FILE="${DIR}/network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/ca.crt"
  export PEER_TLS_CLIENT_KEY_FILE="${DIR}/network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/client.key"
  export PEER_TLS_CLIENT_CERT_FILE="${DIR}/network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/client.crt"

  case "$PEER" in
    0)
      export PEER_ID=peer0.org1.example.com
      export CORE_PEER_ADDRESS="10.125.169.93:7051"
      export PEER_GOSSIP_BOOTSTRAP=10.125.169.12:8051
      export CORE_PEER_MSPCONFIGPATH="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/msp"
      export PEER_TLS_CERT_FILE="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/tls/server.crt"
      export PEER_TLS_KEY_FILE=="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/tls/server.key"
      export CORE_PEER_TLS_ROOTCERT_FILE="$PEER0_ORG1_CA"
      ;;
    1)
      export PEER_ID=peer1.org1.example.com
      export CORE_PEER_ADDRESS="10.125.169.12:8051"
      export PEER_GOSSIP_BOOTSTRAP=10.125.169.6:9051
      export CORE_PEER_MSPCONFIGPATH="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/msp"
      export PEER_TLS_CERT_FILE="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/tls/server.crt"
      export PEER_TLS_KEY_FILE=="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/tls/server.key"
      export CORE_PEER_TLS_ROOTCERT_FILE="$PEER1_ORG1_CA"
      ;;
    2)
      export PEER_ID=peer2.org1.example.com
      export CORE_PEER_ADDRESS="10.125.169.6:9051"
      export PEER_GOSSIP_BOOTSTRAP=10.125.169.93:7051
      export CORE_PEER_MSPCONFIGPATH="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/msp"
      export PEER_TLS_CERT_FILE="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/tls/server.crt"
      export PEER_TLS_KEY_FILE=="${DIR}/network/organizations/peerOrganizations/org1.example.com/peers/$PEER_ID/tls/server.key"
      export CORE_PEER_TLS_ROOTCERT_FILE="$PEER2_ORG1_CA"
      ;;
    *)
      echo "Error: Peer${PEER} in Org1 is not recognized."
      return 1
      ;;
  esac
else
  echo "Unknown organization \"$ORG\"."
  echo "Please choose from: Org1, Digibank"
  echo "Usage: source ./setOrgEnv.sh Org1 0"
  return 1
fi

# Common exports
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA
export PEER0_ORG1_CA
export PEER1_ORG1_CA
export PEER2_ORG1_CA