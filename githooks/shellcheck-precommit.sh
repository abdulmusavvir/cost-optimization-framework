#! /bin/bash
# ------------------------
# SHELLCHECK INSTALLATION
# ------------------------
echo -e "\n INFO: Checking if shellcheck is configured or not............. "
shellcheckVersion=v0.9.0
ShellcheckBinary=$(command -v /tmp/shellcheck-${shellcheckVersion}/shellcheck) > /dev/null 2>&1
if [[ ! -n "${ShellcheckBinary}" ]]; then
    wget -P /tmp/ https://github.com/koalaman/shellcheck/releases/download/${shellcheckVersion}/shellcheck-${shellcheckVersion}.linux.x86_64.tar.xz > /dev/null 2>&1
    tar -xvf /tmp/shellcheck-"${shellcheckVersion}".linux.x86_64.tar.xz  -C /tmp > /dev/null 2>&1
    rm -rf /tmp/shellcheck-${shellcheckVersion}.linux.x86_64.tar.xz
    chmod +x /tmp/shellcheck-${shellcheckVersion}
    echo export PATH=$PATH:/tmp/shellcheck-${shellcheckVersion}/shellcheck >> ~/.bash_profile
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


