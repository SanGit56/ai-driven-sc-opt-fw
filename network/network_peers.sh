# source environment variables
source ./setOrgEnv.sh Org1 2

# create channel
peer channel create -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal_fabric -f ../network/configtx/channel-artifacts/kanal_fabric.tx --outputBlock ../network/configtx/channel-artifacts/kanal_fabric.block --tls --cafile ../network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

# join channel
peer channel join -b ../network/configtx/channel-artifacts/kanal_fabric.block

# update peers
peer channel update -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal_fabric -f ../network/configtx/channel-artifacts/Org1MSPanchors.tx --tls --cafile ../network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt