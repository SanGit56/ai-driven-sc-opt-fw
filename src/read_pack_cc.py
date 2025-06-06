import tarfile
import os

def kemas_chaincode(alamat_cc, nama_keluaran):
  nama_keluaran += ".tar.gz"

  dir_saat_ini = os.path.dirname(os.path.abspath(__file__))
  dir_parent = os.path.dirname(dir_saat_ini)
  dir_keluaran = os.path.join(dir_parent, 'packaged_cc')

  os.makedirs(dir_keluaran, exist_ok=True)

  alamat_keluaran = os.path.join(dir_keluaran, nama_keluaran)

  with tarfile.open(alamat_keluaran, "w:gz") as tar:
    tar.add(alamat_cc, arcname=os.path.basename(alamat_cc))

  print(f"Chaincode '{alamat_cc}' dikemas menjadi '{alamat_keluaran}'")

def baca_konten_file(alamat_file):
  with open(alamat_file, 'r') as f:
    return f.read()

def alamat_lngkp_entri(alamat_dir):
  alamat = []
  for item in os.listdir(alamat_dir):
    alamat_lngkp = os.path.join(alamat_dir, item)
    alamat.append(alamat_lngkp)
  return alamat

def daftar_folder_chaincode(alamat_dir):
  folders = []
  for item in os.listdir(alamat_dir):
    alamat_lngkp = os.path.join(alamat_dir, item)

    if os.path.isdir(alamat_lngkp):
      # kemas folder chaincode
      kemas_chaincode(alamat_lngkp, item)

      # baca entri dalam folder terbaca
      # entri = alamat_lngkp_entri(alamat_lngkp)
      # print(f"[Isi (file/folder) dalam {item}]")
      # for e in entri:
      #   print(e)

      # print()
      folders.append(item)

  return folders

def daftar_file_chaincode(alamat_dir):
  files = []
  for item in os.listdir(alamat_dir):
    alamat_lngkp = os.path.join(alamat_dir, item)

    if os.path.isfile(alamat_lngkp):
      # isi_file = baca_konten_file(alamat_lngkp)
      # print(f"[{item}]\n{isi_file}")
      files.append(item)

  return files

if __name__ == "__main__":
  folder_chaincode = "../chaincodes"

  # print()
  # daftar_file = daftar_file_chaincode(folder_chaincode)
  # print(f"[File dalam folder {folder_chaincode}]")
  # for fi in daftar_file:
  #   print(fi)
  
  print()
  daftar_folder = daftar_folder_chaincode(folder_chaincode)
  print(f"[Folder dalam folder {folder_chaincode}]")
  for fo in daftar_folder:
    print(fo)
  
  # print()
  # entri = alamat_lngkp_entri(folder_chaincode)
  # print("[Alamat lengkap entri (file/folder) chaincode]")
  # for e in entri:
  #   print(e)