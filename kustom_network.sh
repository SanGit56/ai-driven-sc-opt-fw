#!/bin/bash

# Manual Hyperledger Fabric network script (no Docker)
# Customize the paths and IPs based on your actual setup

# Configurable variables
CHANNEL_NAME="mychannel"
ORDERER_CA="/path/to/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
ORDERER_ADDRESS="orderer.example.com:7050"
GENESIS_BLOCK_PATH="/path/to/genesis.block"
CHANNEL_TX_PATH="/path/to/${CHANNEL_NAME}.tx"

# Peer configuration
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE="/path/to/org1/peers/peer0.org1.example.com/tls/ca.crt"
export CORE_PEER_MSPCONFIGPATH="/path/to/org1/users/Admin@org1.example.com/msp"
export CORE_PEER_ADDRESS="peer0.org1.example.com:7051"

function createChannel() {
    echo "Creating channel $CHANNEL_NAME..."
    peer channel create -o "$ORDERER_ADDRESS" \
        -c "$CHANNEL_NAME" \
        --ordererTLSHostnameOverride orderer.example.com \
        -f "$CHANNEL_TX_PATH" \
        --outputBlock "./${CHANNEL_NAME}.block" \
        --tls --cafile "$ORDERER_CA"
}

function joinChannel() {
    echo "Joining peer to channel $CHANNEL_NAME..."
    peer channel join -b "./${CHANNEL_NAME}.block"
}

function updateAnchorPeer() {
    echo "Updating anchor peer..."
    peer channel update -o "$ORDERER_ADDRESS" \
        --ordererTLSHostnameOverride orderer.example.com \
        -c "$CHANNEL_NAME" \
        -f "./Org1MSPanchors.tx" \
        --tls --cafile "$ORDERER_CA"
}

function usage() {
    echo "Usage: ./network.sh up|down|createChannel|joinChannel|updateAnchorPeer"
    echo
    echo "up/down not implemented because this is for manual VM deployment."
}

case "$1" in
    createChannel)
        createChannel
        ;;
    joinChannel)
        joinChannel
        ;;
    updateAnchorPeer)
        updateAnchorPeer
        ;;
    up|down)
        echo "Manual deployment – start/stop your orderers and peers manually or via systemd"
        ;;
    *)
        usage
        ;;
esac
