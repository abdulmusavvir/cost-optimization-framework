#! /bin/bash


# ------------------------
# SHELLCHECK INSTALLATION
# ------------------------
echo -e "\n INFO: Checking if shellcheck is configured or not............. "
shellcheckVersion=v0.9.0
ShellcheckBinary=$(command -v /tmp/shellcheck-${shellcheckVersion}/shellcheck) > /dev/null 2>&1
if [[ -z "${ShellcheckBinary}" ]]; then
    echo -e "\n DEBUG: Installing shellcheck................."
    wget -P /tmp/ https://github.com/koalaman/shellcheck/releases/download/${shellcheckVersion}/shellcheck-${shellcheckVersion}.linux.x86_64.tar.xz > /dev/null 2>&1
    tar -xvf /tmp/shellcheck-"${shellcheckVersion}".linux.x86_64.tar.xz  -C /tmp > /dev/null 2>&1
    rm -rf /tmp/shellcheck-${shellcheckVersion}.linux.x86_64.tar.xz
    chmod +x /tmp/shellcheck-${shellcheckVersion}
    /tmp/shellcheck-${shellcheckVersion}/shellcheck >/dev/null 2>&1
    ShellcheckBinary=$(command -v /tmp/shellcheck-${shellcheckVersion}/shellcheck) > /dev/null 2>&1
    if [[ -n "${ShellcheckBinary}" ]]; then
        echo -e "\n SUCCESS: ShellCheck is successfully installed............"
    else
        echo -e  "\n ERROR: There is some error while installing shellcheck.........."
    fi
else
     ShellcheckBinary=$(command -v /tmp/shellcheck-${shellcheckVersion}/shellcheck) 
     echo -e "\n INFO: Shellcheck is already installed... hence skipping installation................."
fi


# -------------------------------
# Checking stagging file using shellcheck
# -------------------------------

files="$(git diff --staged --name-only | grep -E '.sh$')"
for file in $files;
do 
   if [[ -n $file ]]; then
      ${ShellcheckBinary} ${file} --severity=warning
      if [[ $? -ne 0 ]]; then
         echo -e "\nERROR: shellcheck detected warnings or errors, please see above and fix the issue(s).\n "
         exit 1
      fi
   fi
done
