#!/bin/bash
# Script for stripping encrypted data from files
sed 's/\(<<<ENCRYPTED=.+>>>\)/[[encrypted data]]/g' $1
