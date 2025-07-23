# kebutuhan sistem
sudo apt update

sudo apt install net-tools

sudo add-apt-repository ppa:gnome-terminator
sudo apt-get update
sudo apt-get -y install terminator


# prasyarat fabric
sudo apt-get install git
git --version

sudo apt-get install curl

sudo apt-get -y install docker-compose
docker --version
docker-compose --version
sudo systemctl start docker
sudo usermod -a -G docker loadbalancer

wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz
rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

sudo apt-get -y install jq


# unduh file instalasi fabric
mkdir -p $HOME/go/src/github.com/SanGit56
cd $HOME/go/src/github.com/SanGit56

curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh
chmod +x install-fabric.sh
./install-fabric.sh docker samples binary

# alat untuk framework
sudo apt install python3
sudo apt install python3.10-venv -y

sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh

python3 -m venv venv
source venv/bin/activate
pip install paramiko scp