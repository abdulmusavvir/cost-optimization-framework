#!/bin/bash
echo -e "\n DEBUG: Checking PreRequisit Packages and Linux Distribution.........."
function prerequisit_packages(){
    PrerequisitPackages='tar curl unzip wget'
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
echo -e "\n DEBUG: Checking if AWS CLI is installed or not"
AWSCheck=$(command -v aws)
if [[ -z "${AWSCheck}" ]]; then
    echo -e "\n ERROR: AWS CLI is not install in the system"
    echo -e "\n INFO: Installing AWS CLI...."
    echo -e "\n DEBUG: Checking CPU architecture..."
    CPUArchitecture=$(uname -m)
    if [[ "${CPUArchitecture}" -eq x86_64 ]]; then
        echo -e "\n x86_64 cpu architecture......."
        # Downloading AWS binary in tmp folder
        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
        # Extract Zip into opt folder
        unzip /tmp/awscliv2.zip -d /opt > /dev/null
        # Removing zip file
        rm -f /tmp/awscliv2.zip
        # Installing AWS CLI
        /opt/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli
    else
    #     # Downloading AWS binary in tmp folder
        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/tmp/awscliv2.zip"
    #     # Extract Zip into opt folder
        unzip /tmp/awscliv2.zip -d /opt > /dev/null
    #     # Removing zip file
        rm -f /tmp/awscliv2.zip
    #     # Installing AWS CLI
        /opt/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli
    fi       
else
    echo -e "\n INFO: AWS CLI is already install in the system, Skipping Installation"""
fi