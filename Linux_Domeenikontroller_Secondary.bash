!/bin/bash

#Alustan DC2 paigaldust
clear

#Vaatan üle uuendused
apt-get update
apt-get upgrade -y

#Puhastan ekraani
clear

#Küsin kasutajalt domeeni täis nime
echo "Palun sisesta DOMEENI nimi"
read $DOMEEN

#Puhastan ekraani
clear

#Paigaldan paketid
apt-get install samba samba-vfs-modules krb5-user libsasl2-modules-gssapi-mit -y

#Kustutan samba konfi
rm -fv /etc/samba/smb.conf

#Ühinen domeeni

samba-tool domain join kevin.lab DC -Uadministrator --realm=$DOMEEN