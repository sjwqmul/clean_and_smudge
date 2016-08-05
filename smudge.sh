#!/bin/bash

# Script for decrypting encrypted content

# Get input from STDIN or specified file name 
INPUT=$(cat ${1:-/dev/stdin})

# Specify the password file
DIR=$(dirname "${BASH_SOURCE[0]}")
PASSWORD_FILE="$DIR/password"
echo $PASSWORD_FILE
# Get the encrypted API key from the input
ENCRYPTED_KEYS=$(echo -e "$INPUT" | sed -n "s/^\(.*<<<ENCRYPTED=\)\(.*\)\(>>>.*\)$/\2/p")
echo $ENCRYPTED_KEYS

for ENCRYPTED_KEY in $ENCRYPTED_KEYS; do
    echo $ENCRYPTED_KEY
    # Decrypt the API key based on a local password file
    DECRYPTED_KEY=$(echo -e "$ENCRYPTED_KEY" | openssl aes-256-cbc -d -a -A -pass "file:$PASSWORD_FILE")
    
    # Escape any "/" in the encrypted key
    ESC_ENCRYPTED_KEY=$(echo -e "$ENCRYPTED_KEY" | sed -e 's_/_\\/_g')
    
    # Replace the API key
    INPUT=$(echo -e "$INPUT" | sed "s/<<<ENCRYPTED=$ESC_ENCRYPTED_KEY>>>/$DECRYPTED_KEY/")
done

echo -e "$INPUT"
