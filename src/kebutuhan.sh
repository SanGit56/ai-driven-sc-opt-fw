sudo apt update

# python
sudo apt install python3
sudo apt install python3.10-venv -y

# ssh
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh

# python environment
python3 -m venv venv
source venv/bin/activate
pip install paramiko scp


2. read chaincode files/folders in local storage
3. packages the chaincodes
4. communicate with ai language models like chatgpt/gemini/deepseek
5. send the packaged chaincodes to peers