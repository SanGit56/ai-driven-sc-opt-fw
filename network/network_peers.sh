# simpul peer
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"

# peer buat saluran
peer channel create -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal_fabric -f ./channel-artifacts/kanal_fabric.tx --outputBlock ./channel-artifacts/kanal_fabric.block --tls --cafile /path/to/orderer/ca.crt

# peer gabung saluran
peer channel join -b ./channel-artifacts/kanal_fabric.block

# buat anchor peer
peer channel update -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal_fabric -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /path/to/orderer/ca.crt