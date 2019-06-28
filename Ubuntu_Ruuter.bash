#Ruuteri skript
#Eeldus: Masinal on 2 võrgukaarti

#!/bin/bash

# Puhsatame ekraani
clear

# Lisame paketide edastamise rea veel juurde süsteemi konfiguratsiooni
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Tühjenda marsruutimisjärgne ahel
sudo iptables -t nat -F POSTROUTING

#Puhastame ekraani enne küsimuse küsimist
clear

# Küsime kasutajalt välise võrguliidese nime
echo "Palun sisesta välise võrguliidese nimi: "
echo "Näiteks: eth0"
read VALINE

# WAN liideselt väljuvate pakettide lähte IP-aadressiks saab WAN-liidese IP-aadress
sudo iptables -t nat -A POSTROUTING -o $VALINE -j MASQUERADE

# Tühjenda edastamise ahel
sudo iptables -F FORWARD

# Puhastame ekraani enne küsimuse küsimist
clear

# Küsime kasuajalt sise võrguliidese nime
echo "Palun sisesta sise võrguliidese nimi: "
echo "Näiteks: eth1"
read SISENE

# Puhastame ekraani enne küsimuse küsimist
clear

# Küsime kasutajalt ruuteri võrguaadress"
echo "Palun sisesta v'rgu aadress koos subnetmaskiga "
echo "Näiteks: 192.168.3.0/24"
read VORK

# Luba ühendused LAN võrgust WAN võrku
sudo iptables -A FORWARD -o $VALINE -i $SISENE -s $VORK -m conntrack --ctstate NEW -j ACCEPT

# Luba eelnevalt loodud ühenduste sihtkohast tagasi tulevad paketid
sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Lükka tagasi kõik paketid eelnevatele tingimustele mittevastavad paketid
sudo iptables -A FORWARD -j REJECT

#Puhastame ekraani peale lõpetust
clear

echo "Defauldis on kõik pordid kinni keeratud"
echo "Kui soovite porte avada siis tehke seda IPTABLES abiga"
