from mistralai import Mistral
from pathlib import Path
import subprocess
import requests
import time
import json
import re

def buat_file_dari_prompt(teks_mentah, dir_cc):
  file_skrg = None
  baris_konten = []
  konten_smntr = {}

  for baris in teks_mentah.splitlines():
    header_sesuai = re.match(r"^=== FILE: (.+) ===$", baris.strip())
    if header_sesuai:
      if file_skrg:
        konten_smntr[file_skrg] = "\n".join(baris_konten).strip() + "\n"
        baris_konten = []
      file_skrg = header_sesuai.group(1)
    elif file_skrg:
      baris_konten.append(baris)

  if file_skrg and baris_konten:
    konten_smntr[file_skrg] = "\n".join(baris_konten).strip() + "\n"
  
  konten_go_mod = konten_smntr.get("go.mod", "")
  modul_sesuai = re.search(r"^module\s+(\S+)", konten_go_mod, re.MULTILINE)
  if not modul_sesuai:
    raise ValueError("Nama modul tidak ditemukan di go.mod")

  nama_modul = modul_sesuai.group(1).split("/")[-1]
  chaincode_dir = Path(dir_cc) / nama_modul

  for nama_file, konten in konten_smntr.items():
    alamat_file = chaincode_dir / nama_file
    alamat_file.parent.mkdir(parents=True, exist_ok=True)
    with open(alamat_file, "w") as f:
      f.write(konten)

  subprocess.run(["go", "mod", "tidy"], cwd=chaincode_dir, check=True)
  subprocess.run(["go", "mod", "vendor"], cwd=chaincode_dir, check=True)

  print(f"Chaincode terbit di: {chaincode_dir}\n")

def baca_file_prompt():
  with open("prompt_gen.txt", "r") as f:
    return f.read()

def hubungi_deepseek():
  file_prompt = baca_file_prompt()

  response = requests.post(
    url="https://openrouter.ai/api/v1/chat/completions",
    headers={
      "Authorization": "",
      "Content-Type": "application/json",
    },
    data=json.dumps({
      "model": "deepseek/deepseek-r1:free",
      "messages": [
        {
          "role": "user",
          "content": file_prompt
        }
      ],
    })
  )

  return response.json()["choices"][0]["message"]["content"]

def hubungi_mistral():
  client = Mistral(api_key="")
  file_prompt = baca_file_prompt()

  chat_response = client.chat.complete(
    model= "mistral-large-latest",
    messages = [
      {
        "role": "user",
        "content": file_prompt,
      },
    ]
  )
  
  return chat_response.choices[0].message.content

if __name__ == "__main__":
  for i in range(3):
    hasil_prompt = hubungi_mistral()
    # hasil_prompt = hubungi_deepseek()

    buat_file_dari_prompt(hasil_prompt, "../chaincodes")

    time.sleep(7)