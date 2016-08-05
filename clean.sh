#!/bin/bash

# Script for cleaning api keys in PHP scripts

# Get input from STDIN or specified file name 
INPUT=$(cat ${1:-/dev/stdin})

# Specify file containing encryption/decryption password
DIR=$(dirname "${BASH_SOURCE[0]}")
PASSWORD_FILE=$DIR/password

# Regex to match a PHP variable name
VARNAME_EXP="\\\$[a-zA-z0-9\\_]*api[a-zA-Z0-9\\_]*"
# Regex to match an API key (hex string)
API_KEY_EXP="[0-9A-F]*"

# Get the API key(s) from the input
API_KEYS=$(echo -e "$INPUT" | sed -n "s/^\(.*\)\($VARNAME_EXP\)\([ \t]*=[ \t]*\"\)\($API_KEY_EXP\)\(\".*$\)/\4/p")
for API_KEY in $API_KEYS; do
    # Encrypt the API key based on a local password file
    ENCRYPTED_KEY=$(echo $API_KEY | openssl aes-256-cbc -e -a -A -pass file:$PASSWORD_FILE)
    
    # Escape any / characters in key
    ESC_ENCRYPTED_KEY=$(echo -e "$ENCRYPTED_KEY" | sed -e 's_/_\\/_g')
    
    # Replace the API key
    INPUT=$(echo -e "$INPUT" | sed "s/$API_KEY/<<<ENCRYPTED=$ESC_ENCRYPTED_KEY>>>/")
done

echo -e "$INPUT"
