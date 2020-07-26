# kali-setup
A tool for bootstrapping a kali Hyper-V VM. It is assumed that the recommended kali tools were installed during the OS installation.

## Install
```
git clone https://github.com/mulvicoder/kali-setup
cd kali-setup
sudo ./kali-setup.sh
```

## Features:
The following are installed via the sript:
* **linux-vm-tools** for xrdp integration  
Make sure to also run `Set-VM "Kali VM Name Here" -EnhancedSessionTransportType HVSocket` in an admin PowerShell in the host OS
* **Oh-My-Zsh** to serve as the default terminal
* **VSCode** just for fun. This script only performs a base installation.
* **Atom** for the preferred editor. This script will also install a couple plugins:
    * **atom-ide-ui** for various ide plugins
    * **ide-python** for python scripting. This script will also install the **python-language-server**
    * **ide-c-cpp** for C/C++ programming. This script will also install **CCLS** and **CMake**
    * **pp** and **pp-markdown** for previewing markdown editing.
* **Ghidra** for reverse engineering. This script will also install **default-jdk**
