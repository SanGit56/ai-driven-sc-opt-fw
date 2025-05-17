export PATH="$PATH:$(pwd)/bin"

# generate orderer identity
cryptogen generate --config=~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/organizations/cryptogen/crypto-config-orderer.yaml --output="~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/organizations"

# generate organization/peer identity
cryptogen generate --config=~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/organizations/cryptogen/crypto-config-org1.yaml --output="~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/organizations"

export FABRIC_CFG_PATH="$PWD/config"

# generate genesis block
configtxgen -profile SampleDevModeEtcdRaft -outputBlock ~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/config/system-genesis-block/genesis.block -channelID system-channel

export FABRIC_CFG_PATH="$PWD/network/configtx"

# generate app genesis/config block
configtxgen -profile ChannelUsingRaft -outputBlock ~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/configtx/channel-artifacts/kanal-fabric.block -channelID kanal-fabric

# generate channel
configtxgen -profile ChannelUsingRaft -outputCreateChannelTx ~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/configtx/channel-artifacts/kanal-fabric.tx -channelID kanal-fabric

# update anchor peer transaction
configtxgen -profile ChannelUsingRaft -outputAnchorPeersUpdate ~/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/configtx/channel-artifacts/Org1MSPanchors.tx -channelID kanal-fabric -asOrg Org1

cd config

# run orderer
orderer

cd ../network

# orderer script (setelah create config block)
scripts/orderer.sh