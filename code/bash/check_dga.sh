#!/bin/bash

input_file="$1"

if [ -z "$input_file" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

total_domains=0
classified_as_1=0

while read domain; do
  total_domains=$((total_domains + 1))
  response=$(curl -s "http://10.64.10.39:8002/predict?domain=$domain")
  class=$(echo "$response" | jq '.class')

  if [ "$class" -eq 1 ]; then
    classified_as_1=$((classified_as_1 + 1))
#    echo "Class 1: $domain"
#  else
#    echo "Not class 1: $domain"
  fi
done < "$input_file"

percentage=$((classified_as_1 * 10000 / total_domains))
percentage_decimal=$((percentage % 100))
percentage_whole=$((percentage / 100))

echo "DGA(%): $percentage_whole.$percentage_decimal%"

