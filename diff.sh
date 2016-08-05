#!/bin/bash

# Script for cleaning api keys in PHP scripts

# Input parameters: path old-file old-hex old-mode new-file new-hex new-mode

echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo $7

exit 0

# Get input from STDIN or specified file name 
INPUT=$(cat ${1:-/dev/stdin})

# Specify file containing encryption/decryption password
DIR=$(git rev-parse --show-toplevel)
DIR="$DIR/.clean_smudge"
PASSWORD_FILE=$DIR/password

# Test whether password file exists
if [ ! -e "$PASSWORD_FILE" ]; then
    echo "No password file was found" >&2
    exit 1
fi

function encrypt_items {
    NAME_EXP="$1"
    VALUE_EXP="$2"
    INPUT="$3"

    # Get the API key(s) from the input
    PATTERN='^\(.*\)\('"$NAME_EXP"'\)\([ \t]*=[ \t]*\)\([\'"'"'\"]\)\('"$VALUE_EXP"'\)\(\4.*$\)'
    ITEMS=$(echo -e "$INPUT" | sed -n "s/$PATTERN/\5/p")
    # Only split results on new lines
    OLD_IFS=$IFS
    IFS=$'\n'
    # Encrypt each item 
    for ITEM in $ITEMS; do
        # Encrypt the API key based on a local password file
        ENCRYPTED_ITEM=$(echo $ITEM | openssl aes-256-cbc -e -a -A -pass file:$PASSWORD_FILE)
        
        # Escape any / characters in key
        ESC_ENCRYPTED_ITEM=$(echo -e "$ENCRYPTED_ITEM" | sed -e 's_/_\\/_g')
        
        # Replace the API key
        INPUT=$(echo -e "$INPUT" | sed "s/$ITEM/<<<ENCRYPTED=$ESC_ENCRYPTED_ITEM>>>/")
    done
    # Revert to standard separator
    IFS=$OLD_IFS
    echo -e "$INPUT"
}

# Encrypt API keys
# Regex to match a PHP variable name for an api key (has api in it)
VARNAME_EXP='\$[a-zA-z0-9\\_]*api[a-zA-Z0-9\\_]*'
# Regex to match an API key value (hex string)
API_KEY_EXP='[0-9A-F]*'
INPUT=$(encrypt_items "$VARNAME_EXP" "$API_KEY_EXP" "$INPUT")

# Encrypt passwords
# Regex to match a PHP variable name for a password (has password in it)
VARNAME_EXP="\\\$[a-zA-z0-9\\_]*password[a-zA-Z0-9\\_]*"
# Regex to match a password (any characters apart from end-of-string)
PASSWORD_EXP='[^\4]*'
INPUT=$(encrypt_items "$VARNAME_EXP" "$PASSWORD_EXP" "$INPUT")

# Output the results
echo -e "$INPUT"