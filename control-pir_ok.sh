#!/bin/bash

varpirconfigdodo="/home/pi/jarvis/plugins_installed/jarvis-plug-PIR/pause_onOUoff.txt"
varpirretourconsole="/home/pi/jarvis/plugins_installed/jarvis-plug-PIR/PIRRETOURCONSOLE.txt"

if test -d "$varpirretourconsole"; then 
PIRRETOURCONSOLE=`cat $varpirretourconsole`
else
echo "ON" > $varpirretourconsole
PIRRETOURCONSOLE="ON"
fi

if test -d "$varpirconfigdodo"; then 
MesurePIR_reveil=`cat $varpirconfigdodo`
else
MesurePIR_reveil="ON"
echo "ON" > $varpirconfigdodo
fi

if [[ "$MesurePIR_reveil" == "ON" ]]; then
# if test -z "$MesurePIR_reveil"; then 

etat_courant="0"
etat_precedant="0"
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
echo " Prêt "
fi

while true
do

etat_courant=`gpio read 4`

if [ "$etat_courant" == "1" ] && [ "$etat_precedant" == "0" ]
then
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
echo " Mouvement détécté "
fi
date=`date +"%Y_%m_%d-%H:%M:%S"`
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
echo "$date"
fi

# /home/pi/jarvis/jarvis.sh -x "mesurepir"
jarvis -x "mesurepir"

# raspistill -tl 100 -o /home/pi/image_motion/$date%04d.jpg -t 5000 -w 800 -h 600
etat_precedant="1"

elif [ "$etat_courant" == "0" ] && [ "$etat_precedant" == "1" ]
then
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
echo " Prêt "
fi
etat_precedant="0"
# sleep +180s
# sleep +10s
fi

sleep +0.1s
done
fi