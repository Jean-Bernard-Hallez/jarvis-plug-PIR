#!/bin/sh

MesurePIR() {
gpio mode 4 in
# lecture=`gpio read 4`

if [[ `gpio read 4` == 1 ]]; then
MesurePIR="ON"
else
MesurePIR="OFF"
fi

# say "mesure sur $MesurePIR"


if [[ "$MesurePIR" == "OFF" ]]; then 
MesurePIR="OFF"
# say "Capteur OFF"
	varpir="$jv_dir/plugins/jarvis-plug-PIR"
	if [ -f "$varpir/mesurepir.txt" ]; then # Si le fichier existe ? Remise à 0 du compteur si 2 fois Off
	DERPIR_NBREFOIS_LAOUPAS=`cat $varpir/mesurepir.txt | cut -d',' -f5`
	DERPIR_NBREFOIS_ONOFF=`cat $varpir/mesurepir.txt | cut -d',' -f6`
		if [[ "$DERPIR_NBREFOIS_ONOFF" == "ON" ]]; then
		PIRHEUREJOUR=`date +%d`
		PIRHEUREMOI=`date +%m`
		PIRHEUREHEURE=`date +%H`
		PIRHEUREMIN=`date +%M`
		PIR_NBREFOIS_LAOUPAS="0"
		echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR" > $varpir/mesurepir.txt
		fi
	fi
fi



if [[ "$MesurePIR" == "ON" ]]; then 
# say "Capteur ON"
MesurePIR="ON"

Traitement_CalculDiffernceHetPIR # traitement des variables relevées
Traitement_yeux

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------

if [ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]; then

# PIRtraitementpour="reveil"
# PIRDIRE_DEBUT="C'est bien on se reveil !"
# PIRDIRE_ORDER="météo puis fête à qui puis une citation" # Que doit t-il énoncé au réveil du matin ?
# PIRDIRE_FIN="Voilà bonne journée tout le monde"

varpir="$jv_dir/plugins/jarvis-plug-PIR"

PIRCONFIGAUTOTAL=$(grep -c 'PIR_DIRE_ORDER=' $varpir/config.sh)
PIRCONFIGAUTOTAL=$(($PIRCONFIGAUTOTAL + 1 ))
ProgrammePIRNum="1"
while test $ProgrammePIRNum != $PIRCONFIGAUTOTAL
do

PIRtraitementpour=$(grep 'PIR_traitement_pour=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_traitement_pour=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
PIRDIRE_ORDER=$(grep 'PIR_DIRE_ORDER=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_ORDER=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
PIRDIRE_DEBUT=$(grep 'PIR_DIRE_DEBUT=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_DEBUT=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
PIRDIRE_FIN=$(grep 'PIR_DIRE_FIN=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_FIN=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
ProgrammePIRNum=$(($ProgrammePIRNum + 1))

pirrelevedonne_fichierexiste # est-ce que le fichier existe ?

if [[ "$REP_PROCHAIN_1OU0" = "0" ]]; then 
pirrelevedonne_Go # Première fois donc je lis
fi

# #####   echo "j'ai traité $PIRDIRE_ORDER"
done


# Traitement pour : "Prochain pour simplement dire bonjour de temps en temps"
Traitement_bonjour

# Traitement pour : "Prochain la matin au réveil météo et la saint"
# Traitement pour : "Prochain évènement" Dire 2 fois dans la journée matin après 8h et après midi après 18h"
#  ###### a revoir celui ci !!!! Traitement_Prochainevenement


# Traitement pour : "Dire si JB est souvent devant son pc ou pas"
Traitement_Tuessouventlaoupas

fi
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# Fin j'enregistre heure du dernièr PIR à ON
echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR" > $varpir/mesurepir.txt
Traitement_yeuxFin
fi
}

# ----------------------------------------------------------------------------------------------------------
Traitement_bonjour() {
if [[ "$DERPIRHEUREHEURE" -ge "$PIRHDEBUTPARLER" ]]; then 
citationsPIR=("Super tu es là ? ! ..." "Je ne t'avais pas vu ? ! ..." "Et coucou ? ! ..." "ho" "En forme ? ! ..." "cou cou ? !" "je t'ai me ? ! ..." "hein  ? ! ..." "Hello  ?! ..." "Hummm ? ! ...")
citationsPIR1=`echo "${citationsPIR[$RANDOM % ${#citationsPIR[@]} ]}"`
say "$citationsPIR1"
fi
}

# ----------------------------------------------------------------------------------------------------------

pirrelevedonne_fichierexiste() {
# 1) est-ce que le fichier existe ?
if [ -f "$varpir/$PIRtraitementpour.txt" ]; then
REP_PROCHAIN_1OU0=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f1`     # 1=Fait  ou 0=Pas encore
REP_PROCHAIN_JOUR=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f2` # Jour ou c'est fait
else
REP_PROCHAINJOURL="$PIRHEUREJOUR"
echo "$REP_PROCHAIN_1OU0,$REP_PROCHAIN_JOUR" > $varpir/$PIRtraitementpour.txt 
fi

# est-ce un nouveau jour depuis dernière relevée ?
if [[ "$REP_PROCHAIN_JOUR" != "$PIRHEUREJOUR" ]]; then # est-ce un nouveau jour depuis dernière relevée ?
REP_PROCHAIN_1OU0="0"
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR" > $varpir/$PIRtraitementpour.txt 
fi
}

pirrelevedonne_Go() {
# Nouveau a faire si condition réuni
say "$PIRDIREL_DEBUT"
jv_handle_order $PIRDIRE_ORDER 
say "$PIRDIRE_FIN"
REP_PROCHAIN_1OU0=$(($REP_PROCHAIN_1OU0 + 1))
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR" > $varpir/$PIRtraitementpour.txt 
}


# ----------------------------------------------------------------------------------------------------------
Traitement_Prochainevenement() {

# Traitement pour : "Prochain évènement" Dire 2 fois dans la journée matin après 8h et après midi après 18h UNIQUEMENT si il y a quelque chose pour le mois en cours

reponsePIRMAITRE=`curl -s "http://192.168.0.17:8087?order=POURPLUGINPIRESCLAVE&mute=true"`

if [[ "$reponsePIRMAITRE" =~ "1" ]]; then

	if [ -f "$varpir/prochainevenement.txt" ]; then # est-ce que le fichier existe ?

	REP_PROCHAIN_EVENEMENT=`cat $varpir/prochainevenement.txt | cut -d',' -f1`
	REP_PROCHAINJOUR_EVENEMENT=`cat $varpir/prochainevenement.txt | cut -d',' -f2`
	else
	REP_PROCHAINJOUR_EVENEMENT="$PIRHEUREJOUR"
	echo "$REP_PROCHAIN_EVENEMENT,$REP_PROCHAINJOUR_EVENEMENT" > $varpir/prochainevenement.txt 
	fi

	if [[ "$REP_PROCHAINJOUR_EVENEMENT" != "$PIRHEUREJOUR" ]]; then # est-ce un nouveau jour depuis dernière relevée ?
	REP_PROCHAIN_EVENEMENT="0"
	fi

	if [ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]; then

		if [[ "$REP_PROCHAIN_EVENEMENT" = "1" ]]; then 
		return
		else
		jv_handle_order "prochain évènement"
		REP_PROCHAIN_EVENEMENT=$(($REP_PROCHAIN_EVENEMENT + 1))
		echo "$REP_PROCHAIN_EVENEMENT,$PIRHEUREJOUR" > $varpir/prochainevenement.txt 
		fi
	fi

	if [[ "$DERPIRHEUREHEURE" > "18" ]] && [[ "$DERPIRHEUREHEURE" < "$PIRHFINPARLER" ]]; then
		if [[ "$REP_PROCHAIN_EVENEMENT" = "2" ]]; then 
		return
		else
# Nouveau a faire si condition réuni
jv_handle_order "prochain évènement"
REP_PROCHAIN_EVENEMENT=$(($REP_PROCHAIN_EVENEMENT + 1))
# fin de condition nouvelle
		echo "$REP_PROCHAIN_EVENEMENT,$PIRHEUREJOUR" > $varpir/prochainevenement.txt 
		fi
	fi
fi
}


#-------------------------------------------------------------------------------------------------------------

Traitement_Tuessouventlaoupas() {
	if [ -f "$varpir/laoupas.txt" ]; then # est-ce que le fichier existe ?
	REP_PROCHAIN_LAOUPAS=`cat $varpir/laoupas.txt | cut -d',' -f1`     # 1=Fait  ou 0=Pas encore
	REP_PROCHAINJOUR_LAOUPAS=`cat $varpir/laoupas.txt | cut -d',' -f2` # Jour ou c'est fait
	REP_NBREFOIS_LAOUPAS=`cat $varpir/laoupas.txt | cut -d',' -f3` # Nbr de répetition dans le jour
	REP_PHRASENUM=`cat $varpir/laoupas.txt | cut -d',' -f4` # Pharse à dire en fonction du nombre de répétition
	else
	REP_PROCHAIN_LAOUPAS="1"	
	REP_PROCHAINJOUR_LAOUPAS="$PIRHEUREJOUR"
	REP_NBREFOIS_LAOUPAS="0"
	REP_PHRASENUM="0"
	echo "$REP_PROCHAIN_LAOUPAS,$REP_PROCHAINJOUR_LAOUPAS,$REP_NBREFOIS_LAOUPAS,$REP_PHRASENUM" > $varpir/laoupas.txt 
	fi

	if [[ "$REP_PROCHAINJOUR_LAOUPAS" != "$PIRHEUREJOUR" ]]; then # est-ce un nouveau jour depuis dernière relevée ?
	REP_PROCHAIN_LAOUPAS="0"
	REP_NBREFOIS_LAOUPAS="0"
	REP_PHRASENUM="0"
	REP_PROCHAINJOUR_LAOUPAS="$PIRHEUREJOUR"
	echo "$REP_PROCHAIN_LAOUPAS,$REP_PROCHAINJOUR_LAOUPAS,$REP_NBREFOIS_LAOUPAS,$REP_PHRASENUM" > $varpir/laoupas.txt 
	fi


	if [ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]; then

		# if [[ "$REP_PROCHAIN_LAOUPAS" = "1" ]]; then 
		# return
		# else

		# Nouveau a faire si condition réuni
		# les minutes passée entre les deux vrai si DIFFTEMPSPIRDER_HEURE=0  !!! si DIFFTEMPSPIRDER_HEURE>0 compter les heures en plus :
		# DIFFTEMPSPIRDER_HEURE=`echo $DIFFTEMPSPIRDER | cut -d':' -f1` 
		# DIFFTEMPSPIRDER_MIN=`echo $DIFFTEMPSPIRDER | cut -d':' -f2` 

# --------------- SI ABSENT ET QUE JE RENTRE APRES X TEMPSv-------------------------
if [[ "$DERPIR_MesurePIR" = "OFF" ]]; then
REP_NBREFOIS_LAOUPAS="0"


			if [[ "$DIFFTEMPSPIRDER_HEURE" > "0" ]] && [[ "$REP_PHRASENUM" != "3" ]]; then # il y a plus d'une heure de passé entre le PIR et Enregistrement
				if [[ "$DIFFTEMPSPIRDER_HEURE" > "2" ]]; then
				REP_PHRASENUM="3"
				say 'Et coucou il y a plus de deux heures que je ne t'avais pas vu... j'espère que tout va bien ?'
				fi
			fi

fi
#---------------------------------------------------------------------------
# --------------- SI TOUJOUR PRESENT DANS LA PIECE -------------------------


		if [[ "$DIFFTEMPSPIRDER_HEURE" = "01" ]] && [[ "$REP_PHRASENUM" != "2" ]]; then # il y a moins  d'une heure de passé entre le PIR et Enregistrement
			if [[ "$REP_NBREFOIS_LAOUPAS" -gt "10" ]]; then # plus de 50 minutes que JB est dans la pièce
			REP_PHRASENUM="2"
			say "Ca fait plus d'une heure que tu es là à bricoler... Sort te dégourdir un peu les jambes... "
			fi
		fi

		if [[ "$DIFFTEMPSPIRDER_HEURE" = "0" ]] && [[ "$REP_PHRASENUM" != "1" ]]; then # il y a moins  d'une heure de passé entre le PIR et Enregistrement
			if [[ "$REP_NBREFOIS_LAOUPAS" > "10" ]]; then # plys de 50 minuteso u JB est dans la pièce
			REP_PHRASENUM="1"
			say "Jibé tu devrais vraiment te dégourdir un peu les jambes... ca fais presque 1 heure que tu es assi"
			fi
		fi

		REP_NBREFOIS_LAOUPAS=$(($REP_NBREFOIS_LAOUPAS+ 1)) # Ajoute 1 au nombre de fois ou ca été lu depuis le début de la journée
		echo "$REP_PROCHAIN_LAOUPAS,$REP_PROCHAINJOUR_LAOUPAS,$REP_NBREFOIS_LAOUPAS,$REP_PHRASENUM" > $varpir/laoupas.txt 

		if [[ "$REP_PROCHAIN_LAOUPAS" = "0" ]]; then  # vu au moins 1 fois dans la journée 
		REP_PROCHAIN_LAOUPAS="1"
		fi
#---------------------------------------------------------------------------
# fin de condition nouvelle
		# fi
	fi
}


# ----------------------------------------------------------------------------------------------------------

Traitement_CalculDiffernceHetPIR() {
# Initialisation des variables....
# Mesure faite à:
PIRHEUREJOUR=`date +%d`
PIRHEUREMOI=`date +%m`
PIRHEUREHEURE=`date +%H`
PIRHEUREMIN=`date +%M`
PIR_NBREFOIS_LAOUPAS=`echo $(( $PIR_NBREFOIS_LAOUPAS + 1))`
if [ `echo ${PIRHEUREHEURE:0:1}` = "0" ]; then PIRHEUREHEURE=`echo ${PIRHEUREHEURE:1:2}`; fi
if [ `echo ${PIRHDEBUTPARLER:0:1}` = "0" ]; then PIRHDEBUTPARLER=`echo ${PIRHDEBUTPARLER:1:2}`; fi

varpir="$jv_dir/plugins/jarvis-plug-PIR"

	if [ -f "$varpir/mesurepir.txt" ]; then # est-ce que le fichier existe ?
	echo "" > /dev/null
	else
	echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR" > $varpir/mesurepir.txt 
	fi

# Dernière mesure relevée:
DERPIRHEUREJOUR=`cat $varpir/mesurepir.txt | cut -d',' -f1`
DERPIRHEUREMOI=`cat $varpir/mesurepir.txt | cut -d',' -f2`
DERPIRHEUREHEURE=`cat $varpir/mesurepir.txt | cut -d',' -f3`
DERPIRHEUREMIN=`cat $varpir/mesurepir.txt | cut -d',' -f4`
DERPIR_NBREFOIS_LAOUPAS=`cat $varpir/mesurepir.txt | cut -d',' -f5`
DERPIR_MesurePIR=`cat $varpir/mesurepir.txt | cut -d',' -f6`
if [ `echo ${DERPIRHEUREHEURE:0:1}` = "0" ]; then DERPIRHEUREHEURE=`echo ${DERPIRHEUREHEURE:1:2}`; fi

#---------------------------------------------------------------------------
# Mesure le dernier écart de temps entre le relevé PIR et celui enregistrée:
PIRDIFFTEMPS=`date -d "$PIRHEUREHEURE:$PIRHEUREMIN" +%s`
DERDIFFTEMPS=`date -d "$DERPIRHEUREHEURE:$DERPIRHEUREMIN" +%s`
DIFFTEMPSPIRDERMOINS=`echo "$PIRDIFFTEMPS - $DERDIFFTEMPS" | bc`
DIFFTEMPSPIRDER=`date -d "1970-01-01 UTC + $DIFFTEMPSPIRDERMOINS seconds" '+%R'`

# les minutes passée entre les deux vrai si DIFFTEMPSPIRDER_HEURE=0  !!! si DIFFTEMPSPIRDER_HEURE>0 compter les heures en plus :
DIFFTEMPSPIRDER_HEURE=`echo $DIFFTEMPSPIRDER | cut -d':' -f1` 
DIFFTEMPSPIRDER_MIN=`echo $DIFFTEMPSPIRDER | cut -d':' -f2` 
}

# ----------------------------------------------------------------------------------------------------------
Traitement_yeux() {
$PIRNEZ 1; $PIROEILDROIT 1; $PIROEILGAUCHE 1

	
if [ "$DERPIRHEUREHEURE" > "$PIRHDEBUTPARLER" ]; then 


	if [ "$DERPIRHEUREHEURE" -lt "$PIRHFINPARLER" ]; then 

	clignotementled=$((1 + RANDOM%(6-1+1)))
	clignotementled1=$((1 + RANDOM%(6-1+1)))

	citationsLED=("$PIRNEZ 0; sleep 0.$clignotementled; $PIRNEZ 1" "$PIROEILDROIT 0; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILGAUCHE 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; sleep 0.$clignotementled1; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1")
	citationsLED1=`echo "${citationsLED[$RANDOM % ${#citationsLED[@]} ]}"`
	eval $citationsLED1
	fi
fi
}

#----------------------------------------------------------------------------

Traitement_yeuxFin() {
$PIROEILDROIT 0; $PIROEILGAUCHE 0
if [ "$keyboard" == "true" ]; then
  $PIRNEZ 0
fi
}

