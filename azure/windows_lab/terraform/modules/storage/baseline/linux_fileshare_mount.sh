#!/bin/sh

# Global Variables
SA_PATH       = "${local.fileshare_path}"
SA_NAME       = "${local.sa_name}"
SA_ACCESS_KEY = "${local.sa_primary_access_key}"
FS_NAME       = "${loca.fileshare_name}"



sudo apt update && sudo apt -y upgrade
sudo apt install cifs-utils -y


sudo mkdir /mnt/${FS_NAME}
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/${SA_NAME}.cred" ]; then
    sudo bash -c 'echo "username=${SA_NAME}" >> /etc/smbcredentials/${SA_NAME}.cred'
    sudo bash -c 'echo "password=${SA_ACCESS_KEY}" >> /etc/smbcredentials/${SA_NAME}.cred'
fi
sudo chmod 600 /etc/smbcredentials/${SA_NAME}.cred

sudo bash -c 'echo "${SA_PATH} /mnt/${FS_NAME} cifs nofail,credentials=/etc/smbcredentials/${SA_NAME}.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs ${SA_PATH} /mnt/${FS_NAME} -o credentials=/etc/smbcredentials/${SA_NAME}.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
