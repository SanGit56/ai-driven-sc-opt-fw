export PATH="$PATH:$(pwd)/../bin"

# generate orderer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="./organizations"

# generate organization/peer identity
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="./organizations"

export FABRIC_CFG_PATH="$PWD/configtx"

# generate app genesis/config block
configtxgen -profile ChannelUsingRaft -outputBlock ./configtx/channel-artifacts/kanal-fabric.block -channelID kanal-fabric

orderer

# join orderer to channel
scripts/orderer.sh

# package chaincode
scripts/packageCC.sh