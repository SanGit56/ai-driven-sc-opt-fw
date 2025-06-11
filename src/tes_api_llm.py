# DEEPSEEK VIA OPENROUTER
import requests
import json

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
        "content": "create 1 sentence tale about justice"
      }
    ],
    
  })
)

print(response.json()["choices"][0]["message"]["content"])

# DEEPSEEK
# from openai import OpenAI

# client = OpenAI(api_key="", base_url="https://api.deepseek.com")

# response = client.chat.completions.create(
#     model="deepseek-chat",
#     messages=[
#         {"role": "user", "content": "create 1 sentence tale about justice"},
#     ],
#     stream=False
# )

# print(response.choices[0].message.content)

# MISTRAL
# import os
# from mistralai import Mistral

# api_key = os.environ["MISTRAL_API_KEY"]
# model = "mistral-large-latest"

# client = Mistral(api_key=api_key)

# chat_response = client.chat.complete(
#     model= model,
#     messages = [
#         {
#             "role": "user",
#             "content": "create 1 sentence tale about justice",
#         },
#     ]
# )
# print(chat_response.choices[0].message.content)