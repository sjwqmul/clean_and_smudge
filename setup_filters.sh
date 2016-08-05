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
if [ -e $ATTR_FILE ]; then
    grep -v removeapikey $ATTR_FILE >$ATTR_FILE
fi
echo "*.php filter=removeapikey" >>$ATTR_FILE

# Check for existing password file
PASSWORD_FILE="password"
# If no password file exists, generate a 1k random password file
# dd if=/dev/urandom of=$PASSWORD_FILE bs=1k count=1

# Ensure that the password file is ignored
#IGN_FILE=$GIT_ROOT/.gitignore
#if [ -e $IGN_FILE ]; then
#    grep -v $PASSWORD_FILE $IGN_FILE >$IGN_FILE
#fi
#echo "$PASSWORD_FILE" >>$ATTR_FILE

FILTER_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
git config filter.removeapikey.clean ${FILTER_DIR}/clean.sh
git config filter.removeapikey.smudge ${FILTER_DIR}/smudge.sh
