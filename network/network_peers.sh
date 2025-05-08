# peer buat saluran
peer channel create -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal_fabric -f ../network/configtx/channel-artifacts/kanal_fabric.tx --outputBlock ../network/configtx/channel-artifacts/kanal_fabric.block --tls --cafile ../network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

# peer gabung saluran
peer channel join -b ../network/configtx/channel-artifacts/kanal_fabric.block

# buat anchor peer
peer channel update -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal_fabric -f ../network/configtx/channel-artifacts/Org1MSPanchors.tx --tls --cafile ../network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt