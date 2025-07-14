import os
import paramiko
from scp import SCPClient

def kirim_cc_sesuai_rekom(file_rekom, ssh_kunci):
  with open(file_rekom, 'r') as f:
    for baris in f:
      if '->' not in baris:
        continue

      nama_cc, daftar_peer = baris.strip().split('->')
      nama_cc = nama_cc.strip()
      nama_peer = [peer.strip() for peer in daftar_peer.split(',')]

      alamat_cc_terkemas = os.path.join('../packaged_cc', f'{nama_cc}.tar.gz')

      if not os.path.exists(alamat_cc_terkemas):
        print(f'{alamat_cc_terkemas} tidak ditemukan')
        continue

      for peer in nama_peer:
        try:
          if peer == "peer0":
            ssh_pengguna = "worker1"
            ip = "10.125.178.58"
          elif peer == "peer1":
            ssh_pengguna = "worker2"
            ip = "10.125.176.96"
          elif peer == "peer2":
            ssh_pengguna = "worker3"
            ip = "10.125.178.62"
          else:
            ssh_pengguna = "workerx"
            ip = "10.125.xxx.xxx"

          print(f'Mengirim {nama_cc}.tar.gz to {peer}')

          ssh = paramiko.SSHClient()
          ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
          ssh.connect(hostname=ip, username=ssh_pengguna, key_filename=f'/home/loadbalancer/.ssh/id_rsa')

          with SCPClient(ssh.get_transport()) as scp:
            scp.put(alamat_cc_terkemas, remote_path=f'/home/{ssh_pengguna}/Documents/ai-driven-sc-opt-fw/network')

          ssh.close()
          print(f'Terkirim ke {peer}')
        except Exception as e:
          print(f'Gagal mengirim {nama_cc}.tar.gz ke {peer}: {e}')

if __name__ == "__main__":
  file_rekom = "rekom_deepseek.txt"
  ssh_kunci = os.path.expanduser('/home/loadbalancer/.ssh/id_rsa')

  kirim_cc_sesuai_rekom(file_rekom, ssh_kunci)