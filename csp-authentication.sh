#!/usr/bin/env bash

VERSION=v4.2.0
BINARY=yq_linux_amd64

# Checking if csp_auth.yaml is present or not
ls ~/
AuthFilePath=/home/ec2-user/.csp/csp_auth.yaml
if [[ ! -f "${AuthFilePath}" ]]; then
    echo -e "\n  ERROR: Authentication YAML file is not available. Kindly add the required file........."
    exit 1
else
    echo -e "\n INFO: Installing YQ package............."
fi


#------------------------------
# YQ installation
#------------------------------

command -v yq > /dev/null 2>&1
RETURNCODE="${?}"
if [[ "${RETURNCODE}" -ne 0 ]]; then
    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq > /dev/null 2>&1
    chmod +x /usr/bin/yq > /dev/null 2>&1
    command -v yq > /dev/null 2>&1
    RETURNCODE="${?}"
    if [[ "${RETURNCODE}" -eq 0 ]]; then
      echo -e "\n INFO: yq is successfully installed................"
    else
      echo -e "\n ERROR: There is some error while installing yq package.........."
      exit 1
    fi
else
    echo "INFO: yq is already installed hence skipping the installation........."
fi

# ------------------------------------
# AWS AUTHENCATION
# -----------------------------------


REGION=$(yq e '.auth_config.aws.Region' ${AuthFilePath})
OUTPUT=$(yq e '.auth_config.aws.Output' ${AuthFilePath})
AWS_ACCESS_KEY_ID=$(yq e '.auth_config.aws.Access_key' ${AuthFilePath})
AWS_SECRET_ACCESS_KEY=$(yq e '.auth_config.aws.Secret_access_key' ${AuthFilePath})

# Configuring AWS CLI
echo -e "\n INFO: Configuring AWS CLI................."
aws configure set region "${REGION}"
aws configure set output "${OUTPUT}"
aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"

# Validating Authentication
echo -e "\n INFO: Validating AWS Authentication"
aws sts get-caller-identity > /dev/null 2>&1
AUTHENTICATIONRETURNCODE="${?}"
if [[ "${AUTHENTICATIONRETURNCODE}" -ne 0 ]]; then
   echo -e "\n ERROR: INVALID CREDENTIALS KINDLY ENTER THE CORRECT AWS-ACESS-KEY ID OR AWS-SECRET-KEY....................."
   exit 1
else
   IAMUSER=$(aws sts get-caller-identity --query 'Arn' --output text | awk -F '/' '{print $NF}')
   echo -e "\n SUCCESS: ${IAMUSER} Successsfully authenticated................"
fi


# ------------------------------------------
# Azure Authentication
# ------------------------------------------

# Configuring Azure CLI
echo -e "\n INFO: Configuring Azure CLI................."
client_id=$(yq eval '.auth_config.azure.client_id' "${AuthFilePath}")
tenant_id=$(yq eval '.auth_config.azure.tenant_id' "${AuthFilePath}")
password=$(yq eval '.auth_config.azure.client_secret' "${AuthFilePath}")

# Validating Authentication
echo -e "\n INFO: Validating Azure Authentication"
az login --service-principal -u "${client_id}" -p "${password}" --tenant "${tenant_id}"  --allow-no-subscriptions
RETURNCODE="${?}"

if [[ "${RETURNCODE}" -eq 0 ]]; then
  id=$(az account show --query 'user.name' -o tsv)
  IAMUSER=$(az ad sp show --id "${id}" --query appDisplayName -o tsv)
  echo -e "\n SUCCESS: Successfully login into azure with ${IAMUSER}.................."
else
  echo -e "\n ERROR: Authentication error kindly check username, password and tenant id in ${AuthFilePath}................."
  exit 1
fi

# Logging off
echo -e "\n INFO:LOGGING OFF................."
rm -rf ~/.aws/config
rm -rf ~/.aws/credentials
rm -rf ~/.azure