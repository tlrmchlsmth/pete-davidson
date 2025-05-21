#!/bin/bash

# Check if curl is installed
if ! command -v curl &> /dev/null
then
    echo "curl could not be found, please install it first."
    exit 1
fi

# Read each line from stdin
while IFS= read -r url_input; do
  # Extract the hostname or IP address from the input URL
  # This regex tries to capture the part between http(s):// and the optional port or path
  if [[ "$url_input" =~ ^https?://([^/:]+) ]]; then
    ip_addr="${BASH_REMATCH[1]}"
    
    # Construct the target URL for the curl command
    target_url="http://${ip_addr}:8000/reset_prefix_cache"
    
    echo "Sending POST request to: $target_url"
    
    # Execute the curl command
    # -s : silent mode (don't show progress meter or error messages)
    # -o /dev/null : discard the output
    # -w "%{http_code}" : print the HTTP status code
    # Capture the HTTP status code
    http_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$target_url")
    
    echo "Received HTTP status: $http_status for $target_url"
    
    # You can add error handling based on http_status if needed
    # For example:
    # if [ "$http_status" -ne 200 ]; then
    #   echo "Error: Received status $http_status for $target_url"
    # fi
    echo "----------------------------------------"
  else
    echo "Skipping invalid URL format: $url_input"
    echo "----------------------------------------"
  fi
done

echo "All URLs processed."
