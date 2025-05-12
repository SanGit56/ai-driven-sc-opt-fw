# source environment variables
source ./setOrgEnv.sh Org1 2

# create config block
peer channel create -o 10.125.168.232:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f ./configtx/channel-artifacts/kanal-fabric.tx --outputBlock ./configtx/channel-artifacts/kanal-fabric.block --tls --cafile ./organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

# join channel
peer channel join -b ./configtx/channel-artifacts/kanal-fabric.block

# update peers
peer channel update -o 10.125.168.232:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f ./configtx/channel-artifacts/Org1MSPanchors.tx --tls --cafile ./organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt