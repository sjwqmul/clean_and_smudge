#!/bin/bash
# Script for stripping encrypted data from files
BASE64_CHARS='A-Za-z0-9\+\/'
sed "s/\(<<<ENCRYPTED=[$BASE64_CHARS]*[=]\{0,3\}>>>\)/\[\[encrypted data\]\]/g" ${1:-/dev/stdin}
