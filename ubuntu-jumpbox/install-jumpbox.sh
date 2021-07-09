#!/bin/bash
#
# Headless Desktop for Ubuntu x86_64 with cli registration
#
username=$1
password=$2
hostname=$3

logger "username $username"
#logger "pw $password"
logger "hostname $hostname"

install_node()
{
    local ret=0

  #  if ! dpkg -s nodejs >/dev/null 2>&1; then
        logger "install node.js"
        curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
        apt install -y nodejs
        apt install -y build-essential
  #  else
  #      logger "nodejs already installed\n"           
  #      ret=1
  #  fi
    return $ret
}

#update without prompt
logger "do update"
sudo apt-get -y update
sudo apt-get -y upgrade 
logger "install node.js"
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y build-essential
sleep 1

#make a directory for the install
#mkdir remoteit-desktop
#cd remoteit-desktop

#
logger "try to install node"
if [ install_node ]; then
    logger "node already installed\n"
fi

# get and install Remoteit_CLI
t=$(pwd)
logger "install cli current directory is $t"
wget https://downloads.remote.it/cli/latest/remoteit_linux_x86_64
sudo cp ./remoteit_linux_x86_64 /usr/local/bin/remoteit
sudo chmod +x /usr/local/bin/remoteit

#
# Set hostname if passed
if [ ${#hostname} -ge 1 ]; then 
    # hostname has length, set hostname
    sudo hostnamectl set-hostname $hostname
else
    logger "no hostname to set\n"
    echo "no hostname to set\n"
    hostname=$HOSTNAME
fi

# install desktop
logger "install desktop"
touch /tmp/installdesktop
touch /opt/t
sudo cd /tmp
#sudo wget https://github.com/remoteit/desktop/releases/latest/download/remoteit-desktop-headless.tgz -O /tmp/remoteit-desktop-headless.tgz 
sudo wget https://downloads.remote.it/desktop/latest/remoteit-headless.tgz -O /tmp/remoteit-desktop-headless.tgz 
sudo tar -xvzf /tmp/remoteit-desktop-headless.tgz -C /tmp
sudo mv /tmp/package /opt/remoteit-desktop-headless


# Register User via CLI
logger "Register Device with cli with user $username"
touch /tmp/registercli
#
# install agent
sudo /usr/local/bin/remoteit agent install

#for docker:
#remoteit run -verbose -config /etc/remoteit/config.json &    // for docker

#sudo /usr/local/bin/remoteit login $username $password
sudo /usr/local/bin/remoteit signin -user $username -pass $password
#register ssh and jumboxui
#sudo /usr/local/bin/remoteit setup $hostname
sudo /usr/local/bin/remoteit register -name $hostname
#
# register only jumpbox gui
sudo /usr/local/bin/remoteit add -name jumpboxui  -type 7 -port 29999 -hostname 127.0.0.1
#sudo /usr/local/bin/remoteit add jumpboxui 29999 -t 7
#sudo /usr/local/bin/remoteit add ssh 22 -t 28 

#
# IF not docker install the debian init script

#--------------
# set it to boot, first build a systemd file for this service
logger "build systemd file"
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
WorkingDirectory=/opt/remoteit-desktop-headless
ExecStart=/usr/bin/node /opt/remoteit-desktop-headless/build/index.js
StandardOutput=null

[Install]
WantedBy=multi-user.target

' > remoteit-headless-desktop.service

# install it, enable it and activate it
sudo cp remoteit-headless-desktop.service /etc/systemd/system/remoteit-headless-desktop.service
sudo systemctl enable remoteit-headless-desktop.service
sudo systemctl start remoteit-headless-desktop.service
#-----------

# if docker just startup the headless destkop
#
#cd /opt/remoteit-desktop-headless/
#/usr/bin/node /opt/remoteit-desktop-headless/build/index.js


t=$(pwd)
logger "current directory is $t"
# 


