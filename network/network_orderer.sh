export PATH="$PATH:$(pwd)/../bin"

# generate orderer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="./organizations"

# generate organization/peer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="./organizations"

export FABRIC_CFG_PATH="$PWD/configtx"

# generate app genesis/config block
configtxgen -profile ChannelUsingRaft -outputBlock ./configtx/channel-artifacts/kanal-fabric.block -channelID kanal-fabric

orderer

# orderer script (setelah create config block)
scripts/orderer.sh


# update anchor peer transaction
configtxgen -profile ChannelUsingRaft -outputAnchorPeersUpdate /configtx/channel-artifacts/Org1MSPanchors.tx -channelID kanal-fabric -asOrg Org1



# generate genesis block
# configtxgen -profile SampleDevModeEtcdRaft -outputBlock ./config/system-genesis-block/genesis.block -channelID system-channel

# generate channel
# configtxgen -profile ChannelUsingRaft -outputCreateChannelTx ./configtx/channel-artifacts/kanal-fabric.tx -channelID kanal-fabric