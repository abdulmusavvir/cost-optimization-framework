#!/bin/bash

CentosDistribution=$(command -v yum)
if [[ -n "${CentosDistribution}" ]]; then
   DETECT_SECRET=$(command -v detect-secrets)
   if [[ -z "${DETECT_SECRET}" ]]; then
      sudo yum install python3-pip -y > /dev/null 2>&1
      pip install detect-secrets
      echo PATH=$PATH:~/.local/bin >> ~/.bashrc
      DETECT_SECRET=~/.local/bin/detect-secrets
      echo -e "\n INFO: detect-secrets successfully installed......................"
    fi
fi

UbuntuDistribution=$(command -v apt-get)
if [[ -n "${UbuntuDistribution}" ]]; then
   DETECT_SECRET=$(command -v detect-secrets)
   if [[ -z "${DETECT_SECRET}" ]]; then
      sudo apt install python3 python3-pip -y > /dev/null
      # Install secret-detect using pip
      pip install detect-secrets
      echo PATH=$PATH:~/.local/bin >> ~/.bashrc
      DETECT_SECRET=~/.local/bin/detect-secrets
      echo -e "\n INFO: detect-secret successfully installed......................"
   fi
fi


echo -e "\n INFO: detect-secrets started ......................"
if [[ $($DETECT_SECRET scan | jq -r '.results | keys[]' | wc -l) -ne 0 ]]; then

  echo -e "\n============================================"
  echo "ERROR: Sensitive information detected."
  echo -e "============================================\n"
  ${DETECT_SECRET} scan | jq -r '.results | .[]'
  exit 1
else
   echo -e "\n SUCCESS: All files has been detected.............."
fi