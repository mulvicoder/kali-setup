#!/bin/bash

if [ "$EUID" -ne 0  ]
    then {
        echo "What the hell are you doing?? Run this script with \"sudo\", you fool!"
        exit 0
    }
fi

# Install linux-vm-tools
if [ ! -e /usr/sbin/xrdp ]
    then {
        echo "Cloning linux-vm-tools"
        git clone -q https://github.com/mimura1133/linux-vm-tools
        echo "Changing permissions on install.sh"
        chmod 555 linux-vm-tools/kali/2020.x/install.sh

        echo "Installing linux-vm-tools"
        ./linux-vm-tools/kali/2020.x/install.sh > /dev/null
    }
fi

if [-e /usr/sbin/xrdp]
    then echo "xrdp has been installed already. Skipping..."
fi

# Install Oh-My-Zsh

echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null

# Install Atom
if [ ! -e /usr/bin/atom ]
    then {
        echo "installing Atom"
        wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add -
        sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
        apt update -q && apt install atom -yq
        test -e /usr/bin/atom && {
            cat atom-config.cson > ~/.atom/config.cson
            echo "...done"
            echo "Installing Atom plugin: atom-ide-ui"
            apm install -q atom-ide-ui
            echo "...done"

            echo "Installing Python Language Server"
            apt install -q python-pip python3-pip
            echo "export PATH=\"/home/deadbeef/.local/bin:\$PATH\"" >> .zshrc
            export PATH="/home/deadbeef/.local/bin:$PATH"
            echo "...done"

            echo "Installing Atom plugin: ide-python"
            apm install -q python-ide
            echo "...done"

            echo "Intsalling CMake"
            apt install -q cmake -y
            echo "...done"

            echo "Installing CCLS"
            apt install -q ccls
            echo "...done"

            echo "Installing Atom plugin: ide-c-cpp"
            apm install -q c-cpp-ide
            echo "...done"

            echo "Installing Atom plugin: pp and pp-markdown"
            apm install pp
            apm install -q pp-markdown
            echo "...done"
        } || echo "Atom did not install"
    }
fi

if [ -e /usr/bin/atom ]
    echo "Atom was already installed. Skipping..."
fi

echo "Installing Ghidra"

echo "First the JDK..."
apt install default-jdk -y

echo "Now Ghidra..."
if [ ! -e /usr/bin/ghidra ]
    then {
        export GHIDRA=`wget -qO - https://www.ghidra-sre.org | grep 'Download Ghidra' | sed 's/.*href=.//' | sed 's/".*//'`
        if [ -z "$GHIDRA" ]
            then echo "Error: could not find ghidra to download"
        fi

        if [ ! -z "$GHIDRA"]
            then {
                export GHIDRADIR=`echo $GHIDRA | sed 's/_20[12][0-9].*//'`
                wget -c https://www.ghidra-sre.org/$GHIDRA
                unzip "$GHIDRA" > /dev/null
                mv $GHIDRADIR /usr/lib/ghidra
                ln -s -T /usr/lib/ghidra/ghidraRun /usr/bin/ghidra
                rm $GHIDRA
                echo "...done"
            }
        fi
    }
fi

if [ -e /usr/bin/ghidra ]
    then echo "Ghidra was already installed. Skipping..."
fi
