#!/bin/bash

# Provide the file name as an argument
file_name="$1"

# Check if the file exists
if [ ! -f "$file_name" ]; then
  echo "File not found. Please provide a valid file name."
  exit 1
fi

# Read the file line by line, assuming each line is a domain
while IFS= read -r domain; do
  # Run the whois command and store the result
  whois_output=$(whois "$domain")

  # Check the whois output for common phrases indicating an unregistered domain
  if [[ $whois_output =~ "No match for" || $whois_output =~ "NOT FOUND" || $whois_output =~ "No Data Found" ]]; then
    echo "The domain $domain is not registered."
  else
    echo "The domain $domain is registered."
  fi
done < "$file_name"

