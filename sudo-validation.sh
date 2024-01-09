#!/bin/bash
# set -x
echo -e  "\n ............checking logged in user's id..............."
userId=`whoami | id -u`
if [[ "$userId" -eq 0 ]]; then
    echo "INFO: User with sudo privileg detected, proceeding with further execution."
else
    echo "ERROR: Please execute the script with sudo privilege user."
    exit 1
fi