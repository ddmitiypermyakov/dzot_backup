#!/bin/bash

timedatectl set-timezone Europe/Minsk
#update system
apt-get update -y
apt-get upgrade -y
apt-get install -y ansible

apt install borgbackup

#create user and passwd
useradd -m -p `openssl passwd -1 -salt xyz borg` borg

mkdir /var/backup
chown borg:borg /var/backup/


su - borg
mkdir .ssh
touch .ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
