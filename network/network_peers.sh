export PATH="$PATH:$(pwd)/bin"
source ./network/setOrgEnv.sh Org1 2
cd config

# create config block
peer channel create -o 10.125.169.102:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f /home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/configtx/channel-artifacts/kanal-fabric.tx --outputBlock /home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/configtx/channel-artifacts/kanal-fabric.block --tls --cafile /home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem

# join channel
peer channel join -b /home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/configtx/channel-artifacts/kanal-fabric.block

# update peers
peer channel update -o 10.125.169.102:7050 --ordererTLSHostnameOverride orderer.example.com -c kanal-fabric -f /home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/configtx/channel-artifacts/Org1MSPanchors.tx --tls --cafile /home/loadbalancer/go/src/github.com/SanGit56/ai-driven-sc-opt-fw/network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem