import os
import paramiko
from scp import SCPClient

def kirim_cc_sesuai_rekom(file_rekom, ssh_kunci):
  with open(file_rekom, 'r') as f:
    for baris in f:
      if '->' not in baris:
        continue

      nama_cc, daftar_ip = baris.strip().split('->')
      nama_cc = nama_cc.strip()
      ip_peer = [ip.strip() for ip in daftar_ip.split(',')]

      alamat_cc_terkemas = os.path.join('../packaged_cc', f'{nama_cc}.tar.gz')

      if not os.path.exists(alamat_cc_terkemas):
        print(f'{alamat_cc_terkemas} tidak ditemukan')
        continue

      for ip in ip_peer:
        try:
          if ip == "10.125.175.72":
            ssh_pengguna = "worker1"
          elif ip == "10.125.175.114":
            ssh_pengguna = "worker2"
          elif ip == "10.125.175.105":
            ssh_pengguna = "worker3"
          else:
            ssh_pengguna = "workerx"

          print(f'Mengirim {nama_cc}.tar.gz to {ip}')

          ssh = paramiko.SSHClient()
          ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
          ssh.connect(hostname=ip, username=ssh_pengguna, key_filename=f'/home/{ssh_pengguna}/.ssh/id_rsa')

          with SCPClient(ssh.get_transport()) as scp:
            scp.put(alamat_cc_terkemas, remote_path=f'home/{ssh_pengguna}/ai-driven-sc-opt-fw/packaged_cc')

          ssh.close()
          print(f'Terkirim ke {ip}')
        except Exception as e:
          print(f'Gagal mengirim {nama_cc}.tar.gz ke {ip}: {e}')

if __name__ == "__main__":
  file_rekom = "rekom_cc-peer.txt"
  ssh_kunci = os.path.expanduser('/home/loadbalancer/.ssh/id_rsa')

  kirim_cc_sesuai_rekom(file_rekom, ssh_kunci)