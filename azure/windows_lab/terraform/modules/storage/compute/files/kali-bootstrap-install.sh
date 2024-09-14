#!/usr/bin/env bash

sudo apt-get update
echo "[i] Installing Xfce4 & xrdp (this will take a while as well)"
sudo apt-get --yes install kali-desktop-xfce xorg xrdp
sudo sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce-session \n' /etc/xrdp/startwm.sh
sudo passwd kali <<<<INSERT-PASSWORD>>>
sudo systemctl enable xrdp
sudo systemctl start xrdp xrdp-sesman
sudo apt-get -y install waagent



#sudo DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
#sudo apt-get -y install xfce4-session
#sudo apt-get -y install kali-desktop-xfce
#sudo systemctl enable xrdp
#sudo systemctl start xrdp
#echo xfce4-session >~/.xsession
#sudo systemctl restart xrdp

### create user: sudo useradd azureuser --home /home/azureuser

#sudo apt-get install -y mate-core mate-desktop-environment mate-notification-daemon xrdp

#sed -i.bak '/fi/a #xrdp multiple users configuration \n mate-session \n' /etc/xrdp/startwm.sh
#sudo sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce-session \n' /etc/xrdp/startwm.sh

#!/bin/bash
#echo "[i] Updating and upgrading Kali (this will take a while)"
#apt-get update
#apt-get --yes --force-yes dist-upgrade

#echo "[i] Installing Xfce4 & xrdp (this will take a while as well)"
#sudo apt-get --yes install kali-desktop-xfce xorg xrdp

#echo "[i] Configuring xrdp to listen to port 3390 (but not starting the service)"
#sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini
