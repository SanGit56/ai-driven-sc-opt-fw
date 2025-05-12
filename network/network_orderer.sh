cd bin
export PATH=$PATH:$(pwd)
cd ../network/

# generate orderer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# generate organization/peer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"

cd configtx

# generate genesis block
configtxgen -profile ChannelUsingRaft -outputBlock ./channel-artifacts/kanal_fabric.block -channelID kanal_fabric

# generate channel
configtxgen -profile ChannelUsingRaft -outputCreateChannelTx ./channel-artifacts/kanal_fabric.tx -channelID kanal_fabric

# update anchor peer transaction
configtxgen -profile ChannelUsingRaft -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID kanal_fabric -asOrg Org1MSP

# run orderer
orderer

# orderer script
scripts/orderer.sh kanal_fabric