from mistralai import Mistral
import requests
import time
import json
import re
import os

def buat_file_rekom(filename, pasangan_cc_peer):
  with open(filename, 'a') as file:
    file.write(f"{pasangan_cc_peer}\n")

def baca_file(file_masukan):
  with open(file_masukan, "r") as f:
    return f.read()

def hubungi_deepseek(file_chaincode):
  file_prompt = baca_file("prompt_rec.txt")
  file_cc = baca_file(file_chaincode)

  response = requests.post(
    url="https://openrouter.ai/api/v1/chat/completions",
    headers={
      "Authorization": "Bearer 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",
      "Content-Type": "application/json",
    },
    data=json.dumps({
      "model": "deepseek/deepseek-r1:free",
      "messages": [
        {
          "role": "user",
          "content": f"{file_prompt}\nfile path is {file_chaincode}\nthe chaincode is:\n{file_cc}"
        }
      ],
    })
  )

  return response.json()["choices"][0]["message"]["content"]

def hubungi_mistral(file_chaincode):
  client = Mistral(api_key="btoHd0ZMZq3iOX8QPr80OPulAc20aRfq")
  file_prompt = baca_file("prompt_rec.txt")
  file_cc = baca_file(file_chaincode)

  chat_response = client.chat.complete(
    model= "mistral-large-latest",
    messages = [
      {
        "role": "user",
        "content": f"{file_prompt}\nfile path is {file_chaincode}\nthe chaincode is:\n{file_cc}",
      },
    ]
  )
  
  return chat_response.choices[0].message.content

def get_file_smartcontract(dir_dasar='../chaincodes'):
  file_smartcontract = []

  for dir_chaincode in os.listdir(dir_dasar):
    alamat_cc = os.path.join(dir_dasar, dir_chaincode)
    if not os.path.isdir(alamat_cc):
      continue

    for subdir in os.listdir(alamat_cc):
      alamat_full_subdir = os.path.join(alamat_cc, subdir)
      if subdir == 'vendor' or not os.path.isdir(alamat_full_subdir):
        continue

      files = os.listdir(alamat_full_subdir)
      if len(files) == 1 and files[0].endswith('.go'):
        file_smartcontract.append(os.path.join(alamat_full_subdir, files[0]))

  return file_smartcontract

if __name__ == "__main__":
  file_sc = get_file_smartcontract()
  for f in file_sc:
    print(f)
    # hasil_prompt = hubungi_mistral(f)
    hasil_prompt = hubungi_deepseek(f)

    buat_file_rekom("rekom_cc_peer.txt", hasil_prompt)
    time.sleep(5)