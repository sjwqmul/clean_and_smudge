#!/bin/bash

# Script for decrypting encrypted content

# Get input from STDIN or specified file name 
INPUT=$(cat ${1:-/dev/stdin})

# Get the encrypted API key from the input
ENCRYPTED_KEY=$(echo -e "$INPUT" | sed -n "s/^\(.*<<<ENCRYPTED=\)\(.*\)\(>>>.*\)$/\2/p")

# Decrypt the API key based on a local password file
DIR=$(dirname "${BASH_SOURCE[0]}")
DECRYPTED_KEY=$(echo -e "$ENCRYPTED_KEY" | openssl aes-256-cbc -d -a -A -pass file:$DIR/password)

# Escape any "/" in the encrypted key
ESC_ENCRYPTED_KEY=$(echo -e "$ENCRYPTED_KEY" | sed -e 's_/_\\/_g')

# Replace the API key
echo -e "$INPUT" | sed "s/<<<ENCRYPTED=$ESC_ENCRYPTED_KEY>>>/$DECRYPTED_KEY/"

