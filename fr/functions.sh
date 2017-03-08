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

Traitement_Yeux_Nuit

# #### #   je débute le traitement de tous les programmes à faire:
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------

# #### #   C'est le jour je me réveille en douceur... j'allume mes led
	if [ "$DERPIRHEUREHEURE" = "0" ]; then
	$PIRNEZ 1
	fi


# #### #   Puis mes porg commence que si l'heure actuelle > heure programmé pour parler = PIRHDEBUTPARLER
	if [ "$DERPIRHEUREHEURE" -ge "$PIRHDEBUTPARLER" ]; then

	varpir="$jv_dir/plugins/jarvis-plug-PIR"
	PIRCONFIGAUTOTAL=$(grep -c 'PIR_DIRE_ORDER=' $varpir/config.sh)
	PIRCONFIGAUTOTAL=$(($PIRCONFIGAUTOTAL + 1 ))
	ProgrammePIRNum="1"

		# a revoir... Valider Première lecture de la journée
		# if [[ "$PIRDIRE_REP1OU0" = "0" ]]; then 
		# echo "zzzz"
		# pirrelevedonne_Go # Première fois donc je lis
		# fi
	# Traitement du fichier des programme du config
	Execution_programmes_du_fichier_config
	
	# Traitement pour : "Prochain pour simplement dire bonjour de temps en temps"
	Traitement_bonjour

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

Execution_programmes_du_fichier_config() {

# #### # Lecture de toutes les variable dans config
	while test $ProgrammePIRNum != $PIRCONFIGAUTOTAL
	do

	PIRtraitementpour=$(grep 'PIR_traitement_pour=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_traitement_pour=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
	PIRDIRE_ORDER=$(grep 'PIR_DIRE_ORDER=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_ORDER=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
	PIRDIRE_DEBUT=$(grep 'PIR_DIRE_DEBUT=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_DEBUT=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
	PIRDIRE_FIN=$(grep 'PIR_DIRE_FIN=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_FIN=//g" | sed -e 's/"//g' | cut -d '#' -f 1)
	PIRDIRE_REPAQH=$(grep 'PIR_DIRE_REP_AQH=' $varpir/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_REP_AQH=//g" | sed -e 's/"//g' | cut -d ',' -f 1)
	if [ "$PIRDIRE_REPAQH" = "" ]; then PIRDIRE_REPAQH="24"; fi

	ProgrammePIRNum=$(($ProgrammePIRNum + 1))
	pirrelevedonne_fichierexiste # est-ce que le fichier existe ?

# ##### # Je vais voir à quelle heure je dois prononcer ce que l'on me demande...
PIR_DIRE_REP_AQH_Compt="1" 
PIR_TTRAITEMENT_PIR_DIRE_REP_AQH
PIR_DIRE_REP_AQH_Compt_fichier="0"
	done
}

PIR_TTRAITEMENT_PIR_DIRE_REP_AQH() {
# Lecture variable config

PIR_DIRE_REP_AQH_TOTAL_variable=`echo -n $PIRDIRE_REPAQH | grep ":" | wc -w` 			 # combien d'heure à gerer au total ?
PIRDIRE_REPAQH_OK_variable=`echo -n $PIRDIRE_REPAQH | grep ":" | cut -d' ' -f$PIR_DIRE_REP_AQH_Compt | sed -e "s/ //g"` # je récupère heure entière
PIRDIRE_REPAQH_OKHeure_variable=`echo -n $PIRDIRE_REPAQH_OK_variable | grep ":" | cut -d: -f1`		# je recupère que Heure
PIRDIRE_REPAQH_OKMinutes_variable=`echo -n $PIRDIRE_REPAQH_OK_variable | grep ":" | cut -d: -f2`		# je récupère que minute

# ### # echo "Pour le Programme $PIRtraitementpour, les heures total à gerer: $PIR_DIRE_REP_AQH_TOTAL_variable"
# ### #   echo "Heure N° $PIR_DIRE_REP_AQH_Compt à: $PIRDIRE_REPAQH_OK_variable avec ici les Heure: $PIRDIRE_REPAQH_OKHeure_variable et les minutes: $PIRDIRE_REPAQH_OKMinutes_variable"
# ### #  echo " "

# Arrêt compteur à la fin du total des heure inscrites dans variable:
if [ "$PIR_DIRE_REP_AQH_Compt" -lt "$PIR_DIRE_REP_AQH_TOTAL_variable" ]; then 


	# TEST: Heure de maintenant est > heure enregistré dans le config ? 
	if [[ "$DERPIRHEUREHEURE" -ge "$PIRDIRE_REPAQH_OKHeure_variable" ]]; then 
		
	# Oui c'est plus grand donc je lire maintenant dans fichier enregistré = heure variable config ci dessus = 0 ou 1
	valireheurefichiernumerox


	PIR_DIRE_REP_AQH_Compt_fichier=$(($PIR_DIRE_REP_AQH_Compt_fichier + 1 ))
      		if [[ "$DERPIRHEUREHEURE" -ge "$PIRDIRE_REPAQH_OKHeure_fichier" ]]; then # Est ce que heure maintenant > heure dans fichier
			# oui l"heure est plus grande donc je vais vérifier si l'heure à traité est la même = que lheure du fichier
			if [ "$PIRDIRE_REPAQH_OKHeure_variable" = "$PIRDIRE_REPAQH_OKHeure_fichier" ]; then
			
				# Oui c'est la même heure alors je vérifie si j'ai fais la commande ou pas par 0 ou 1
# echo "$PIRtraitementpour: $PIRDIRE_REPAQH_OKHeure_variable = $PIRDIRE_REPAQH_OKHeure_fichier avec 1ou0 à $PIRDIRE_REPAQH_OKMinutes_1ou0_fichier"
                                                                                                         
				if [[ "$PIRDIRE_REPAQH_OKMinutes_1ou0_fichier" = "0" ]]; then 
				# oui ce n'est pas encore lu donc Oui, j'exécute commande
                                modif0ou1fichier_heure # je vais mettre un 1 ou 0 à la bonne heure puis j'excécute ma commande à traiter
				pirrelevedonnerep_Go
				# return
				fi
		
			fi
		
		fi
	fi
PIR_DIRE_REP_AQH_Compt=$(($PIR_DIRE_REP_AQH_Compt + 1 ))
PIR_TTRAITEMENT_PIR_DIRE_REP_AQH
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
PIRDIRE_REP1OU0=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f3` # Ai je répété le PIRDIRE_REPAQH ?
PIRDIRE_REPAQH_OK_ENREG=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f4-` # Dernière heure lu sauvegardé à
else
REP_PROCHAINJOUR="$PIRHEUREJOUR"
Traitement_total_heure-config
echo "0,$PIRHEUREJOUR,0,$PIRDIRE_REPAQH_OK" > $varpir/$PIRtraitementpour.txt 
fi

# est-ce un nouveau jour depuis dernière relevée ?
if [[ "$REP_PROCHAIN_JOUR" != "$PIRHEUREJOUR" ]]; then # est-ce un nouveau jour depuis dernière relevée ?
REP_PROCHAIN_1OU0="0"
PIRDIRE_REP1OU0="0"
# ################################################################################### 
# ### PIRDIRE_REPAQH_OK_ENREG
Traitement_total_heure-config
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR,$PIRDIRE_REP1OU0,$PIRDIRE_REPAQH_OK" > $varpir/$PIRtraitementpour.txt 
fi

}

pirrelevedonne_Go() {
# Nouveau a faire si condition réuni
say "$PIRDIREL_DEBUT"
jv_handle_order "$PIRDIRE_ORDER "
say "$PIRDIRE_FIN"
REP_PROCHAIN_1OU0=$(($REP_PROCHAIN_1OU0 + 1))
if [ "$REP_PROCHAIN_1OU0" -ge "1" ]; then REP_PROCHAIN_1OU0="1"; fi

modif0ou1fichier_heure
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR,$PIRDIRE_REP1OU0,$PIRDIRE_REPAQH_OK" > $varpir/$PIRtraitementpour.txt 
}

pirrelevedonnerep_Go() {
# Nouveau a faire si condition réuni
say "$PIRDIREL_DEBUT"
jv_handle_order "$PIRDIRE_ORDER "
say "$PIRDIRE_FIN"
PIRDIRE_REP1OU0=$(($PIRDIRE_REP1OU0 + 1))
if [ "$PIRDIRE_REP1OU0" -ge "1" ]; then PIRDIRE_REP1OU0="1"; fi
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR,$PIRDIRE_REP1OU0,$PIRDIRE_REPAQH_OK_ENREG" > $varpir/$PIRtraitementpour.txt 
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

	if [ "$DERPIRHEUREHEURE" -gt "$PIRHDEBUTPARLER" ]; then

		if [[ "$REP_PROCHAIN_EVENEMENT" = "1" ]]; then 
		return
		else
		jv_handle_order "prochain évènement"
		REP_PROCHAIN_EVENEMENT=$(($REP_PROCHAIN_EVENEMENT + 1))
		echo "$REP_PROCHAIN_EVENEMENT,$PIRHEUREJOUR" > $varpir/prochainevenement.txt 
		fi
	fi

	if [[ "$DERPIRHEUREHEURE" -gt "18" ]] && [[ "$DERPIRHEUREHEURE" -lt "$PIRHFINPARLER" ]]; then
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


	if [ "$DERPIRHEUREHEURE" -gt "$PIRHDEBUTPARLER" ]; then

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


			if [[ "$DIFFTEMPSPIRDER_HEURE" -gt "0" ]] && [[ "$REP_PHRASENUM" != "3" ]]; then # il y a plus d'une heure de passé entre le PIR et Enregistrement
				if [[ "$DIFFTEMPSPIRDER_HEURE" -gt "2" ]]; then
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
			if [[ "$REP_NBREFOIS_LAOUPAS" -gt "10" ]]; then # plys de 50 minuteso u JB est dans la pièce
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
#	echo "" > /dev/null
echo ""
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

	
if [ "$DERPIRHEUREHEURE" -gt "$PIRHDEBUTPARLER" ]; then 


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

Traitement_Yeux_Nuit() {
if [ "$DERPIRHEUREHEURE" -gt "$PIRLUMIEREOFFNUIT" ]; then
$PIRNEZ 0
$PIROEILDROIT 0
$PIROEILGAUCHE 0
fi
}

Traitement_yeuxFin() {
$PIROEILDROIT 0; $PIROEILGAUCHE 0
if [ "$keyboard" == "true" ]; then
  $PIRNEZ 0
fi
}


modif0ou1fichier_heure() {      # je vais mettre un 1 ou 0 à la bonne heure
PIRDIRE_REPAQH_OKMinutes_1ou0_fichier="1"
PIR_DIRE_REP_AQH_Compt=$(($PIR_DIRE_REP_AQH_Compt + 1 ))

PIRDIRE_REPAQH_OK=`echo -n $PIRDIRE_REPAQH | grep ":" | cut -d' ' -f$PIR_DIRE_REP_AQH_Compt | sed -e "s/ //g"`
echo "-$PIRDIRE_REPAQH_OK-$PIR_DIRE_REP_AQH_Compt"
# Je dois remplacer l"heure ou ca correspond dans fichier par un 1
PIRDIRE_REPAQH_OK_fichier1=`echo "$PIRDIRE_REPAQH_OK_fichier" | cut -c1-6`
PIRDIRE_REPAQH_OK_fichier1=`echo "$PIRDIRE_REPAQH_OK_fichier1 1" | sed -e "s/ //g"`
PIRDIRE_REPAQH_OK_ENREG=`echo "$PIRDIRE_REPAQH_OK_ENREG" | sed -e "s/$PIRDIRE_REPAQH_OK_fichier/$PIRDIRE_REPAQH_OK_fichier1/g"`
}

Traitement_total_heure-config() {
if test -z "$PIRDIRE_REPAQH"; then
return
else
PIR_DIRE_REP_AQH_TOTAL=`echo -n "$PIRDIRE_REPAQH" | grep ":" | wc -w`
PIR_DIRE_REP_AQH_Compt_heure_config=$(($PIR_DIRE_REP_AQH_Compt_heure_config + 1 ))
	if [ "$PIR_DIRE_REP_AQH_Compt_heure_config" -le "$PIR_DIRE_REP_AQH_TOTAL" ]; then 
	PIRDIRE_REPAQH_OK="$PIRDIRE_REPAQH_OK `echo "$PIRDIRE_REPAQH" | grep ":" | cut -d' ' -f$PIR_DIRE_REP_AQH_Compt_heure_config | sed -e "s/ //g"`,0 "
	Traitement_total_heure-config
	fi
fi
}

valireheurefichiernumerox() {
# lit heure enregistré dans fichier texte du N° 1 à x x=variable
# if test -z "$PIR_DIRE_REP_AQH_Compt_fichier"; then
# return
# else
PIR_DIRE_REP_AQH_TOTAL_fichier=`echo -n $PIRDIRE_REPAQH_OK_ENREG | grep ":" | wc -w` 			 # combien d'heure à gerer au total ?
PIRDIRE_REPAQH_OK_fichier=`echo -n $PIRDIRE_REPAQH_OK_ENREG | grep ":" | cut -d' ' -f$(($PIR_DIRE_REP_AQH_Compt_fichier + 1 )) | sed -e "s/ //g"` # je récupère heure entière
PIRDIRE_REPAQH_OKMinutes_1ou0_fichier=`echo -n $PIRDIRE_REPAQH_OK_fichier | grep ":" | cut -d',' -f2-`		# je récupère si c'est fait ou pas 1 ou 0
PIRDIRE_REPAQH_OKHeure_fichier=`echo -n $PIRDIRE_REPAQH_OK_fichier | grep ":" | cut -d: -f1`		# je recupère que Heure
PIRDIRE_REPAQH_OKMinutes_fichier=`echo -n $PIRDIRE_REPAQH_OK_fichier | grep ":" | cut -d: -f2 | cut -d, -f1`		# je récupère que minute
# ### # echo "Dans le fichier $PIRtraitementpour il y a $PIR_DIRE_REP_AQH_TOTAL_fichier au total dont"
# ### # echo "$PIRDIRE_REPAQH_OK_fichier avec pour heure:$PIRDIRE_REPAQH_OKHeure_fichier minutes:$PIRDIRE_REPAQH_OKMinutes_fichier Excécuté ou pas ?: $PIRDIRE_REPAQH_OKMinutes_1ou0_fichier"
# fi

}

