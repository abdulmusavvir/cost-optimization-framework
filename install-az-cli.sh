#!/bin/bash
echo -e "\n DEBUG: Checking PreRequisit Packages and Linux Distribution.........."
function prerequisit_packages(){
    PrerequisitPackages='curl wget'
    CentosDistribution=$(command -v yum)
    if [[ -n "${CentosDistribution}" ]]; then
       echo -e "\n INFO: Centos Distribution......................"
       for package in $PrerequisitPackages
       do
          rpm -qi "${package}" > /dev/null 2>&1
          RETURNCODE="${?}"
          if [[ RETURNCODE -eq 0 ]]; then
             echo -e "\n INFO: ${package} is already installed........."
          else
             echo -e "\n INFO: ${package} is installing........."
             yum install -y "${package}" > /dev/null 2>&1 
             status=$(command -v "${package}")
                if [[ -n "${status}" ]]; then
                    echo -e "\n SUCCESS: ${package} is installed........."
                else
                    echo -e "\n ERROR: ${package} is not installed........."
                fi
          fi
       done
    fi
    UbuntuDistribution=$(command -v apt-get)
    if [[ -n "${UbuntuDistribution}" ]]; then
       echo -e "\n INFO: Ubuntu Distribution..................."
       for package in $PrerequisitPackages
       do
          if [[ $(dpkg-query -l "{$package}" > /dev/null 2>&1) ]]; then
             echo -e "\n INFO: ${package} is already installed........."
          else
             echo -e "\n INFO: ${package} is installing........."
             apt-get update -y > /dev/null 
             apt-get install -y "${package}" > /dev/null 2>&1 
             status=$(command -v "${package}")
                if [[ -n "${status}" ]]; then
                    echo -e "\n SUCCESS: ${package} is installed successfully........."
                else
                    echo -e "\n ERROR: ${package} is not installed........."
                fi
          fi
       done
    fi
}
prerequisit_packages
echo -e "\n INFO: Installing Cloud CommandLine Utilities"
echo -e "\n DEBUG: Checking if Azure CLI is installed or not"
AZCheck=$(command -v az)
if [[ -z "${AZCheck}" ]]; then
    echo -e "\n ERROR: Azure CLI is not install in the system"
    echo -e "\n INFO: Installing Azure CLI...."
    CentosDistribution=$(command -v yum)
    if [[ -n "${CentosDistribution}" ]]; then
       echo -e "\n INFO: Centos Distribution......................"
       rpm --import https://packages.microsoft.com/keys/microsoft.asc
       dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm -y
       dnf install azure-cli -y
       AZCheck=$(command -v az)
    else
       UbuntuDistribution=$(command -v apt-get)
       echo -e "\n INFO: Ubuntu Distribution..................."      
        # Creating script folder for azure
        mkdir /opt/scripts
        # Downloading Azure shell script
        curl -sL https://aka.ms/InstallAzureCLIDeb >/opt/scripts/azure.sh
        # Installing azure bash scripts
        chmod 755 /opt/scripts/azure.sh
        /opt/scripts/azure.sh
        # checking if script is properly executed or not
        AZCheck=$(command -v az)
        if [[ -z "${AZCheck}" ]]; then
            echo  -e "\n SUCCESS: Az cli successfully installed."
        else
            echo -e "\n ERROR: Az cli installation failed."
            exit 1
        fi
    fi  
else
    echo -e "\n INFO: AZURE CLI is already install in the system, Skipping Installation"
fi