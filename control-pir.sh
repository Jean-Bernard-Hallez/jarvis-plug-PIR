#!/bin/bash


etat_courant="0"
etat_precedant="0"

echo " Prêt "

while true
do

etat_courant=`gpio read 4`

if [ "$etat_courant" == "1" ] && [ "$etat_precedant" == "0" ]
then
echo " Mouvement détécté "
date=`date +"%Y_%m_%d-%H:%M:%S"`
echo "$date"
/home/pi/jarvis/jarvis.sh -x "mesurepir"
# raspistill -tl 100 -o /home/pi/image_motion/$date%04d.jpg -t 5000 -w 800 -h 600
etat_precedant="1"

elif [ "$etat_courant" == "0" ] && [ "$etat_precedant" == "1" ]
then
echo " Prêt "
etat_precedant="0"
# sleep +180s
# sleep +10s
fi

sleep +0.1s
done
