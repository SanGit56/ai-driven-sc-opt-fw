#!/usr/bin/env bash

export FABRIC_CFG_PATH=$PWD/../config/

CC_NAME=$1
CC_SRC_PATH=$2
CC_SRC_LANGUAGE=$3
CC_VERSION=$4
CC_SEQUENCE=$5
INIT_REQUIRED="--init-required"
CHANNEL_NAME=kanal_fabric

ORDERER_CA=$PWD/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

installChaincode() {
  for PEER in 0 1 2; do
    setGlobals $PEER
    set -x
    peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    cat log.txt
    verifyResult $res "Chaincode installation on peer${PEER}.org1 has failed"
    successln "Chaincode installed on peer${PEER}.org1"
  done
}

queryInstalled() {
  for PEER in 0 1 2; do
    setGlobals $PEER
    set -x
    peer lifecycle chaincode queryinstalled >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    cat log.txt
    verifyResult $res "Query installed on peer${PEER}.org1 has failed"
    successln "Query installed successful on peer${PEER}.org1"
  done
}

approveForMyOrg() {
  setGlobals 0
  set -x
  peer lifecycle chaincode approveformyorg -o 10.125.168.232:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
  verifyResult $res "Chaincode definition approval failed on peer0.org1"
  successln "Chaincode definition approved on peer0.org1"
}

commitChaincodeDefinition() {
  parsePeerConnectionParameters 0 1 1 1 2 1
  res=$?
  verifyResult $res "Parsing peer connection parameters failed"
  set -x
  peer lifecycle chaincode commit -o 10.125.168.232:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} $PEER_CONN_PARMS --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
  verifyResult $res "Chaincode definition commit failed"
  successln "Chaincode definition committed on channel '$CHANNEL_NAME'"
}

chaincodeInvokeInit() {
  parsePeerConnectionParameters 0 1 1 1 2 1
  res=$?
  verifyResult $res "Parsing peer connection parameters failed"
  set -x
  peer chaincode invoke -o 10.125.168.232:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS --isInit -c '{"Args":[]}' >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
  verifyResult $res "Chaincode initialization failed"
  successln "Chaincode initialized successfully"
}

chaincodeQuery() {
  for PEER in 0 1 2; do
    setGlobals $PEER
    set -x
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAll"]}' >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    cat log.txt
    verifyResult $res "Chaincode query failed on peer${PEER}.org1"
    successln "Chaincode query successful on peer${PEER}.org1"
  done
}

# checkCommitReadiness VERSION PEER ORG
function checkCommitReadiness() {
  ORG=$1
  shift 1
  setGlobals $ORG
  infoln "Checking the commit readiness of the chaincode definition on peer0.org${ORG} on channel '$CHANNEL_NAME'..."
  local rc=1
  local COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    sleep $DELAY
    infoln "Attempting to check the commit readiness of the chaincode definition on peer0.org${ORG}, Retry after $DELAY seconds."
    set -x
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} --output json >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    let rc=0
    for var in "$@"; do
      grep "$var" log.txt &>/dev/null || let rc=1
    done
    COUNTER=$(expr $COUNTER + 1)
  done
  cat log.txt
  if test $rc -eq 0; then
    infoln "Checking the commit readiness of the chaincode definition successful on peer0.org${ORG} on channel '$CHANNEL_NAME'"
  else
    fatalln "After $MAX_RETRY attempts, Check commit readiness result on peer0.org${ORG} is INVALID!"
  fi
}

# queryCommitted ORG
function queryCommitted() {
  ORG=$1
  setGlobals $ORG
  EXPECTED_RESULT="Version: ${CC_VERSION}, Sequence: ${CC_SEQUENCE}, Endorsement Plugin: escc, Validation Plugin: vscc"
  infoln "Querying chaincode definition on peer0.org${ORG} on channel '$CHANNEL_NAME'..."
  local rc=1
  local COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    sleep $DELAY
    infoln "Attempting to Query committed status on peer0.org${ORG}, Retry after $DELAY seconds."
    set -x
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    test $res -eq 0 && VALUE=$(cat log.txt | grep -o '^Version: '$CC_VERSION', Sequence: [0-9]*, Endorsement Plugin: escc, Validation Plugin: vscc')
    test "$VALUE" = "$EXPECTED_RESULT" && let rc=0
    COUNTER=$(expr $COUNTER + 1)
  done
  cat log.txt
  if test $rc -eq 0; then
    successln "Query chaincode definition successful on peer0.org${ORG} on channel '$CHANNEL_NAME'"
  else
    fatalln "After $MAX_RETRY attempts, Query chaincode definition result on peer0.org${ORG} is INVALID!"
  fi
}

function resolveSequence() {
  if [[ "${CC_SEQUENCE}" != "auto" ]]; then
    return 0
  fi

  local rc=1
  local COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    set -x
    COMMITTED_CC_SEQUENCE=$(peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} | sed -n "/Version:/{s/.*Sequence: //; s/, Endorsement Plugin:.*$//; p;}")
    res=$?
    { set +x; } 2>/dev/null
    let rc=$res
    COUNTER=$(expr $COUNTER + 1)
  done

  if [ -z $COMMITTED_CC_SEQUENCE ]; then
    CC_SEQUENCE=1
    return 0
  fi

  rc=1
  COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    set -x
    APPROVED_CC_SEQUENCE=$(peer lifecycle chaincode queryapproved --channelID $CHANNEL_NAME --name ${CC_NAME} | sed -n "/sequence:/{s/^sequence: //; s/, version:.*$//; p;}")
    res=$?
    { set +x; } 2>/dev/null
    let rc=$res
    COUNTER=$(expr $COUNTER + 1)
  done

  if [ $COMMITTED_CC_SEQUENCE == $APPROVED_CC_SEQUENCE ]; then
    CC_SEQUENCE=$((COMMITTED_CC_SEQUENCE+1))
  else
    CC_SEQUENCE=$APPROVED_CC_SEQUENCE
  fi

}

queryInstalledOnPeer() {

  local rc=1
  local COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    peer lifecycle chaincode queryinstalled >&log.txt
    res=$?
    let rc=$res
    COUNTER=$(expr $COUNTER + 1)
  done
  cat log.txt
}

queryCommittedOnChannel() {
  CHANNEL=$1
  local rc=1
  local COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    peer lifecycle chaincode querycommitted -C $CHANNEL >&log.txt
    res=$?
    let rc=$res
    COUNTER=$(expr $COUNTER + 1)
  done
  cat log.txt
  if test $rc -ne 0; then
    fatalln "After $MAX_RETRY attempts, Failed to retrieve committed chaincode!"
  fi

}

listAllCommitted() {

  local rc=1
  local COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    CHANNEL_LIST=$(peer channel list | sed '1,1d')
    res=$?
    let rc=$res
    COUNTER=$(expr $COUNTER + 1)
  done
  if test $rc -eq 0; then
    for channel in $CHANNEL_LIST
    do
      queryCommittedOnChannel "$channel"
    done
  else
    fatalln "After $MAX_RETRY attempts, Failed to retrieve committed chaincode!"
  fi

}

chaincodeInvoke() {
  ORG=$1
  CHANNEL=$2
  CC_NAME=$3
  CC_INVOKE_CONSTRUCTOR=$4
  
  infoln "Invoking on peer0.org${ORG} on channel '$CHANNEL_NAME'..."
  local rc=1
  local COUNTER=1
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
    sleep $DELAY
    infoln "Attempting to Invoke on peer0.org${ORG}, Retry after $DELAY seconds."
    set -x
    peer chaincode invoke -o 10.125.168.232:7050 -C $CHANNEL_NAME -n ${CC_NAME} -c ${CC_INVOKE_CONSTRUCTOR} --tls --cafile $ORDERER_CA  --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA  >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    let rc=$res
    COUNTER=$(expr $COUNTER + 1)
  done
  cat log.txt
  if test $rc -eq 0; then
    successln "Invoke successful on peer0.org${ORG} on channel '$CHANNEL_NAME'"
  else
    fatalln "After $MAX_RETRY attempts, Invoke result on peer0.org${ORG} is INVALID!"
  fi
}