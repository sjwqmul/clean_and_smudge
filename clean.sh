#!/bin/bash

# Script for cleaning api keys in PHP scripts

# Get input from STDIN or specified file name 
INPUT=$(cat ${1:-/dev/stdin})

# Regex to match a PHP variable name
VARNAME_EXP="\\\$[a-zA-z0-9\\_]*api[a-zA-Z0-9\\_]*"
# Regex to match an API key (hex string)
API_KEY_EXP="[0-9A-F]*"

# Get the API key from the input
API_KEY=$(echo -e "$INPUT" | sed -n "s/^\(.*\)\($VARNAME_EXP\)\([ \t]*=[ \t]*\"\)\($API_KEY_EXP\)\(\".*$\)/\4/p")

# Encrypt the API key based on a local password file
DIR=$(dirname "${BASH_SOURCE[0]}")
ENCRYPTED_KEY=$(echo $API_KEY | openssl aes-256-cbc -e -a -A -pass file:$DIR/password)

# Escape any / characters in key
ESC_ENCRYPTED_KEY=$(echo -e "$ENCRYPTED_KEY" | sed -e 's_/_\\/_g')

# Replace the API key
echo -e "$INPUT" | sed "s/$API_KEY/<<<ENCRYPTED=$ESC_ENCRYPTED_KEY>>>/"
