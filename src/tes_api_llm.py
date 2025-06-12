from mistralai import Mistral
import requests
import json

def hubungi_deepseek():
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
          "content": "create 1 sentence wholesome tale"
        }
      ],
    })
  )

  return response.json()["choices"][0]["message"]["content"]

def hubungi_mistral():
  api_key = "btoHd0ZMZq3iOX8QPr80OPulAc20aRfq"
  model = "mistral-large-latest"

  client = Mistral(api_key=api_key)

  chat_response = client.chat.complete(
    model= model,
    messages = [
      {
        "role": "user",
        "content": "create 1 sentence wholesome tale",
      },
    ]
  )
  
  return chat_response.choices[0].message.content

if __name__ == "__main__":
  # dari_mistral = hubungi_mistral()
  # print(f"mistral:\n{dari_mistral}")

  dari_deepseek = hubungi_deepseek()
  print(f"deepseek:\n{dari_deepseek}")