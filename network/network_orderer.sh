cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="./organizations"

cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="./organizations"

export FABRIC_CFG_PATH="$PWD/configtx"

configtxgen -profile ChannelUsingRaft -outputBlock ./configtx/channel-artifacts/kanal-fabric.block -channelID kanal-fabric

orderer

scripts/orderer.sh

scripts/packageCC.sh