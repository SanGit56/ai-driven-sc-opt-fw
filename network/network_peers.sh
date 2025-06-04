export PATH="$PATH:$(pwd)/../bin"
peer node start
export CORE_PEER_MSPCONFIGPATH=../network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

# join channel
peer channel join -b ../network/configtx/channel-artifacts/kanal-fabric.block

# install chaincode on peer
scripts/deployCC.sh kanal-fabric basic