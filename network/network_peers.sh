export PATH="$PATH:$(pwd)/../bin"
peer node start

# join channel
peer channel join -b ../network/configtx/channel-artifacts/kanal-fabric.block


# update peers
peer channel update -o 10.125.169.102:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f ../network/configtx/channel-artifacts/Org1MSPanchors.tx --tls --cafile ../network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem



# create config block
# peer channel create -o 10.125.169.102:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f ../network/configtx/channel-artifacts/kanal-fabric.tx --outputBlock ../network/configtx/channel-artifacts/kanal-fabric.block --tls --cafile ../network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem