#!/bin/bash



if [ "$1" == "ON" ]; then
varpir="/home/pi/jarvis/plugins/jarvis-plug-PIR/traitementPIR"
varpirconfig="/home/pi/jarvis/plugins/jarvis-plug-PIR/config.sh"
/home/pi/jarvis/jarvis.sh -s "Alarme en marche"
/home/pi/jarvis/jarvis.sh -x "Allume virtuel_sensor"

	
echo "Alarme en marche"
echo "ON" > $varpir/ALARME.txt
return
fi

if [ "$1" == "OFF" ]; then
varpir="/plugins/jarvis-plug-PIR/traitementPIR"
varpirconfig="/plugins/jarvis-plug-PIR/config.sh"
/home/pi/jarvis/jarvis.sh -s "Arrêt de l'alarme"
/home/pi/jarvis/jarvis.sh -x "Eteint virtuel_sensor"

echo "Arrêt de l'alarme"
echo "OFF" > $varpir/ALARME.txt
return
fi

echo " "
echo "usage: Vous pouvez utiliser le détecteur PIR pour une alarme en l'associant à votre domotique."
echo "- 1) Vous devez paramétrer votre centrale d'alarme domotique quand elle est sur on en mettant -- domotic-alarme.sh ON -- et  -- domotic-alarme.sh OFF -- lorsque elle est éteinte."
echo "- 2) Puis vous devez créer un capteur virtuel PIR"
echo " "
echo " "
echo "Le pir enverra au capteur virtuel de votre centrale l'état correspondant"
	
