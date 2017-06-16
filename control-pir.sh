#!/bin/bash

RELANCEPIR=`ps -aux | grep control-pir_ok.sh | wc -l`
# if [[ "$RELANCEPIR" -ge 2 ]]; then 
if [[ "$RELANCEPIR" -ge 1 ]]; then 
echo "Fonctionne déja en fond de tâche..."
killall control-pir_ok.sh; 
sleep 5
fi
/home/pi/jarvis/plugins_installed/jarvis-plug-PIR/control-pir_ok.sh &




