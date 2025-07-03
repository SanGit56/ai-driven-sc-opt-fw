#!/usr/bin/env bash

ORG=${1:-Org1}
PEER=${2:-0}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export ORDERER_CA="${DIR}/network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem"
export PEER_ORG1_CA="${DIR}/network/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem"

ORG_LOWER=$(echo "$ORG" | tr '[:upper:]' '[:lower:]')

if [[ "$ORG_LOWER" == "org1" || "$ORG_LOWER" == "digibank" ]]; then

  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_MSPCONFIGPATH="${DIR}/network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
  export CORE_PEER_TLS_ROOTCERT_FILE="$PEER_ORG1_CA"

  case "$PEER" in
    0)
      export CORE_PEER_ADDRESS="10.125.178.58:7051"
      ;;
    1)
      export CORE_PEER_ADDRESS="10.125.176.96:8051"
      ;;
    2)
      export CORE_PEER_ADDRESS="10.125.178.62:9051"
      ;;
    *)
      echo "Error: Peer${PEER} in Org1 is not recognized."
      return 1
      ;;
  esac
else
  echo "Unknown organization \"$ORG\"."
  echo "Please choose from: Org1, Digibank"
  echo "Usage: source ./setOrgEnv.sh Org1 2"
  return 1
fi

# Common exports
export CORE_PEER_TLS_ENABLED=true
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER_ORG1_CA=${PEER_ORG1_CA}"
echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"