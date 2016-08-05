#!/bin/bash
#
# Setup git filters to 
#
GIT_ROOT=$(git rev-parse --show-toplevel)
ATTR_FILE=$GIT_ROOT/.gitattributes
ATTR_SET=""
if [ -e $ATTR_FILE ]; then
    grep -v removeapikey $ATTR_FILE >$ATTR_FILE
fi
echo "*.php filter=removeapikey" >>$ATTR_FILE

FILTER_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
git config filter.removeapikey.clean ${FILTER_DIR}/clean.sh
git config filter.removeapikey.smudge ${FILTER_DIR}/smudge.sh
