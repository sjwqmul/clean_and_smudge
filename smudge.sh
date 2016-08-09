#!/bin/bash

# Script for decrypting encrypted content

# Get input from STDIN or specified file name 
INPUT=$(cat ${1:-/dev/stdin} | sed 's/\\/\\\\/g')

# Specify the password file
DIR=$(git rev-parse --show-toplevel)
DIR="$DIR/.clean_smudge"
PASSWORD_FILE="$DIR/password"

# Test whether password file exists
if [ ! -e "$PASSWORD_FILE" ]; then
    echo "No password file was found" >&2
    exit 1
fi

# Get the encrypted items from the input
ENCRYPTED_ITEMS=$(echo -e "$INPUT" | sed -n "s/^\(.*<<<ENCRYPTED=\)\(.*\)\(>>>.*\)$/\2/p")

for ENCRYPTED_ITEM in $ENCRYPTED_ITEMS; do
    # Decrypt the API key based on a local password file
    DECRYPTED_ITEM=$(echo -e "$ENCRYPTED_ITEM" | openssl aes-256-cbc -d -a -A -pass "file:$PASSWORD_FILE" 2>&1)
    STATUS=$?
    if [ $STATUS != 0 ]; then
        echo "Unable to decrypt item" >&2
        echo "Using password file: $PASSWORD_FILE" >&2
        echo -e "$DECRYPTED_ITEM" >&2
        exit $STATUS
    fi
    
    # Escape any "/" in the encrypted key
    ESC_ENCRYPTED_ITEM=$(echo -e "$ENCRYPTED_ITEM" | sed -e 's_/_\\/_g')
    
    # Replace the API key
    INPUT=$(echo -e "$INPUT" | sed -e "s/<<<ENCRYPTED=$ESC_ENCRYPTED_ITEM>>>/$DECRYPTED_ITEM/" -e 's/\\/\\\\/g')
done

echo -e "$INPUT"
