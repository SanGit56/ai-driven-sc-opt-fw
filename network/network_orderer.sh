cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

configtxgen -profile ChannelUsingRaft -outputBlock ./channel-artifacts/kanal_fabric.block -channelID kanal_fabric

configtxgen -profile ChannelUsingRaft -outputCreateChannelTx ./channel-artifacts/kanal_fabric.tx -channelID kanal_fabric