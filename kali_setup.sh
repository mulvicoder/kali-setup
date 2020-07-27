#!/bin/bash

if [ "$EUID" -eq 0  ]
    then {
        echo "Do not run this script with \"sudo\""
        exit 0
    }
fi

# Install linux-vm-tools
if [ -f /usr/sbin/xrdp ]
    then echo "xrdp has been installed already. Skipping..."
fi

if [ ! -f /usr/sbin/xrdp ]
    then {
        echo "Cloning linux-vm-tools"
        git clone https://github.com/mimura1133/linux-vm-tools
        echo "Changing permissions on install.sh"
        chmod 555 linux-vm-tools/kali/2020.x/install.sh

        echo "Installing linux-vm-tools"
        ./linux-vm-tools/kali/2020.x/install.sh
    }
fi

# Install Oh-My-Zsh

echo "Installing Oh-My-Zsh"
sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Atom
if [ -f /usr/bin/atom ]
    then echo "Atom was already installed. Skipping..."
fi

if [ ! -f /usr/bin/atom ]
    then {
        echo "installing Atom"
        wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
        sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
        sudo apt-get update && sudo apt-get install atom -y
        test -e /usr/bin/atom && {
            cat atom-config.cson > /home/$USER/.atom/config.cson
            echo "...done"
            echo "Installing Atom plugin: atom-ide-ui"
            apm install atom-ide-ui
            echo "...done"

            echo "Installing Python Language Server"
            sudo apt-get install -y python-pip python3-pip
            echo "export PATH=\"/home/deadbeef/.local/bin:\$PATH\"" >> .zshrc
            export PATH="/home/deadbeef/.local/bin:$PATH"
            echo "...done"

            echo "Installing Atom plugin: ide-python"
            apm install ide-python
            echo "...done"

            echo "Intsalling CMake"
            sudo apt-get install cmake -y
            echo "...done"

            echo "Installing CCLS"
            sudo apt-get install ccls
            echo "...done"

            echo "Installing Atom plugin: ide-c-cpp"
            apm install  ide-c-cpp
            echo "...done"

            echo "Installing Atom plugin: pp and pp-markdown"
            apm install pp
            apm install pp-markdown
            echo "...done"
        } || echo "Atom did not install"
    }
fi

echo "Installing Ghidra"

echo "First the JDK..."
apt install default-jdk -y

echo "Now Ghidra..."

if [ -f /usr/bin/ghidra ]
    then echo "Ghidra was already installed. Skipping..."
fi

if [ ! -f /usr/bin/ghidra ]
    then {
        export GHIDRA=`wget -qO - https://www.ghidra-sre.org | grep 'Download Ghidra' | sed 's/.*href=.//' | sed 's/".*//'`
        if [ -z "$GHIDRA" ]
            then echo "Error: could not find ghidra to download"
        fi

        if [ ! -z "$GHIDRA" ]
            then {
                export GHIDRADIR=`echo $GHIDRA | sed 's/_20[12][0-9].*//'`
                wget -c https://www.ghidra-sre.org/$GHIDRA
                unzip "$GHIDRA" > /dev/null
                sudo mv $GHIDRADIR /usr/lib/ghidra
                ln -s -T /usr/lib/ghidra/ghidraRun /usr/bin/ghidra
                rm $GHIDRA
                echo "...done"
            }
        fi
    }
fi
