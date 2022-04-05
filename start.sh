#!/bin/sh
###
### Crée par ElKaBeX-0311
### Date: 05/04/2022
###

while :
do

echo -e "\n"
echo -e "\e[95mPrograme de supervision\e[0m"

name=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.2.1.1.5.0`
echo -e "\e[1mNom du PC:" "\e[93m$name"
echo -e "\n"

echo -e "\e[36m*********\e[0m\e[93mMEMOIRE\e[36m********\e[0m"
memtotal=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.4.5`
mem1=$(($memtotal/1024))
echo -e "\e[1mRAM Total :" "\e[96m$memtotal\e[97m Mo\e[0m"
memlibre=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.4.11`
memuse=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.4.12`
mem2=$(($memlibre/1024))
mem3=$(($memuse/1024))
mem6=$(($memlibre+$memuse))
mem4=$(($memtotal-$mem6))
echo -e "\e[1mRAM Utilisée :" "\e[96m$mem4\e[97m Mo ""\e[92m [■■■■■■■■■■■■■ ]94%\e[0m"
echo -e "\e[1mRAM Disponible :" "\e[96m$memlibre\e[97m Mo ""\e[92m[■             ]6%\e[0m"
echo -e "\e[36m************************\e[0m"

memlibremo=$(($memlibre/1024))
if [ $memlibremo -lt 25 ]
  then
    echo -e "\e[5mALERTE RAM !!\e[25m"
    echo -e "\e[91mIl reste moin de 26 Mo de disponible\e[0m"
  else
    echo -e "\e[92mIl reste" $memlibremo "Mo de disponible\e[0m"
fi

echo -e "\n"
echo -e "\e[36m**********\e[0m\e[93mETAT\e[36m**********\e[0m"
status=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.2.1.2.1`
echo -e "\e[1mETAT de la machine :" "\e[92m$status\e[0m"
echo -e "\e[36m************************\e[0m"
echo -e "\e[91m1\e[0m = \e[91mOFF"
echo -e "\e[92m2\e[0m = \e[92mON"


echo -e "\n"
echo -e "\e[36m***********\e[0m\e[93mCPU\e[36m***********\e[0m"
cpu1=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.11.50.0`
cpu2=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.11.51.0`
cpu3=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.11.52.0`
cpu4=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.11.53`
u1=$(($cpu1+$cpu2+$cpu3))
u2=$(($u1+$cpu4))
u3=$((($u1/$u2)*100))
echo -e "\e[1mCPU Utilisation :" "\e[96m$u3\e[97m%\e[0m"
echo -e "\e[36m*************************\e[0m"

echo -e "\n"
echo -e "\e[36m***********\e[0m\e[93mHDD\e[36m***********\e[0m"
usehdd=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.4.1.2021.4.4.0`
es1=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.2.1.25.2.3.1.5.1`
hdd1=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.2.1.25.2.3.1.4.1`
hdd2=`snmpwalk -v1 <IP_DE_LA_MACHINE_A_SUPERVISER> -OvQ -c <NOM_DE_COMUNAUTÉ> .1.3.6.1.2.1.25.2.3.1.6.1`

hdd3=$(($hdd1*$hdd2))
hdd=$(($hdd3/1073741824))
es2=$(($es1*4096))
es=$(($es2/1073741824))
esd=$(($es-$hdd))

echo -e "\e[1mUtilisation :" "\e[96m$usehdd\e[97m%\e[0m"
echo -e "\e[1mEspace Total :" "\e[96m$es\e[97m GO\e[0m"
echo -e "\e[1mEspace Utilisé :" "\e[96m$hdd\e[97m GO\e[0m"
echo -e "\e[1mEspace Disponible :" "\e[96m$esd\e[97m GO\e[0m"
echo -e "\e[36m*************************\e[0m"
echo -e "\n"

. $(dirname $0)/progress.sh

max=60
for loading_symbol in "\e[92m■"; do

  shload_setup $max $loading_symbol

  compteur=0
  while [ $compteur -lt $max ]; do
    sleep .1
    compteur=$(($compteur + 1))
    shload_update $compteur
done
max=$((max * 5))
clear
done
done
