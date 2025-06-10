#!/bin/bash

read -p "Enter the path to your JS URL list (e.g. js-wayback.txt): " url_list

if [[ ! -f "$url_list" ]]; then
  echo "[!] File not found: $url_list"
  exit 1
fi

# Output file
output="findings.txt"
> "$output"

# Regex patterns
keyword_regex='apikey|token|auth|secret|password|jwt|bearer'
url_regex='https?://[a-zA-Z0-9./?=_-]*'
api_regex='\/[a-zA-Z0-9\/\-_]*api[a-zA-Z0-9\/\-_]*'

while IFS= read -r js_url; do
  [[ -z "$js_url" ]] && continue  # skip empty lines

  echo "[+] Scanning: $js_url"
  echo -e "\n===== Results from: $js_url =====" >> "$output"

  js_content=$(curl -s "$js_url")
  [[ -z "$js_content" ]] && echo "[-] Failed to fetch or empty file" >> "$output" && continue

  # Extract and label matches
  keywords=$(echo "$js_content" | grep -Eino "$keyword_regex" | sort -u)
  full_urls=$(echo "$js_content" | grep -Eo "$url_regex" | sort -u)
  relative_apis=$(echo "$js_content" | grep -Eo "$api_regex" | sort -u)

  if [[ -n "$keywords" ]]; then
    echo -e "\n[*] Sensitive Keywords Found:" >> "$output"
    echo "$keywords" >> "$output"
  else
    echo -e "\n[*] No sensitive keywords found." >> "$output"
  fi

  if [[ -n "$full_urls" ]]; then
    echo -e "\n[*] Full URLs Found:" >> "$output"
    echo "$full_urls" >> "$output"
  else
    echo -e "\n[*] No full URLs found." >> "$output"
  fi

  if [[ -n "$relative_apis" ]]; then
    echo -e "\n[*] Relative API Endpoints Found:" >> "$output"
    echo "$relative_apis" >> "$output"
  else
    echo -e "\n[*] No API endpoints found." >> "$output"
  fi

  echo -e "\n=====================================" >> "$output"

done < "$url_list"

echo -e "\n[✓] Scanning complete. Results saved in: $output"
