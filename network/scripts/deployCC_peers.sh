#!/usr/bin/env bash

source scripts/utils.sh

CHANNEL_NAME=${1:-"kanal-fabric"}
CC_NAME=${2}

println "executing with the following"
println "- CHANNEL_NAME: ${C_GREEN}${CHANNEL_NAME}${C_RESET}"
println "- CC_NAME: ${C_GREEN}${CC_NAME}${C_RESET}"

export FABRIC_CFG_PATH=$PWD/../config/

. scripts/envVar.sh
. scripts/ccutils.sh

function checkPrereqs() {
  jq --version > /dev/null 2>&1

  if [[ $? -ne 0 ]]; then
    errorln "jq command not found..."
    errorln
    errorln "Follow the instructions in the Fabric docs to install the prereqs"
    errorln "https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html"
    exit 1
  fi
}

checkPrereqs

PACKAGE_ID=$(peer lifecycle chaincode calculatepackageid ${CC_NAME}.tar.gz)

infoln "Installing chaincode on peer.org1..."
installChaincode 1

# resolveSequence

# queryInstalled 1

# approveForMyOrg 1

# checkCommitReadiness 1 "\"Org1MSP\": true"

# commitChaincodeDefinition 1

# queryCommitted 1

# if [ "$CC_INIT_FCN" = "NA" ]; then
#   infoln "Chaincode initialization is not required"
# else
#   chaincodeInvokeInit 1
# fi

exit 0
