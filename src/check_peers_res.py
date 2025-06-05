import json
import paramiko

def baca_peers(file_path):
  with open(file_path, 'r') as f:
    return json.load(f)

def get_sumber_daya(peer):
  ssh = paramiko.SSHClient()
  ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
  
  ssh.connect(
    hostname=peer["host"],
    username=peer["user"],
    key_filename="/home/loadbalancer/.ssh/id_rsa"
  )
  
  perintah = {
    "cpu": "lscpu | grep 'CPU(s)' | head -n 1",
    "memory": "free -m | head -n 2",
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
  peers = baca_peers("daftar_peers.json")
  for peer in peers:
    print(f"Cek sumber daya {peer['name']}...")
    sumber_daya = get_sumber_daya(peer)
    for key, value in sumber_daya.items():
      print(f"[{key}]\n{value}\n")