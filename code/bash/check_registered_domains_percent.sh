#!/bin/bash

input_file="$1"

if [ -z "$input_file" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

total_domains=0
registered_domains=0

while read domain; do
  total_domains=$((total_domains + 1))
  whois_output=$(whois "$domain" 2>/dev/null)

  if ! echo "$whois_output" | grep -qEi "No match for|NOT FOUND|No Data Found|No entries found|Not Registered|No information available"; then
    registered_domains=$((registered_domains + 1))
    #echo "Registered: $domain"
 # else

    #echo "Not registered: $domain"
  fi
done < "$input_file"

percentage=$((registered_domains * 10000 / total_domains))
percentage_decimal=$((percentage % 100))
percentage_whole=$((percentage / 100))

echo "Registered(%): $percentage_whole.$percentage_decimal%"
