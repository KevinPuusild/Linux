#!/bin/bash

#Skripti on katsetatud Ubuntu 16.04 peal

#Puhastan ekraani
clear

echo "Soovid skripti käivitada?(jah/ei)"
read input
if [ "$input" == "jah" ]
then

#Annan teada et paigaldan domeenikontrollerit
echo "Alustan Domeenikontrolleri paigaldamist"
sleep 5

#Teen ära uuendused, ilma et mingit pikka joru peaks tulema

apt-get update
apt-get upgrade -y 

#alustan IF lause sees paketide paigaldust
apt-get install samba samba-vfs-modules krb5-user -y

#Puhastan ekraani
clear

#Kustutan ära samba konfiguratsiooni
rm -fv /etc/samba/smb.conf

#Puhastan ekraani
clear

#Küsin kasutajatelt muutujate inpute 
echo "Palun sisesta REALMI nimi"
read $REALM

#Puhastan ekraani
clear

#Muud muutujad mida saab võtta ise masinast

DOMEEN=${REALM:-4}

HOST=hostname

#Puhastan ekraani
clear

#Paigaldame uue samba konfiguratsiooni
samba-tool domain provision \
    --use-rfc2307 \
    --server-role=dc \
    --domain=$DOMEEN \
    --realm=$REALM \
    --host-name=$HOST
	
#Kustutab nüüd ära krb5 konfiguratsiooni ja toob uue asemele

rm -fv /etc/krb5.conf
ln -s /var/lib/samba/private/krb5.conf /etc/krb5.conf

#Puhastan ekraani
clear

#Seadistame domeeni administraatorile nüüd uue parooli
samba-tool user setpassword administrator

#Seadistame nii et domeeni administraatoril ei aegu parooli
samba-tool domain passwordsettings set --max-pwd-age=0
samba-tool domain passwordsettings set --min-pwd-age=0

service smbd stop
service nmbd stop
service samba-ad-dc stop
service samba-ad-dc start

#Puhastan ekraani
clear

echo "Domeenikontroller on paigadatud, palun oota"
sleep 10

fi
