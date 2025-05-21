#!/bin/bash
#update whitelist ip di ai service azure

# Konfigurasi
#update dulu subscribtion id nya ya
subscription_id="c2d56a57-ganti"
api_version="2023-05-01"
#jsonnya juga jangan lupa di update
json_file="listip.json"
#apalagi isi servicenya
input_file="aiservices.txt"

# Cek apakah file input dan JSON whitelist ada
if [[ ! -f "$input_file" ]]; then
  echo "ERROR: File $input_file tidak ditemukan!"
  exit 1
fi

if [[ ! -f "$json_file" ]]; then
  echo "ERROR: File $json_file tidak ditemukan!"
  exit 1
fi

# Loop untuk setiap baris di file
while IFS=',' read -r ai_name resource_group; do
  echo "🔄 Updating $ai_name in resource group $resource_group..."

  az rest --method PATCH \
    --url "https://management.azure.com/subscriptions/${subscription_id}/resourceGroups/${resource_group}/providers/Microsoft.CognitiveServices/accounts/${ai_name}?api-version=${api_version}" \
    --body "@${json_file}" \
    --headers "Content-Type=application/json"

  echo "✅ Done with $ai_name"
  echo "----------------------------------"

done < "$input_file"
