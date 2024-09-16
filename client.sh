#!/bin/bash

 timedatectl set-timezone Europe/Minsk
#update system
apt-get update -y
apt-get upgrade -y

apt install borgbackup

ssh-keygen
#Инициализируем репозиторий borg на backup сервере с client сервера:

borg init --encryption=repokey borg@192.168.11.160:/var/backup/


#првоерка создания бекапа

borg create --stats --list borg@192.168.11.160:/var/backup/::"etc-{now:%Y-%m-%d_%H:%M:%S}" /etc
#Смотрим результат
borg list borg@192.168.11.160:/var/backup/
#проверка
borg list borg@192.168.11.160:/var/backup/::etc-2024-09-16_21:22:26
#Извлекаем

borg extract borg@192.168.11.160:/var/backup/::etc-2024-09-16_21:22:26 etc/hostname
#бекап каждые 5 мин
cp /vagrant/borg-backup.service /etc/systemd/system/borg-backup.service
cp /vagrant/borg-backup.timer /etc/systemd/system/borg-backup.timer

# Включаем и запускаем службу таймера
systemctl enable borg-backup.timer 
systemctl start borg-backup.timer


systemctl list-timers --all |grep borg 

#Tue 2024-09-17 01:37:07 +03 4min 33s left       Tue 2024-09-17 01:32:07 +03 26s ago      #borg-backup.timer 
#borg-backup.service