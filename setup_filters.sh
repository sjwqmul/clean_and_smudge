#!/bin/bash
#
# Setup git filters to encrypt/decrypt data as it is passed to/from git
# NB: This script must be run from a folder in the repository to be configured
#

# Find root folder for repository
GIT_ROOT=$(git rev-parse --show-toplevel)

# Create removeapikey attribute
ATTR_FILE=$GIT_ROOT/.gitattributes
ATTR_SET=""
if [ -e "$ATTR_FILE" ]; then
    grep -v removeapikey "$ATTR_FILE" >"$ATTR_FILE"
fi
echo "*.php filter=removeapikey diff=removeapikey" >>"$ATTR_FILE"

# Check for existing password file
CONFIG_DIR=$GIT_ROOT/.clean_smudge
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir "$CONFIG_DIR"
fi
# If no password file exists, generate a 1k random password file
PASSWORD_FILE="$CONFIG_DIR/password"
if [ ! -e "$PASSWORD_FILE" ]; then
    dd if=/dev/urandom of="$PASSWORD_FILE" bs=1k count=1 >/dev/null 2>&1
fi

# Ensure that the password file is ignored
IGN_FILE=$GIT_ROOT/.gitignore
if [ -e "$IGN_FILE" ]; then
    grep -v ".clean_smudge" "$IGN_FILE" >"$IGN_FILE"
fi
echo ".clean_smudge" >>"$IGN_FILE"

FILTER_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
git config filter.removeapikey.clean ${FILTER_DIR}/clean.sh
git config filter.removeapikey.smudge ${FILTER_DIR}/smudge.sh
git config diff.removeapikey.textconv ${FILTER_DIR}/strip.sh
