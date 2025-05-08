# simpul orderer (v)
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# simpul peer (v)
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"

# blok genesis (v)
configtxgen -profile ChannelUsingRaft -outputBlock ./channel-artifacts/kanal_fabric.block -channelID kanal_fabric

# orderer buat saluran (v)
configtxgen -profile ChannelUsingRaft -outputCreateChannelTx ./channel-artifacts/kanal_fabric.tx -channelID kanal_fabric

# orderer gabung saluran
scripts/orderer.sh