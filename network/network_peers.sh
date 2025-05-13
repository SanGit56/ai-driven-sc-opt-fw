export PATH="$PATH:$(pwd)/bin"
source ./network/setOrgEnv.sh Org1 2
cd config

# create config block
peer channel create -o 10.125.168.232:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f ../network/configtx/channel-artifacts/kanal-fabric.tx --outputBlock ../network/configtx/channel-artifacts/kanal-fabric.block --tls --cafile ../network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

# join channel
peer channel join -b ../network/configtx/channel-artifacts/kanal-fabric.block

# update peers
peer channel update -o 10.125.168.232:7050 --ordererTLSHostnameOverride 10.125.168.232 -c kanal-fabric -f ../network/configtx/channel-artifacts/Org1MSPanchors.tx --tls --cafile ../network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt