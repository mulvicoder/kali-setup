#!/bin/bash

if [ "$EUID" -ne 0  ]
    then echo "What the hell are you doing?? Run this script with \"sudo\", you fool!"
    exit
fi

# Install linux-vm-tools

echo "Cloning linux-vm-tools"
git clone https://github.com/mimura1133/linux-vm-tools

echo "Changing permissions on install.sh"
chmod 555 linux-vm-tools/kali/2020.x/install.sh

echo "Installing linux-vm-tools"
./linux-vm-tools/kali/2020.x/install.sh

# Install Oh-My-Zsh

echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install VS Code

echo "installing VS Code"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

apt install apt-transport-https -y
apt install code -y
echo "...done"

# Install Atom

echo "installing Atom"
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
apt install atom -y
cat atom-config.cson > ~/.atom/config.cson
echo "...done"

echo "Installing Atom plugin: atom-ide-ui"
apm install atom-ide-ui
echo "...done"

echo "Installing Python Language Server"
apt install python-pip python3-pip
echo "export PATH=\"/home/deadbeef/.local/bin:\$PATH\"" >> .zshrc
export PATH="/home/deadbeef/.local/bin:$PATH"
echo "...done"

echo "Installing Atom plugin: ide-python"
apm install python-ide
echo "...done"

echo "Intsalling CMake"
apt install cmake -y
echo "...done"

echo "Installing CCLS"
apt install ccls
echo "...done"

echo "Installing Atom plugin: ide-c-cpp"
apm install c-cpp-ide
echo "...done"

echo "Installing Atom plugin: pp and pp-markdown"
apm install pp
apm install pp-markdown
echo "...done"

echo "Installing Ghidra"

echo "First the JDK..."
apt install default-jdk -y

echo "Now Ghidra..."
export GHIDRA=`wget -qO - https://www.ghidra-sre.org | grep 'Download Ghidra' | sed 's/.*href=.//' | sed 's/".*//'`
test -z "$GHIDRA" && { echo Error: could not find ghidra to download ; exit 0 ;}
export GHIDRADIR=`echo $GHIDRA | sed 's/_20[12][0-9].*//'`
wget -c https://www.ghidra-sre.org/$GHIDRA
unzip "$GHIDRA" > /dev/null
mv $GHIDRADIR /usr/lib/ghidra
ln -s -T /usr/lib/ghidra/ghidraRun /usr/bin/ghidra
rm $GHIDRA
echo "...done"
