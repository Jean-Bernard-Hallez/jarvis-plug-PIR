jv_pg_ct_MesurePIR_dodo() {
varpirconfigdodo="$jv_dir/plugins_installed/jarvis-plug-PIR/pause_onOUoff.txt"
echo "OFF" > $varpirconfigdod
say "Prononcer reveilles toi pour me réactiver... Mesure Pire Off"
}

jv_pg_ct_MesurePIR_reveil() {
varpirconfigdodo="$jv_dir/plugins_installed/jarvis-plug-PIR/pause_onOUoff.txt"
echo "ON" > $varpirconfigdodo
say "Voilà je suis bien réveillé Mesure Pire On"
}

MesurePIR() {

if [ ! -e "/home/pi/jarvis/plugins_installed/jarvis-plug-PIR/PIRRETOURCONSOLE.txt" ]; then 
echo "ON" > /home/pi/jarvis/plugins_installed/jarvis-plug-PIR/PIRRETOURCONSOLE.txt
fi


if [[ "$PIRRETOURCONSOLE" != `cat /home/pi/jarvis/plugins_installed/jarvis-plug-PIR/PIRRETOURCONSOLE.txt` ]]; then
echo $PIRRETOURCONSOLE > /home/pi/jarvis/plugins_installed/jarvis-plug-PIR/PIRRETOURCONSOLE.txt
fi

varpirconfigdodo="$jv_dir/plugins_installed/jarvis-plug-PIR/pause_onOUoff.txt"

varpir="$jv_dir/plugins_installed/jarvis-plug-PIR/traitementPIR"
MesurePIR_jr_dodo=`cat $varpir/mesurepir.txt | cut -d',' -f1`
PIRHEUREJOUR_DODO=`date +%d` 

if [[ "$PIRHEUREJOUR_DODO" != "$MesurePIR_jr_dodo" ]]; then
say "ça fait un jour que je suis endormi... je me réveille..."
echo "ON" > $varpirconfigdodo
fi

MesurePIR_reveil=`cat $varpirconfigdodo`

if [[ "$MesurePIR_reveil" == "ON" ]]; then
PIROEILGAUCHE="gpio write $PIROEILGAUCHE_GPIO" # GPIO Oeil Gauche
PIROEILDROIT="gpio write $PIROEILDROIT_GPIO"  # GPIO Oeil Droit
PIRNEZ="gpio write $PIRNEZ_GPIO"        # GPIO Nez
PIRDETECTEUR="gpio write $PIRDETECTEUR_GPIO"        # GPIO PIR


MesurePIR="ON"


if [[ "$MesurePIR" == "OFF" ]] ; then 
varpir="$jv_dir/plugins_installed/jarvis-plug-PIR/traitementPIR"
varpirconfig="$jv_dir/plugins_installed/jarvis-plug-PIR"

DER_MesurePIR=`cat $varpir/mesurepir.txt | cut -d',' -f7`
	if [[ "$DER_MesurePIR" == "ON" ]] ; then 

	MesurePIR="OFF"
	# say "Capteur OFF"
		if [ -f "$varpir/mesurepir.txt" ]; then # Si le fichier existe ? Remise à 0 du compteur si 2 fois Off
		DERPIR_NBREFOIS_LAOUPAS=`cat $varpir/mesurepir.txt | cut -d',' -f5`
		DERPIR_NBREFOIS_ONOFF=`cat $varpir/mesurepir.txt | cut -d',' -f6`
			if [[ "$DERPIR_NBREFOIS_ONOFF" == "ON" ]]; then
			PIRHEUREJOUR=`date +%d`
			PIRHEUREMOI=`date +%m`
			PIRHEUREHEURE=`date +%H`
			PIRHEUREMIN=`date +%M`
			PIR_NBREFOIS_LAOUPAS="0"
				if test -z "$PIR_OPTION_MESURE"; then
				PIR_OPTION_MESURE="0"
				fi

			echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR,$PIR_OPTION_MESURE" > $varpir/mesurepir.txt
				if [[ "$PIRLOG" == "ON" ]]; then 			
				echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR,$PIR_OPTION_MESURE" >> $varpir/mesurepirLOG.txt
				fi
			fi
		fi
	fi
fi


if [[ "$MesurePIR" == "ON" ]]; then 

Traitement_CalculDiffernceHetPIR # traitement des variables relevées
    if [ "$PIRHEUREHEURE" -gt "$PIRHDEBUTPARLER" ] && [ "$PIRHEUREHEURE" -le "$PIRHFINPARLER" ]; then

PIR_ACTION_TOUTES_LES_DIFF=$(( (`echo "$PIRHEUREMIN" |  sed  -e 's/^0//g'`) - (`echo "$DERPIRHEUREMIN" |  sed  -e 's/^0//g'`) ))

PIR_ACTION_TOUTES_LES_DIFFH=$(( (`echo "$PIRHEUREHEURE" |  sed  -e 's/^0//g'`)  - (`echo "$DERPIRHEUREHEURE" |  sed  -e 's/^0//g'`) ))

	if [[ "$PIR_ACTION_TOUTES_LES_DIFFH" == "0" ]]; then

		if [[ "$PIR_ACTION_TOUTES_LES_DIFF" -gt "$PIR_ACTION_TOUTES_LES" ]]; then
		Pir_FEUX_VERT="Ok"
		else
		Pir_FEUX_VERT=""
		if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
		jv_warning "Pir à 1 mais Pluging bloqué car il reste encore $(( $PIR_ACTION_TOUTES_LES - $PIR_ACTION_TOUTES_LES_DIFF )) minutes / $PIR_ACTION_TOUTES_LES (voir PIR_ACTION_TOUTES_LES dans le fichier config.sh)"
		fi
		fi
	else
	Pir_FEUX_VERT="Ok"
	fi

else
Traitement_Yeux_Nuit
fi
fi


######################## # Ok j'ai le feux vert je continue:

if [[ "$Pir_FEUX_VERT" == "Ok" ]]; then 
varpir="$jv_dir/plugins_installed/jarvis-plug-PIR/traitementPIR"
varpirconfig="$jv_dir/plugins_installed/jarvis-plug-PIR"
DER_MesurePIR=`cat $varpir/mesurepir.txt | cut -d',' -f7`


if [[ "$Pir_FEUX_VERT" == "Ok" ]] ; then 
varpir="$jv_dir/plugins_installed/jarvis-plug-PIR/traitementPIR"
varpirconfig="$jv_dir/plugins_installed/jarvis-plug-PIR"

if test -d  "$varpir/ALARME.txt"; then 
PIR_ALARME_ETAT=`cat $varpir/ALARME.txt`
else
PIR_ALARME_ETAT="OFF"
fi
	if [[ "PIR_ALARME_ETAT" == "ON" ]] ; then 
	echo "******************** Alarme Domicile en Marche ********************"
	else
	echo "******************** Alarme Domicile en Arrêt ********************"
	fi
fi

Traitement_yeux



# #### #   je débute le traitement de tous les programmes à faire:
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------


# #### #   Mes porg commence que si l'heure actuelle > heure programmé pour parler = PIRHDEBUTPARLER

	if [ "$DERPIRHEUREHEURE" -gt "$PIRHDEBUTPARLER" ] && [ "$DERPIRHEUREHEURE" -lt "$PIRHFINPARLER" ]; then
 $PIRNEZ 1
	varpir="$jv_dir/plugins_installed/jarvis-plug-PIR/traitementPIR"
	varpirconfig="$jv_dir/plugins_installed/jarvis-plug-PIR"
	PIRCONFIGAUTOTAL=$(grep -c 'PIR_DIRE_ORDER=' $varpirconfig/config.sh)
	PIRCONFIGAUTOTALMISEAJOUR=$(grep -c '##' $varpirconfig/config.sh)
	PIRCONFIGAUTOTAL=$(($PIRCONFIGAUTOTAL + 1 ))
	ProgrammePIRNum="1"

		# a revoir... Valider Première lecture de la journée
		# if [[ "$PIRDIRE_REP1OU0" = "0" ]]; then 
		# echo "zzzz"
		# pirrelevedonne_Go # Première fois donc je lis
		# fi
	if [[ "$PIRCONFIGAUTOTALMISEAJOUR" -gt "3" ]]; then
	say "Attention vous avez fais des mise à jours dans le fichier"
	say "config.sh de mesure pire point S H"
	say "il faut supprimer les doubles dièses..." 
	say "je répète..."
	say "Attention vous avez fais des mise à jours dans le fichier config.sh de mesure pire point S H il faut supprimer les doubles dièses..." 
	say "le programme va beuguer..."
	exit
	fi

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
	# traitement test pir à 1
	Traitement_Pi-A1

	# Traitement pour : "Prochain pour simplement dire bonjour de temps en temps"
	Traitement_bonjour


	# Traitement pour : "Suis-je sortie de la maison ? "
	regardedanslajournée

	# Traitement pour : "Dire si JB est souvent devant son pc ou pas"
	Traitement_Tuessouventlaoupas 
	fi


	# Traitement du fichier des programme du config
 	 Traitement_Execution_programmes_du_fichier_config
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# Fin j'enregistre heure du dernièr PIR à ON
echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR,$PIR_OPTION_MESURE" > $varpir/mesurepir.txt
	if [[ "$PIRLOG" == "ON" ]]; then 			
	echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR,$PIR_OPTION_MESURE" >> $varpir/mesurepirLOG.txt
	fi

# Traitement_yeuxFin
my_var=true
# say " "; jv_handle_order "LESYEUXOFF"


commands="$(jv_get_commands)"; jv_handle_order "LESYEUXOFF"
# say $(jv_get_commands); jv_handle_order "LESYEUXOFF"
# jv_handle_order "LESYEUXOFF"
# say " "; jv_handle_order "LESYEUXOFF"
# $PIROEILGAUCHE 0
# $PIROEILDROIT 0

fi
else
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
jv_warning "Tu m'as demandé de m'endormir... jusqu'à demain je suis inactif... mais tu peux prononcer reveilles-toi pour me reveiller..."
fi
fi

}

Traitement_Pi-A1() {
if test -z "$PIRACHAQUEDETECTION_ORDER"; then
return
else
jv_handle_order "$PIRACHAQUEDETECTION_ORDER"
fi

if test -z "$PIRACHAQUEDETECTION_SAY"; then
return
else
say "$PIRACHAQUEDETECTION_SAY"
fi


}

Traitement_Execution_programmes_du_fichier_config() {
# #### # Lecture de toutes les variable dans config
if [[ "$ProgrammePIRNum" == "" ]]; then ProgrammePIRNum="1"; fi
if [[ "$PIRCONFIGAUTOTAL" == "" ]]; then PIRCONFIGAUTOTAL=$(grep -c 'PIR_DIRE_ORDER=' $varpirconfig/config.sh); fi


	while test $ProgrammePIRNum != $PIRCONFIGAUTOTAL
	do

	PIRtraitementpour=$(grep 'PIR_traitement_pour=' $varpirconfig/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_traitement_pour=//g" | sed -e 's/"//g' | cut -d '#' -f 1) # Nom de ce que je dois faire
	PIRDIRE_ORDER=$(grep 'PIR_DIRE_ORDER=' $varpirconfig/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_ORDER=//g" | sed -e 's/"//g' | cut -d '#' -f 1)               # Ce que je dois faire = Order
	PIRDIRE_DEBUT=$(grep 'PIR_DIRE_DEBUT=' $varpirconfig/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_DEBUT=//g" | sed -e 's/"//g' | cut -d '#' -f 1)               # Ce que je dois dire avant de le faire = Say
	PIRDIRE_FIN=$(grep 'PIR_DIRE_FIN=' $varpirconfig/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_FIN=//g" | sed -e 's/"//g' | cut -d '#' -f 1)                     # Ce que je dois dire après de le faire = Say
	PIRDIRE_REPAQH=$(grep 'PIR_DIRE_REP_AQH=' $varpirconfig/config.sh | sed -n $ProgrammePIRNum\p | sed -e "s/PIR_DIRE_REP_AQH=//g" | sed -e 's/"//g' | cut -d ',' -f 1)          # Les heures ou de je dois je faire
	if [ "$PIRDIRE_REPAQH" = "" ]; then PIRDIRE_REPAQH="24"; fi
	pirrelevedonne_fichierexiste # est-ce que le fichier existe ?


# ##### # Je vais voir à quelle heure je dois prononcer ce que l'on me demande et j'exécute si c'est le cas...
PIR_DIRE_REP_AQH_Compt="1" 
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then 
jv_success "* Je traite: $PIRtraitementpour"
fi
PIR_DIRE_REP_AQH_Compt_fichier="1"
PIR_TTRAITEMENT_PIR_DIRE_REP_AQH
PIRDIRE_REPAQH_OK=""
if [ "$ProgrammePIRNum" = "$PIRCONFIGAUTOTAL" ]; then return; fi
ProgrammePIRNum=$(($ProgrammePIRNum + 1))	
done
}

PIR_TTRAITEMENT_PIR_DIRE_REP_AQH() {
# Lecture variable config
PIR_DIRE_REP_AQH_TOTAL_variable=`echo -n $PIRDIRE_REPAQH | grep ":" | wc -w` 			 # combien d'heure à gerer au total ?
PIRDIRE_REPAQH_OK_variable=`echo -n $PIRDIRE_REPAQH | grep ":" | cut -d' ' -f$PIR_DIRE_REP_AQH_Compt | sed -e "s/ //g"` # je récupère heure entière
PIRDIRE_REPAQH_OKHeure_variable=`echo -n $PIRDIRE_REPAQH_OK_variable | grep ":" | cut -d: -f1`		# je recupère que Heure
PIRDIRE_REPAQH_OKMinutes_variable=`echo -n $PIRDIRE_REPAQH_OK_variable | grep ":" | cut -d: -f2`		# je récupère que minute

# ### # echo "Pour le Programme $PIRtraitementpour, les heures total à gerer: $PIR_DIRE_REP_AQH_TOTAL_variable"
# ### # echo "Heure N° $PIR_DIRE_REP_AQH_Compt à: $PIRDIRE_REPAQH_OK_variable avec ici les Heure: $PIRDIRE_REPAQH_OKHeure_variable et les minutes: $PIRDIRE_REPAQH_OKMinutes_variable"
# ### # echo " "

# Arrêt compteur à la fin du total des heure inscrites dans variable:
if [ "$PIR_DIRE_REP_AQH_Compt" -le "$PIR_DIRE_REP_AQH_TOTAL_variable" ]; then 

	if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
	jv_info "$PIR_DIRE_REP_AQH_TOTAL_variable heure à traiter, N°$PIR_DIRE_REP_AQH_Compt_fichier Si Heure de maintenant: $DERPIRHEUREHEURE > Heure enregistrée dans le config: $PIRDIRE_REPAQH_OKHeure_variable"
	fi
	# TEST: Heure de maintenant est > heure enregistré dans le config ? 
	if [ "$DERPIRHEUREHEURE" -ge "$PIRDIRE_REPAQH_OKHeure_variable" ]; then 

	# Oui c'est plus grand donc je lire maintenant dans fichier enregistré	
	valireheurefichiernumerox		
	
	# jv_debug "Oui c'est plus grand donc si je regarde heure maintenant = $DERPIRHEUREHEURE > que heure du fichier $PIRDIRE_REPAQH_OKHeure_fichier"
	PIR_DIRE_REP_AQH_Compt_fichier=$(($PIR_DIRE_REP_AQH_Compt_fichier + 1 ))
	
if test -z "$PIRDIRE_REPAQH_OKHeure_fichier"; then 
PIRDIRE_REPAQH_OKHeure_fichier="0"
fi
	
			if [ "$DERPIRHEUREHEURE" -ge "$PIRDIRE_REPAQH_OKHeure_fichier" ]; then # Est ce que heure maintenant > heure dans fichier
                        # oui l"heure est plus grande donc je vais vérifier si l'heure à traiter est la même = que lheure du fichier
			if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
			jv_debug "Oui c'est plus grand donc je lis le fichier enregistré:$PIRDIRE_REPAQH_OKHeure_fichier = heure variable:$PIRDIRE_REPAQH_OKHeure_variable  puis si heure variable 1ou0 --> $PIRDIRE_REPAQH_OKMinutes_1ou0_fichier"
			fi
			if [ "$PIRDIRE_REPAQH_OKHeure_fichier" = "$PIRDIRE_REPAQH_OKHeure_variable" ]; then
			      
				# Oui c'est la même heure alors je vérifie si j'ai fais la commande ou pas par 0 ou 1
        			if [ "$PIRDIRE_REPAQH_OKMinutes_1ou0_fichier" = "0" ]; then 
				if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
				jv_debug "Oui c'est = à 0 je fais mon programme demandé dans le config"
				fi
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
# Oui il existe
# Je vérifie si les heures correspondent
Traitement_total_heure_config_correspond
REP_PROCHAIN_1OU0=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f1`     # 1=Fait  ou 0=Pas encore
REP_PROCHAIN_JOUR=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f2` # Jour ou c'est fait
PIRDIRE_REP1OU0=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f3` # Ai je répété le PIRDIRE_REPAQH ?
PIRDIRE_REPOPTION=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f4` # je récupère état option
PIRDIRE_REPAQH_OK_ENREG=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f5-` # Dernière heure lu sauvegardé à


else
# Non il n'existe pas !
REP_PROCHAINJOUR="$PIRHEUREJOUR"
jv_warning "Le fichier $PIRtraitementpour n'existe pas... je le créais"
Traitement_total_heure_config # Je copie ce qu'il y a dans config dans fichier
echo "0,$PIRHEUREJOUR,0,0,$PIRDIRE_REPAQH_OK" > $varpir/$PIRtraitementpour.txt 
fi 
# est-ce un nouveau jour depuis dernière relevée de mesurepir ?
if [[ "$DERPIRHEUREJOUR" != "$PIRHEUREJOUR" ]]; then
Traitement_CalculDiffernceHetPIR
echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR,$PIR_OPTION_MESURE" > $varpir/mesurepir.txt
fi

# est-ce un nouveau jour depuis dernière relevée des config?
# jv_handle_order "$REP_PROCHAIN_JOUR != $PIRHEUREJOUR"
if [[ "$REP_PROCHAIN_JOUR" != "$PIRHEUREJOUR" ]]; then # est-ce un nouveau jour depuis dernière relevée ?
REP_PROCHAIN_1OU0="0"
PIRDIRE_REP1OU0="0"
REP_OPION="0"
# ### PIRDIRE_REPAQH_OK_ENREG
PIRDIRE_REPAQH_OK=""
Traitement_total_heure_config

if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
jv_warning "$PIRtraitementpour: C'est un nouveau jour... "
fi
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR,$PIRDIRE_REP1OU0,$REP_OPION,$PIRDIRE_REPAQH_OK" > $varpir/$PIRtraitementpour.txt 
								    
fi

}

pirrelevedonne_Go() {
# Nouveau a faire si condition réuni
say "$PIRDIRE_DEBUT"
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
jv_warning "--XX---jv_handle_order PIRDIRE_ORDER=$PIRDIRE_ORDER---XX--"
fi
PIRDIRE_ORDER_TT=`echo "$PIR_DIRE_ORDER" | grep -o "/" | wc -w`
PIRDIRE_ORDER_TTComp="1"
while $PIRDIRE_ORDER_TTComp != $PIRDIRE_ORDER_TT
do
PIRDIRE_ORDER_TT_dit="$PIR_DIRE_ORDER" | cut -d"/" -f$PIRDIRE_ORDER_TTComp
PIRDIRE_ORDER_TTComp=$(( $PIRDIRE_ORDER_TTComp + 1 ))
done
jv_handle_order "$PIRDIRE_ORDER"
say "$PIRDIRE_FIN"
REP_PROCHAIN_1OU0=$(($REP_PROCHAIN_1OU0 + 1))
if [ "$REP_PROCHAIN_1OU0" -ge "1" ]; then REP_PROCHAIN_1OU0="1"; fi
modif0ou1fichier_heure
REP_OPION="0"
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR,$PIRDIRE_REP1OU0,$REP_OPION,$PIRDIRE_REPAQH_OK" > $varpir/$PIRtraitementpour.txt 
}

pirrelevedonnerep_Go() {
# Nouveau a faire si condition réuni
say "$PIRDIRE_DEBUT"
PIRDIRE_ORDER_TT=$(( `echo "$PIRDIRE_ORDER" | grep -o "+" | wc -w` + 1 )) 
PIRDIRE_ORDER_TTComp="1"
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
jv_warning "-----jv_handle_order PIRDIRE_ORDER=$PIRDIRE_ORDER-----"
fi


	if [[ "$PIRDIRE_ORDER" =~ "+" ]]; then
	while test $PIRDIRE_ORDER_TTComp != $PIRDIRE_ORDER_TT
	do
	PIRDIRE_ORDER_TT_dit=`echo "$PIRDIRE_ORDER" | cut -d"+" -f$PIRDIRE_ORDER_TTComp`
	jv_handle_order "$PIRDIRE_ORDER_TT_dit"
	PIRDIRE_ORDER_TTComp=$(( $PIRDIRE_ORDER_TTComp + 1 ))
	done
# echo "$PIRDIRE_ORDER" | grep "+" | wc -l
	else
	jv_handle_order "$PIRDIRE_ORDER"
	fi
say "$PIRDIRE_FIN"
PIRDIRE_REP1OU0=$(($PIRDIRE_REP1OU0 + 1))
if [ "$PIRDIRE_REP1OU0" -ge "1" ]; then PIRDIRE_REP1OU0="1"; fi
REP_OPION="0"
echo "$REP_PROCHAIN_1OU0,$PIRHEUREJOUR,$PIRDIRE_REP1OU0,$REP_OPION,$PIRDIRE_REPAQH_OK_ENREG" > $varpir/$PIRtraitementpour.txt 
}



Traitement_Tuessouventlaoupas() {
	if [ -f "$varpir/laoupas.txt" ]; then # est-ce que le fichier existe ?
	REP_PROCHAIN_LAOUPAS=`cat $varpir/laoupas.txt | cut -d',' -f1`     # 1=Fait  ou 0=Pas encore
	REP_PROCHAINJOUR_LAOUPAS=`cat $varpir/laoupas.txt | cut -d',' -f2` # Jour ou c'est fait
	REP_NBREFOIS_LAOUPAS=`cat $varpir/laoupas.txt | cut -d',' -f3` # Nbr de répetition dans le jour
	REP_PHRASENUM=`cat $varpir/laoupas.txt | cut -d',' -f4` # Pharse à dire en fonction du nombre de répétition
	REP_OPTIONLUOUPAS=`cat $varpir/laoupas.txt | cut -d',' -f5` # Pharse à dire en fonction du nombre de répétition

	else
	REP_PROCHAIN_LAOUPAS="1"	
	REP_PROCHAINJOUR_LAOUPAS="$PIRHEUREJOUR"
	REP_NBREFOIS_LAOUPAS="0"
	REP_PHRASENUM="0"
	REP_OPTIONLUOUPAS="0"
	echo "$REP_PROCHAIN_LAOUPAS,$REP_PROCHAINJOUR_LAOUPAS,$REP_NBREFOIS_LAOUPAS,$REP_PHRASENUM,$REP_OPTIONLUOUPAS=" > $varpir/laoupas.txt 
	fi

	if [ "$REP_PROCHAINJOUR_LAOUPAS" -ne "$PIRHEUREJOUR" ]; then # est-ce un nouveau jour depuis dernière relevée ?
	REP_PROCHAIN_LAOUPAS="0"
	REP_NBREFOIS_LAOUPAS="0"
	REP_PHRASENUM="0"
	REP_PROCHAINJOUR_LAOUPAS="$PIRHEUREJOUR"
	REP_OPTIONLUOUPAS="0"
	echo "$REP_PROCHAIN_LAOUPAS,$REP_PROCHAINJOUR_LAOUPAS,$REP_NBREFOIS_LAOUPAS,$REP_PHRASENUM,$OPTIONLUOUPAS" > $varpir/laoupas.txt 
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
			REP_NBREFOIS_LAOUPAS=$(( $REP_NBREFOIS_LAOUPAS - 3 ))
			say "Ca fait plus d'une heure que tu es là à bricoler... Sort te dégourdir un peu les jambes... "
			fi
		fi

		if [[ "$DIFFTEMPSPIRDER_HEURE" = "0" ]] && [[ "$REP_PHRASENUM" != "1" ]]; then # il y a moins  d'une heure de passé entre le PIR et Enregistrement
			if [[ "$REP_NBREFOIS_LAOUPAS" -gt "10" ]]; then # plys de 50 minuteso u JB est dans la pièce
			REP_PHRASENUM="1"
			REP_NBREFOIS_LAOUPAS=$(( $REP_NBREFOIS_LAOUPAS - 3 ))
			say "Jibé tu devrais vraiment te dégourdir un peu les jambes... ca fais presque 1 heure que tu es assi"
			fi
		fi

		REP_NBREFOIS_LAOUPAS=$(($REP_NBREFOIS_LAOUPAS+ 1)) # Ajoute 1 au nombre de fois ou ca été lu depuis le début de la journée
		echo "$REP_PROCHAIN_LAOUPAS,$REP_PROCHAINJOUR_LAOUPAS,$REP_NBREFOIS_LAOUPAS,$REP_PHRASENUM,$OPTIONLUOUPAS" > $varpir/laoupas.txt 

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

	varpir="$jv_dir/plugins_installed/jarvis-plug-PIR/traitementPIR"
	varpirconfig="$jv_dir/plugins_installed/jarvis-plug-PIR"

	if [ ! -d $varpir ]; then # est-ce que le répertoire existe ?
	jv_warning "je créer le répertoire de configuration"
	sudo mkdir -p "$varpir"
	fi




	if [ ! -f "$varpir/mesurepir.txt" ]; then # est-ce que le fichier existe ?
	echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,$PIR_NBREFOIS_LAOUPAS,$MesurePIR,0" > $varpir/mesurepir.txt 
	fi

# Dernière mesure relevée:
DERPIRHEUREJOUR=`cat $varpir/mesurepir.txt | cut -d',' -f1`
DERPIRHEUREMOI=`cat $varpir/mesurepir.txt | cut -d',' -f2`
DERPIRHEUREHEURE=`cat $varpir/mesurepir.txt | cut -d',' -f3`
DERPIRHEUREMIN=`cat $varpir/mesurepir.txt | cut -d',' -f4`
DERPIR_NBREFOIS_LAOUPAS=`cat $varpir/mesurepir.txt | cut -d',' -f5`
DERPIR_MesurePIR=`cat $varpir/mesurepir.txt | cut -d',' -f6`
DERPIR_OPTION_MESURE=`cat $varpir/mesurepir.txt | cut -d',' -f7`

if [[ "$DERPIRHEUREHEURE" != "0" ]]; then
if [ `echo ${DERPIRHEUREHEURE:0:1}` = "0" ]; then DERPIRHEUREHEURE=`echo ${DERPIRHEUREHEURE:1:2}`; fi
else
DERPIRHEUREHEURE="00"
fi

# Nouveau jour ?
if [ "$PIRHEUREJOUR" -ne "$DERPIRHEUREJOUR" ]; then
echo "$PIRHEUREJOUR,$PIRHEUREMOI,$PIRHEUREHEURE,$PIRHEUREMIN,0,ON,0" > $varpir/mesurepir.txt
				if [[ "$PIRLOG" == "ON" ]]; then 			
				echo "" > $varpir/mesurepirLOG.txt
				fi

fi

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
if [ "$DERPIRHEUREHEURE" -lt "$PIRLUMIEREOFFNUIT" ]; then
$PIRNEZ 1; $PIROEILDROIT 1; $PIROEILGAUCHE 1


	if [ "$DERPIRHEUREHEURE" -ge "$PIRHDEBUTPARLER" ]; then 

		if [ "$DERPIRHEUREHEURE" -lt "$PIRHFINPARLER" ]; then 

		clignotementled=$((1 + RANDOM%(6-1+1)))
		clignotementled1=$((1 + RANDOM%(6-1+1)))

		citationsLED=("$PIRNEZ 0; sleep 0.$clignotementled; $PIRNEZ 1" "$PIROEILDROIT 0; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILGAUCHE 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; sleep 0.$clignotementled1; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1" "$PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; sleep 0.$clignotementled1; $PIROEILDROIT 0; sleep 0.$clignotementled; $PIROEILDROIT 1; $PIROEILGAUCHE 0; sleep 0.$clignotementled; $PIROEILGAUCHE 1")
		citationsLED1=`echo "${citationsLED[$RANDOM % ${#citationsLED[@]} ]}"`
		eval $citationsLED1
		fi
	fi
$PIRNEZ 1; $PIROEILDROIT 1; $PIROEILGAUCHE 1
fi
}

#----------------------------------------------------------------------------

Traitement_Yeux_Nuit() {
if [ "$PIRHEUREHEURE" -ge "$PIRLUMIEREOFFNUIT" ] || [ "$PIRHEUREHEURE" -le "$PIRHDEBUTPARLER" ] ; then

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
PIRDIRE_REPAQH_OK_LIGNE=`echo -n $PIRDIRE_REPAQH  | grep -n '$PIRtraitementpour' | cut -d: -f1`
PIRDIRE_REPAQH_OK=`echo -n $PIRDIRE_REPAQH | grep ":" | cut -d' ' -f$PIR_DIRE_REP_AQH_Compt | sed -e "s/ //g"`
# echo "Je vais modifier le 1ou0 à 1 pour $PIRDIRE_REPAQH_OK"
# Je dois remplacer l"heure ou ca correspond dans fichier par un 1
PIRDIRE_REPAQH_OK_fichier1=`echo "$PIRDIRE_REPAQH_OK_fichier" | cut -c1-6`
PIRDIRE_REPAQH_OK_fichier1=`echo "$PIRDIRE_REPAQH_OK_fichier1 1" | sed -e "s/ //g"`
PIRDIRE_REPAQH_OK_ENREG=`echo "$PIRDIRE_REPAQH_OK_ENREG" | sed -e "s/$PIRDIRE_REPAQH_OK_fichier/$PIRDIRE_REPAQH_OK_fichier1/g"`
}

Traitement_total_heure_config() {

if test -z "$PIRDIRE_REPAQH"; then
return
else
PIR_DIRE_REP_AQH_TOTAL=`echo -n "$PIRDIRE_REPAQH" | grep ":" | wc -w`

PIR_DIRE_REP_AQH_Compt_heure_config=$(($PIR_DIRE_REP_AQH_Compt_heure_config + 1 ))

	if [ "$PIR_DIRE_REP_AQH_Compt_heure_config" -le "$PIR_DIRE_REP_AQH_TOTAL" ]; then 
	PIRDIRE_REPAQH_OK="$PIRDIRE_REPAQH_OK `echo "$PIRDIRE_REPAQH" | grep ":" | cut -d' ' -f $PIR_DIRE_REP_AQH_Compt_heure_config | sed -e "s/ //g"`,0"
	Traitement_total_heure_config
	fi
PIR_DIRE_REP_AQH_Compt_heure_config=""
fi
}

Traitement_total_heure_config_correspond() {
PIR_DIRE_REP_AQH_TOTAL=`echo -n "$PIRDIRE_REPAQH" | grep ":" | wc -w` # Nombre d'heure total à vérifier
PIR_DIRE_REP_AQH_Compt_heure_config=$(($PIR_DIRE_REP_AQH_Compt_heure_config + 1 ))
if [ "$PIR_DIRE_REP_AQH_Compt_heure_config" -le "$PIR_DIRE_REP_AQH_TOTAL" ]; then  # tan que c'est plus petit que le nombre d"heure total je boucle

PIRDIRE_REPAQH_OK=`echo "$PIRDIRE_REPAQH" | grep ":" | cut -d' ' -f$PIR_DIRE_REP_AQH_Compt_heure_config | sed -e "s/ //g"` # = heure du config
PIRDIRE_REPAQH_OK_FICHIEROK=`cat $varpir/$PIRtraitementpour.txt | cut -d',' -f5- | sed -e "s/,0//g" |  sed -e "s/,1//g" | cut -d' ' -f$(($PIR_DIRE_REP_AQH_Compt_heure_config +1 ))`   # = heure du fichier
	if [ "$PIRDIRE_REPAQH_OK" = "$PIRDIRE_REPAQH_OK_FICHIEROK" ]; then
	Traitement_total_heure_config_correspond
	else
	sudo rm "$varpir/$PIRtraitementpour.txt"
	PIR_DIRE_REP_AQH_Compt_heure_config=""
	PIRDIRE_REPAQH_OK=""
	Traitement_total_heure_config
	echo "0,$PIRHEUREJOUR,0,0,$PIRDIRE_REPAQH_OK" > $varpir/$PIRtraitementpour.txt 
	return
	fi
PIR_DIRE_REP_AQH_Compt_heure_config="0"
fi

}

valireheurefichiernumerox() {

# lit heure enregistré dans fichier texte du N° 1 à x x=variable
# if test -z "$PIR_DIRE_REP_AQH_Compt_fichier"; then
# return
# else
PIR_DIRE_REP_AQH_TOTAL_fichier=`echo -n $PIRDIRE_REPAQH_OK_ENREG | grep ":" | wc -w` 			 # combien d'heure à gerer au total ?
PIRDIRE_REPAQH_OK_fichier=`echo -n $PIRDIRE_REPAQH_OK_ENREG | grep ":" | cut -d' ' -f$PIR_DIRE_REP_AQH_Compt_fichier | sed -e "s/ //g"` # je récupère heure entière
PIRDIRE_REPAQH_OKMinutes_1ou0_fichier=`echo -n $PIRDIRE_REPAQH_OK_fichier | grep ":" | cut -d',' -f2-`		# je récupère si c'est fait ou pas 1 ou 0
PIRDIRE_REPAQH_OKHeure_fichier=`echo -n $PIRDIRE_REPAQH_OK_fichier | grep ":" | cut -d: -f1`		# je recupère que Heure
PIRDIRE_REPAQH_OKMinutes_fichier=`echo -n $PIRDIRE_REPAQH_OK_fichier | grep ":" | cut -d: -f2 | cut -d, -f1`		# je récupère que minute
# ### # echo "Dans le fichier $PIRtraitementpour il y a $PIR_DIRE_REP_AQH_TOTAL_fichier au total dont"
# ### # echo "$PIRDIRE_REPAQH_OK_fichier avec pour heure:$PIRDIRE_REPAQH_OKHeure_fichier minutes:$PIRDIRE_REPAQH_OKMinutes_fichier Excécuté ou pas ?: $PIRDIRE_REPAQH_OKMinutes_1ou0_fichier"
# fi
}

regardedanslajournée() {
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then 
jv_success "* Je traite: dans la journée... "
fi
matin=12
apresmidi=16
soiree=20
nuit=24

i=1
sortie=""

DERPIR_RELEVEE

if  [ $DERPIRHEUREMOI = "01" ]; then dateMois="Janvier"; fi
if  [ $DERPIRHEUREMOI = "02" ]; then dateMois="Février"; fi
if  [ $DERPIRHEUREMOI = "03" ]; then dateMois="Mars"; fi
if  [ $DERPIRHEUREMOI = "04" ]; then dateMois="Avril"; fi
if  [ $DERPIRHEUREMOI = "05" ]; then dateMois="Mai"; fi
if  [ $DERPIRHEUREMOI = "06" ]; then dateMois="Juin"; fi
if  [ $DERPIRHEUREMOI = "07" ]; then dateMois="Juillet"; fi
if  [ $DERPIRHEUREMOI = "08" ]; then dateMois="Aout"; fi
if  [ $DERPIRHEUREMOI = "09" ]; then dateMois="Septembre"; fi
if  [ $DERPIRHEUREMOI = "10" ]; then dateMois="Octobre"; fi
if  [ $DERPIRHEUREMOI = "11" ]; then dateMois="Novembre"; fi
if  [ $DERPIRHEUREMOI = "12" ]; then dateMois="Décembre"; fi

if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
jv_debug "Heure dernière mise en marche PIR à $DERPIRHEUREHEURE heure $DERPIRHEUREMIN le $DERPIRHEUREJOUR $dateMois"
fi
# jv_debug "il est actuellement $DERPIRHEUREHEURE heure $DERPIRHEUREMIN on est le $DERPIRHEUREJOUR / $DERPIRHEUREMOI"



# ---------------------- Le même jours alrme ok -----------------------
if [ $DERPIRHEUREJOUR = $PIRHEUREJOUR ]; then
	if [ $DERPIRHEUREHEURE -le $matin ]  # Si ALARME < MATIN = je suis bien sortie la matin 
	then
	sortie="... Vous vous êtes promenée ce matin ? c'est très  bien pour la forme..."

        elif [ $DERPIRHEUREHEURE -eq $matin ] ||  [ $DERPIRHEUREHEURE -eq $apresmidi ] ||  [ $DERPIRHEUREHEURE -eq $soiree ]    # Si ALARME = heure  = je viens juste de sortir 
        then
	sortie="... Vous venez juste de sortir, c'est très bien..."

	elif [ $DERPIRHEUREHEURE -gt $matin ] && [ $DERPIRHEUREHEURE -le $apresmidi ]  # Si ALARME > matin et ALARME < après midi = je  suis pas sortie l'après midi 
	then
	sortie="...c'est bien vous êtes sortie cette après-midi ?..." 

	elif [ $DERPIRHEUREHEURE -gt $apresmidi ] && [ $DERPIRHEUREHEURE -le $soiree ]  # Si ALARME > après midi et ALARME  < SOIREE je suis bien sortie l'après midi
	then
	sortie="...la promenade en soiréee était bien agréable ?"

	elif [ $DERPIRHEUREHEURE -le $matin ] && [ $DERPIRHEUREHEURE -le $apresmidi ] # Si ALARME < MATIN et ALARME < APRES MIDI = je ne suis pas sortie de la journée 
	then
	sortie="...et bien alors ?... vous n êtes pas sortie de la journée ? que se passe t-il ?..."
	fi

# jv_debug "message de sortie: $sortie"
fi



# ----------------------------------------------------------

# ---------------------- Si la veille l'alarme pasen marche 1 seul fois ! -----------------------


if [ $DERPIRHEUREJOUR -ne $PIRHEUREJOUR ]
then
if [[ "$PIRRETOURCONSOLE" == "ON" ]]; then
jv_warning "Pas de detection PIR depuis hier au moins..."
fi
        if [ $DERPIRHEUREHEURE -le $matin ] # Si ALARME < MATIN = je suis bien sortie la matin
        then
        sortie="... Depuis hier le $DERPIRHEUREJOUR $dateMois... à $DERPIRHEUREHEURE heure $DERPIRHEUREMIN..., vous nêtes pas sortie ?... Pour être en pleine forme faites plus de sport...oké ?" 

        elif [ $DERPIRHEUREHEURE -eq $matin ] ||  [ $DERPIRHEUREHEURE -eq $apresmidi ] ||  [ $DERPIRHEUREHEURE -eq $soiree ]  # Si ALARME = heure  = je viens juste de sortir
        then
        sortie="... vous devrier aller prendre l'air ça vous ferai beaucoup de bien... "


        elif [ $DERPIRHEUREHEURE -gt $matin ] && [ $DERPIRHEUREHEURE -le $apresmidi ] # Si ALARME > matin et ALARME < après midi = je  suis pas sortie l'après midi
        then
        sortie="... on dit quil faut aller marcher vingt minutes par jours... vous ne l'avez pas fait ?... sur ce..."

        elif [ $DERPIRHEUREHEURE -gt $apresmidi ] && [ $DERPIRHEUREHEURE -le $soiree ] # Si ALARME > après midi et ALARME  < SOIREE je suis bien sortie l'après midi
        then
        sortie="... Vous auriez du sortir même cinq minute prendre lair ?... demain vous le ferrez j'espère..."

        elif [ $DERPIRHEUREHEURE teH -le $matin ] && [ $DERPIRHEUREHEURE -le $apresmidi ] # Si ALARME < MATIN et ALARME < APRES MIDI = je ne suis pas sortie de la journée
        then
        sortie="... Je ne suis pas contente... personne ne serai sortie de la journé et hier non plus ?..."
        fi

# jv_debug "message de sortie: $sortie"
fi
# ----------------------------------------------------------


# Matin
if [ $PIRHEUREHEURE -le $matin ] && [[ $DERPIR_OPTION_MESURE -ne "matin" ]] #
then
PIR_OPTION_MESURE="matin"
moment="Bonjour monsieur et madame"
momentdire="Bonjour monsieur et madame" # |festival --tts
dire="$moment $sortie"

# après midi
elif [ $PIRHEUREHEURE -gt $matin ] && [ $PIRHEUREHEURE -le $apresmidi ]  && [[ $DERPIR_OPTION_MESURE -ne "midi" ]] 
then
PIR_OPTION_MESURE="midi"
momentdire="Bon après-midi monsieur et madame" # |festival --tts
moment="Bon Après midi monsieur et madame"
dire="$moment $sortie"

# soirée
elif [ $PIRHEUREHEURE -gt $apresmidi ] && [ $PIRHEUREHEURE -le $soiree ] && [[ $DERPIR_OPTION_MESURE -ne "soiree" ]] 
then
PIR_OPTION_MESURE="soiree"
momentdire="Bonne soirée monsieur et madame" # |festival --tts
moment="Bonne Soirée monsieur et madame"
dire="$moment $sortie"


# nuit
elif [ $PIRHEUREHEURE -gt $soiree ] && [ $PIRHEUREHEURE -le $nuit ] && [[ $DERPIR_OPTION_MESURE -ne "nuit" ]]
then
PIR_OPTION_MESURE="nuit"
momentdire="Bonne nuit les amoureux... faites de beaux rêves... " # |festival --tts
moment="Bonne nuit les amoureux... fêtes de beaux rêves... "
dire="$sortie $moment "

fi


phrase="Comment c'est passée  "

# jv_debug "Elle va dire:"

if test -n "$dire"; then say "$dire"; fi

if test -z $PIR_OPTION_MESURE; then PIR_OPTION_MESURE=$DERPIR_OPTION_MESURE; fi
}

DERPIR_RELEVEE() {
varpir="$jv_dir/plugins_installed/jarvis-plug-PIR/traitementPIR"
varpirconfig="$jv_dir/plugins_installed/jarvis-plug-PIR"
DERPIRHEUREJOUR=`cat $varpir/mesurepir.txt | cut -d',' -f1`
DERPIRHEUREMOI=`cat $varpir/mesurepir.txt | cut -d',' -f2`
DERPIRHEUREHEURE=`cat $varpir/mesurepir.txt | cut -d',' -f3`
DERPIRHEUREMIN=`cat $varpir/mesurepir.txt | cut -d',' -f4`
DERPIR_NBREFOIS_LAOUPAS=`cat $varpir/mesurepir.txt | cut -d',' -f5`
DERPIR_DATE_ENTIERE="$DERPIRHEUREMOI/$DERPIRHEUREJOUR/`date +"%y"`"
DERPIRHEUREMOI_ENTIER=`date -d "$DERPIRHEUREMOI_ENTIER" +"%B"`
DERPIRHEUREJOUR_Entier=`date -d "$DERPIR_DATE_ENTIERE" +"%A"`
REP_OPTIONLUOUPAS=`cat $varpir/mesurepir.txt | cut -d',' -f6`
DERPIR_OPTION_MESURE=`cat $varpir/mesurepir.txt | cut -d',' -f7`
}

jv_pg_ct_quefaitceci() {
DERPIR_RELEVEE
PIRHEUREJOUR=`date +%d`
if [ $DERPIRHEUREJOUR = $PIRHEUREJOUR ]; then
say "La dernière mesure relevé est aujourd'hui sur $DERPIR_OPTION_MESURE à $DERPIRHEUREHEURE heure $DERPIRHEUREMIN"
else

say "La dernière mesure relevé est à $DERPIR_OPTION_MESURE à $DERPIRHEUREHEURE heure $DERPIRHEUREMIN le $DERPIRHEUREJOUR_Entier $DERPIRHEUREJOUR $DERPIRHEUREMOI_ENTIER"
fi
}
