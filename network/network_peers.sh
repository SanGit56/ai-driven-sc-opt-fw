export PATH="$PATH:$(pwd)/../bin"
peer node start

export CORE_PEER_MSPCONFIGPATH=../network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
# join channel
peer channel join -b ../network/configtx/channel-artifacts/kanal-fabric.block


# update peers
peer channel update -o 10.125.169.102:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f ../network/configtx/channel-artifacts/Org1MSPanchors.tx --tls --cafile ../network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem



# create config block
# peer channel create -o 10.125.169.102:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f ../network/configtx/channel-artifacts/kanal-fabric.tx --outputBlock ../network/configtx/channel-artifacts/kanal-fabric.block --tls --cafile ../network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem