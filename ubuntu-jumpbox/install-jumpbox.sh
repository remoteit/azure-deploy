#!/bin/bash
#
# Headless Desktop for Ubuntu with cli registration
#
username=$1
password=$2
hostname=$3

install_node()
{
    local ret=0

    if ! dpkg -s nodejs >/dev/null 2>&1; then
        curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
        sudo apt-get install -y nodejs
        sudo apt-get install -y build-essential
    else
        echo "nodejs already installed\n"           
        ret=1
    fi
    return $ret
}

#update without prompt
sudo apt-get -y update
sudo apt-get -y upgrade 

#make a directory for the install
mkdir remoteit-desktop
cd remoteit-desktop

#
if [ !install_node ]; then
    echo "node already installed\n"
fi

# get and install Remoteit_CLI
wget https://github.com/remoteit/cli/releases/latest/download/remoteit_linux_x86_64
sudo cp ./remoteit_linux_x86_64 /usr/local/bin/remoteit
sudo chmod +x /usr/local/bin/remoteit

#
# Set hostname if passed
if [ ${#hosthane} -ge 1 ]; then 
    # hostname has length, set hostname
    sudo hostnamectl set-hostname $hostname
else
    echo "no hostname to set\n"
fi

# Register User via CLI
sudo remoteit login $username $password
#register ssh and jumboxui
sudo remoteit add jumpboxui 29999 -t 7
sudo remoteit add ssh 22 -t 28 

# insdtall desktop
wget https://github.com/remoteit/desktop/releases/latest/download/remoteit-desktop-headless.tgz
tar -xvzf remoteit-desktop-headless.tgz
cd package


# set it to boot
cp remoteit-headless-desktop.service /etc/systemd/system/remoteit-headless-desktop.service
sudo systemctl enable remoteit-headless-desktop.service

# 

