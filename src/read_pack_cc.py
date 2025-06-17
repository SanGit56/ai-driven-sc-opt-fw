import tarfile
import os
import subprocess
import time

def kemas_chaincode(alamat_cc, nama_keluaran):
  nama_tar = nama_keluaran + ".tar.gz"
  nama_label = nama_keluaran + "_1.0"

  dir_saat_ini = os.path.dirname(os.path.abspath(__file__))
  dir_parent = os.path.dirname(dir_saat_ini)
  dir_keluaran = os.path.join(dir_parent, 'packaged_cc')

  os.makedirs(dir_keluaran, exist_ok=True)
  alamat_keluaran = os.path.join(dir_keluaran, nama_tar)
  waktu_mulai = time.time()

  subprocess.run([
    "peer", "lifecycle", "chaincode", "package", alamat_keluaran,
    "--path", alamat_cc,
    "--lang", "golang",
    "--label", nama_label
  ], check=True)

  waktu_selesai = time.time()
  durasi = waktu_selesai - waktu_mulai
  print(f"Chaincode '{alamat_cc}' dikemas menjadi '{alamat_keluaran} selama {durasi:.2f} detik'")

def daftar_folder_chaincode(alamat_dir):
  folders = []
  for item in os.listdir(alamat_dir):
    alamat_lngkp = os.path.join(alamat_dir, item)

    if os.path.isdir(alamat_lngkp):
      kemas_chaincode(alamat_lngkp, item)
      folders.append(item)

  return folders

if __name__ == "__main__":
  folder_chaincode = "../chaincodes"
  waktu_mulai = time.time()

  daftar_folder_chaincode(folder_chaincode)
  
  waktu_selesai = time.time()
  durasi = waktu_selesai - waktu_mulai
  print(f"Durasi total pengemasan: {durasi:.2f} detik")