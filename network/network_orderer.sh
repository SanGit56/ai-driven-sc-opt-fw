export PATH="$PATH:$(pwd)/../bin"

# generate orderer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# generate organization/peer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"

cd ../config
export FABRIC_CFG_PATH=$PWD

# generate genesis block
configtxgen -profile SampleDevModeEtcdRaft -outputBlock ./system-genesis-block/genesis.block -channelID system-channel

cd ../network/configtx
export FABRIC_CFG_PATH=$PWD

# generate app genesis/config block
configtxgen -profile ChannelUsingRaft -outputBlock ./channel-artifacts/kanal-fabric.block -channelID kanal-fabric

# generate channel
configtxgen -profile ChannelUsingRaft -outputCreateChannelTx ./channel-artifacts/kanal-fabric.tx -channelID kanal-fabric

# update anchor peer transaction
configtxgen -profile ChannelUsingRaft -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID kanal-fabric -asOrg Org1MSP

cd ../../config/

# run orderer
orderer

cd ../network

# orderer script (setelah create config block)
scripts/orderer.sh kanal-fabric