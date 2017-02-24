#!/bin/sh

MesurePIR() {
lecture=`gpio read 4`

if [[ "$lecture" == "0" ]]; then 
MesurePIR="OFF"
# say "Capteur OFF"
fi
if [[ "$lecture" == "1" ]]; then 
# say "Capteur ON"

MesurePIR="ON"
# Mesure faite à:
PIRHEUREJOUR=`date +%d`
PIRHEUREMOI=`date +%m`
PIRHEUREHEURE=`date +%H`
PIRHEUREMIN=`date +%M`

varpir="$jv_dir/plugins/jarvis-plug-PIR"

	if [ -f "$varpir/mesurepir.txt" ]; then # est-ce que le fichier existe ?
	echo "" > /dev/null
	else
	echo "$PIRHEUREJOUR, $PIRHEUREMOI, $PIRHEUREHEURE, $PIRHEUREMIN" > $varpir/mesurepir.txt 
	fi

# Dernière mesure relevée:
DERPIRHEUREJOUR=`cat $varpir/mesurepir.txt | cut -d',' -f1`
DERPIRHEUREMOI=`cat $varpir/mesurepir.txt | cut -d',' -f2`
DERPIRHEUREHEURE=`cat $varpir/mesurepir.txt | cut -d',' -f3`
DERPIRHEUREMIN=`cat $varpir/mesurepir.txt | cut -d',' -f4`
Traitement_yeux

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------

# Traitement pour : "Prochain évènement" Dire 2 fois dans la journée matin après 8h et après midi après 18h"
Traitement_Prochainevenement

# Traitement pour : "Prochain pour simplement dire bonjour de temps en temps"
Traitement_bonjour

# Traitement pour : "Prochain la matin au réveil météo et la saint"
Traitement_reveil



# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# Fin j'enregistre heure du dernièr PIR à ON
echo "$PIRHEUREJOUR, $PIRHEUREMOI, $PIRHEUREHEURE, $PIRHEUREMIN" > $varpir/mesurepir.txt
Traitement_yeuxFin
fi
}

Traitement_Prochainevenement() {

# Traitement pour : "Prochain évènement" Dire 2 fois dans la journée matin après 8h et après midi après 18h UNIQUEMENT si il y a quelque chose pour le mois en cours

# reponsePIRMAITRE=`jv_handle_order "POURPLUGINPIRESCLAVE"` > /dev/null
reponsePIRMAITRE=`curl -s "http://192.168.0.17:8087?order=POURPLUGINPIRESCLAVE&mute=true"`

if [[ "$reponsePIRMAITRE" =~ "Ok" ]]; then

	if [ -f "$varpir/prochainevenement.txt" ]; then # est-ce que le fichier existe ?

	REPPROCHAIN=`cat $varpir/prochainevenement.txt | cut -d',' -f1`
	REPPROCHAINJOUR=`cat $varpir/prochainevenement.txt | cut -d',' -f2`
	else
	REPPROCHAIN="0"
	REPPROCHAINJOUR="$PIRHEUREJOUR"
	echo "$REPPROCHAIN,$REPPROCHAINJOUR" > $varpir/prochainevenement.txt 
	fi

	
	if [[ "$REPPROCHAINJOUR" != "$PIRHEUREJOUR" ]]; then # est-ce un nouveau jour depuis dernière relevée ?
	REPPROCHAIN="0"
	fi

	if [[ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]]; then

		if [[ "$REPPROCHAIN" = "1" ]]; then 
		return
		else
		jv_handle_order "prochain évènement"
		REPPROCHAIN=$(($REPPROCHAIN + 1))
		echo "$REPPROCHAIN,$REPPROCHAINJOUR" > $varpir/prochainevenement.txt 
		fi
	fi

	if [[ "$DERPIRHEUREHEURE" > "18" ]] && [[ "$DERPIRHEUREHEURE" < "$PIRHFINPARLER" ]]; then
		if [[ "$REPPROCHAIN" = "2" ]]; then 
		return
		else
		jv_handle_order "prochain évènement"
		REPPROCHAIN=$(($REPPROCHAIN + 1))
		echo "$REPPROCHAIN,$REPPROCHAINJOUR" > $varpir/prochainevenement.txt 
		fi
	fi
fi
}

Traitement_bonjour() {
if [[ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]]; then 

citationsPIR=("Super tu es là !" "Je ne t'avais pas vu !" "Et coucou !" "ho" "En forme !" "coucou !" "je t'aime !")
citationsPIR1=`echo "${citationsPIR[$RANDOM % ${#citationsPIR[@]} ]}"`
say "$citationsPIR1"
fi
}

Traitement_reveil() {
if [[ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]]; then 
	if [ -f "$varpir/reveil.txt" ]; then # est-ce que le fichier existe ?

	REPPROCHAINREV=`cat $varpir/reveil.txt | cut -d',' -f1`
	REPPROCHAINJOURREV=`cat $varpir/reveil.txt | cut -d',' -f2`
	else
	REPPROCHAINREV="0"
	REPPROCHAINJOURREV="$PIRHEUREJOUR"
	echo "$REPPROCHAINREV,$REPPROCHAINJOURREV" > $varpir/reveil.txt 
	fi

	if [[ "$REPPROCHAINJOUR" != "$PIRHEUREJOUR" ]]; then # est-ce un nouveau jour depuis dernière relevée ?
	REPPROCHAIN="0"
	fi


	if [[ "$REPPROCHAINREV" = "1" ]]; then 
	return
	else
	say "C'est bien on se reveil !"
	jv_handle_order $PIRDIREREVEIL 
	say "Voilà bonne journée tout le monde"
	REPPROCHAINREV=$(($REPPROCHAINREV+ 1))
	echo "$REPPROCHAINREV,$REPPROCHAINJOURREV" > $varpir/reveil.txt 
	fi

fi
}



Traitement_yeux() {
$PIRNEZ 1; $PIROEILDROIT 1; $PIROEILGAUCHE 1
if [[ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]] && [[ "$DERPIRHEUREHEURE" < "$PIRHFINPARLER" ]]; then 

clignotementled=$((1 + RANDOM%(6-1+1)))
clignotementled1=$((1 + RANDOM%(6-1+1)))

citationsLED=("$PIRNEZ 0; sleep 0.$clignotementled; $PIRNEZ 1" "$PIROEILDROIT 0; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILGAUCHE 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; sleep 0.$clignotementled1; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1")
citationsLED1=`echo "${citationsLED[$RANDOM % ${#citationsLED[@]} ]}"`
eval $citationsLED1
fi
}

Traitement_yeuxFin() {
$PIROEILDROIT 0; $PIROEILGAUCHE 0
}