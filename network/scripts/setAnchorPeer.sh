#!/usr/bin/env bash

# Load helper scripts
TEST_NETWORK_HOME=${TEST_NETWORK_HOME:-${PWD}}
. ${TEST_NETWORK_HOME}/scripts/configUpdate.sh

createAnchorPeerUpdate() {
  infoln "Fetching channel config for channel $CHANNEL_NAME"
  fetchChannelConfig $ORG $CHANNEL_NAME ${TEST_NETWORK_HOME}/channel-artifacts/${CORE_PEER_LOCALMSPID}config.json

  infoln "Generating anchor peer update transaction for Org${ORG} on channel $CHANNEL_NAME"

  if [ "$ORG" -eq 1 ]; then
    HOST="peer2.org1.example.com"
    PORT=9051
  else
    errorln "Org${ORG} is not supported by this script. Please extend it to support more orgs."
    exit 1
  fi

  set -x
  jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {
    "AnchorPeers": {
      "mod_policy": "Admins",
      "value": {
        "anchor_peers": [{"host": "'$HOST'", "port": '$PORT'}]
      },
      "version": "0"
    }
  }' ${TEST_NETWORK_HOME}/channel-artifacts/${CORE_PEER_LOCALMSPID}config.json \
  > ${TEST_NETWORK_HOME}/channel-artifacts/${CORE_PEER_LOCALMSPID}modified_config.json
  res=$?
  { set +x; } 2>/dev/null
  verifyResult $res "Failed to modify channel config with anchor peer"

  createConfigUpdate ${CHANNEL_NAME} \
    ${TEST_NETWORK_HOME}/channel-artifacts/${CORE_PEER_LOCALMSPID}config.json \
    ${TEST_NETWORK_HOME}/channel-artifacts/${CORE_PEER_LOCALMSPID}modified_config.json \
    ${TEST_NETWORK_HOME}/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx
}

updateAnchorPeer() {
  peer channel update \
    -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c $CHANNEL_NAME \
    -f ${TEST_NETWORK_HOME}/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx \
    --tls \
    --cafile "$ORDERER_CA" >&log.txt

  res=$?
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  successln "Anchor peer set for org '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME'"
}

# Parse args
ORG=$1
CHANNEL_NAME=$2

# Load peer environment for the org
setGlobals $ORG

# Run anchor update
createAnchorPeerUpdate
updateAnchorPeer
