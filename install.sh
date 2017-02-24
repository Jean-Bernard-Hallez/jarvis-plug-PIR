#!/bin/bash
# Use only if you need to perform changes on the user system such as installing software

crontab -l > $tmpfile # export de la crontab
echo -e '*/5 8-21 * * 1-5 ~/jarvis/jarvis.sh -x "mesurepir"' >> $tmpfile  /dev/null
crontab $tmpfile /dev/null # import de la crontab
rm $tmpfile /dev/null # le fichier temporaire ne sert plus à rien
