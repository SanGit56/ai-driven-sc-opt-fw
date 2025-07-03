import subprocess
import time
import os

def sebar_chaincode(directory):
	for nama_file in os.listdir(directory):
		if nama_file.endswith(".tar.gz"):
			nama_cc = nama_file[:-7]
			waktu_mulai = time.time()

			try:
				subprocess.run(["scripts/deployCC.sh", "kanal-fabric", nama_cc], check=True)
				print(f"Berhasil: {nama_cc}")
			except subprocess.CalledProcessError as e:
				print(f"Gagal {nama_cc}: {e}")
		
			waktu_selesai = time.time()
			durasi = waktu_selesai - waktu_mulai
			print(f"Durasi penyebaran {nama_cc}: {durasi:.2f} detik")

if __name__ == "__main__":
	waktu_mulai = time.time()

	for i in range(1):
		sebar_chaincode("../network")

	waktu_selesai = time.time()
	durasi = waktu_selesai - waktu_mulai
	print(f"Durasi total penyebaran: {durasi:.2f} detik")