peer node start

export CORE_PEER_MSPCONFIGPATH=../network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

peer channel join -b ../network/configtx/channel-artifacts/kanal-fabric.block

scripts/deployCC.sh kanal-fabric basic