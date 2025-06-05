sudo apt update

sudo apt install python3

python3 -m venv venv
source venv/bin/activate
pip install paramiko scp


1. read (check)/define blockchain worker (peer node) resource
2. read chaincode files/folders in local storage
3. packages the chaincodes
4. communicate with ai language models like chatgpt/gemini/deepseek
5. send the packaged chaincodes to peers

ping -c 3 10.125.174.252
ping -c 3 10.125.175.114
ping -c 3 10.125.171.70

ssh-copy-id -i ~/.ssh/id_rsa.pub worker1@10.125.174.252
ssh-copy-id -i ~/.ssh/id_rsa.pub worker2@10.125.175.114
ssh-copy-id -i ~/.ssh/id_rsa.pub worker3@10.125.171.70