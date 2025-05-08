# simpul orderer
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# blok genesis
configtxgen -profile ChannelUsingRaft -outputBlock ./channel-artifacts/kanal_fabric.block -channelID kanal_fabric

# orderer buat saluran
configtxgen -profile ChannelUsingRaft -outputCreateChannelTx ./channel-artifacts/kanal_fabric.tx -channelID kanal_fabric

# orderer gabung saluran
scripts/orderer.sh