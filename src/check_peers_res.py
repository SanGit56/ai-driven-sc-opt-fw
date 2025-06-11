import json
import paramiko

def baca_peers(alamat_file):
  with open(alamat_file, 'r') as f:
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
    keluaran = stdout.read().decode()
    hasil[label] = keluaran.strip()

  ssh.close()
  return hasil

if __name__ == "__main__":
  peers = baca_peers("daftar_peers.json")

  with open("peers_res_check.txt", "w") as file_spesifikasi:
    for peer in peers:
      header = f"Cek sumber daya {peer['name']}..."
      print(header)
      file_spesifikasi.write(header + "\n")

      sumber_daya = get_sumber_daya(peer)

      for key, value in sumber_daya.items():
        bagian = f"[{key}]\n{value}\n"
        print(bagian)
        file_spesifikasi.write(bagian + "\n")