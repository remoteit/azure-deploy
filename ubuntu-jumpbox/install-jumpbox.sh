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
sudo apt-get install -y nodejs

#make a directory for the install
#mkdir remoteit-desktop
#cd remoteit-desktop

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
    logger "no hostname to set\n"
    echo "no hostname to set\n"
fi

# insstall desktop
logger "install desktop"
touch /tmp/installdesktop
touch /opt/t
cd /root
sudo wget https://github.com/remoteit/desktop/releases/latest/download/remoteit-desktop-headless.tgz
sudo tar -xvzf remoteit-desktop-headlesss.tgz
sudo mv package /opt/remoteit-desktop-headless
sudo cd /opt/package

# Register User via CLI
logger "Register Device with cli"
touch /tmp/registercli
sudo /usr/local/bin/remoteit login $username $password
#register ssh and jumboxui
sudo /usr/local/bin/remoteit add jumpboxui 29999 -t 7
sudo /usr/local/bin/remoteit add ssh 22 -t 28 

# set it to boot, first build a systemd file for this service

sudo echo '
[Unit]
Description=Remoteit Headless Desktop
After=network.target

[Service]
PIDFile=/tmp/remotit-headless-desktop-99.pid
User=root
Group=root
Restart=always
KillSignal=SIGQUIT
WorkingDirectory=/opt/remoteit-desktop-headless/package
ExecStart=/usr/bin/node /opt/remoteit-desktop-headless/package/build/index.js
StandardOutput=null

[Install]
WantedBy=multi-user.target

' > remoteit-headless-desktop.service

# install it, enable it and activate it
cp remoteit-headless-desktop.service /etc/systemd/system/remoteit-headless-desktop.service
sudo systemctl enable remoteit-headless-desktop.service
sudo systemctl start remoteit-headless-desktop.service

t=$(pwd)
logger $t
# 


