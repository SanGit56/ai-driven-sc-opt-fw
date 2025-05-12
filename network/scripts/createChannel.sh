#!/usr/bin/env bash

. scripts/envVar.sh

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="kanal_fabric"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}

if [ ! -d "configtx/channel-artifacts" ]; then
	mkdir configtx/channel-artifacts
fi

createChannelGenesisBlock() {
  setGlobals 1
	which configtxgen
	if [ "$?" -ne 0 ]; then
		fatalln "configtxgen tool not found."
	fi
	set -x

	configtxgen -profile ChannelUsingRaft -outputBlock ./configtx/channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
	
	res=$?
	{ set +x; } 2>/dev/null
  verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
	local rc=1
	local COUNTER=1
	infoln "Adding orderers"
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
    . scripts/orderer.sh ${CHANNEL_NAME}> /dev/null 2>&1
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
  ORG=$1
  FABRIC_CFG_PATH=$PWD/../config/
  setGlobals $ORG
	local rc=1
	local COUNTER=1
	
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer0.org${ORG} has failed to join channel '$CHANNEL_NAME' "
}

setAnchorPeer() {
  ORG=$1
  . scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME
}

FABRIC_CFG_PATH=$PWD/../config/
BLOCKFILE="./configtx/channel-artifacts/${CHANNEL_NAME}.block"

infoln "Generating channel genesis block '${CHANNEL_NAME}.block'"
FABRIC_CFG_PATH=${PWD}/configtx
createChannelGenesisBlock

infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

infoln "Joining org1 peer to the channel..."
joinChannel 1

infoln "Setting anchor peer for org1..."
setAnchorPeer 1

successln "Channel '$CHANNEL_NAME' joined"
