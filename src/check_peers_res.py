# [
#   {
#     "name": "peer0",
#     "host": "10.125.170.255",
#     "user": "worker1",
#     "port": 22,
#     "ssh_key": "/path/to/private/key"
#   },
#   {
#     "name": "peer1",
#     "host": "10.125.171.43",
#     "user": "worker2",
#     "port": 22,
#     "ssh_key": "/path/to/private/key"
#   }
# ]

import yaml
import paramiko

def baca_peers(config_file_path):
  with open(config_file_path, 'r') as f:
    data = yaml.safe_load(f)

  ip_list = []
  for org in data.get('PeerOrgs', []):
    if 'Template' in org and 'SANS' in org['Template']:
      for entry in org['Template']['SANS']:
        if isinstance(entry, str) and entry.startswith("10.125."):
          ip_list.append(entry)
  return ip_list

def get_sumber_daya(peer):
  ssh = paramiko.SSHClient()
  ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
  
  ssh.connect(
    hostname=peer["host"],
    port=peer.get("port", 22),
    username=peer["user"],
    key_filename=peer["ssh_key"]
  )
  
  perintah = {
    "cpu": "lscpu | grep 'CPU(s)'",
    "memory": "free -m",
    "disk": "df -h /"
  }

  hasil = {}
  for label, prt in perintah.items():
    stdin, stdout, stderr = ssh.exec_command(prt)
    output = stdout.read().decode()
    hasil[label] = output.strip()

  ssh.close()
  return hasil

if __name__ == "__main__":
  peers = baca_peers()
  for peer in peers:
    print(f"Cek sumber daya {peer['name']}...")
    sumber_daya = get_sumber_daya(peer)
    for key, value in sumber_daya.items():
      print(f"\n[{key.upper()}]\n{value}\n")