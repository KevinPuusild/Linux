#!/bin/bash

#Puhastan ekraani
clear

#Kontrollin üle uuendused
apt-get update

apt-get upgrade -y


#Paigaldan vajalikud tarkvarad

sudo apt-get install apache2 tftpd-hpa inetutils-inetd -y


#Puhastan ekraani
clear

#Kirjutan konfi lõppu paar rida, kuna käsitsi nikerdada on jama :D

echo "RUN_DAEMON='yes'" >> /etc/default/tfpd-hpa
echo "OPTIONS='-l -s /var/lib/tftpboot'" >> /etc/default/tfpd-hpa

#Puhastan ekraani
clear

#Samuti IT inimene on liiga laisk et kirjutada ise /etc/inetd.conf konfi

echo "tftp	dgram	udp	wait	root	/usr/sbin/in.tftpd /usr/sbin/in.tftpd -s /var/lib/tftpboot" >> /etc/inetd.conf

#Puhastan ekraani
clear

#Teeme teenusele restardi
systemctl restart tftpd-hpa

#Puhastan ekraani
clear

#Vaatan teenuse staatust
systemctl status tftpd-hpa

#Jätan korra skripti seisma et kasutaja saaks näha kas teenus töötab
sleep 10

#Puhastan ekraani
clear

#teeme uue kausta apache root kausta
mkdir /var/www/html/ubuntu

#Laen alla ubuntu ISO
cd /home

wget http://ftp.estpak.ee/pub/ubuntu-releases/18.04/ubuntu-18.04.2-desktop-amd64.iso

mkdir /var/www/html/ubuntu

#Haagime iso faili nüüd külge
mount -o loop ubuntu-18.04.2-desktop-amd64.iso /var/www/html/ubuntu

#Lähme iso faili sisse


cd /var/www/html/ubuntu

#kopeerime netboot kausta
cp -fr install/netboot/* /var/lib/tftpboot/

#Puhastan ekraani
clear


echo "label linux" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "kernel ubuntu-installer/amd64/linux" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "append ks=http://172.16.0.7/ks.cfg vga=normal initrd=ubuntu-installer/amd64/initrd.gz" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "remdisk_size=16432 root=dev/rd/o rw --" >> /var/lib/tftpboot/pxelinux.cfg/default

#Puhastan ekraani
clear





