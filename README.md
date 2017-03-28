<!---
IMPORTANT
=========
This README.md is displayed in the WebStore as well as within Jarvis app
Please do not change the structure of this file
Fill-in Description, Usage & Author sections
Make sure to rename the [en] folder into the language code your plugin is written in (ex: fr, es, de, it...)
For multi-language plugin:
- clone the language directory and translate commands/functions.sh
- optionally write the Description / Usage sections in several languages
-->
## Description

28/03/2017 Fonctionnement du PIR indépendamment comme Alarme avec domoticz Par exemple / Meilleure stabilité du fonctionnement
Si vous avez la même configuration que moi un jarvis avec des leds et un detecteur de mouvement... voir ici:
https://github.com/Jean-Bernard-Hallez/jarvis-testjb/blob/master/Jarvis%20de%20JB-2.pdf


## Languages

* Français


## Usage

```
Vous pourrez alors configurer vous même ceci qui est l'exemple du mien:
PIROEILGAUCHE_GPIO="0"			 # GPIO Oeil Gauche
PIROEILDROIT_GPIO="2" 			 # GPIO Oeil Droit
PIRNEZ_GPIO="3"       			 # GPIO Nez
PIRDETECTEUR_GPIO="4" 			 # GPIO PIR
PIR_ALARME="ON"       			 # Si sur ON il ne se passe rien si sur ON il va lire le fichir ALARME.txt (ON OU OFF) si il est à ON PIR fonctionnera en conséquence 
PIRLOG="ON"          			 # ON = enregistre tous les état de pir OFF = ne le fait pas
PIRHDEBUTPARLER="07" 			 # A partir de quelle heure mon PIR se réveille ? Il faut 2 chiffres !!
PIRHFINPARLER="21"    			 # A partir de quelle heure mon PIR ne parle plus ? Il faut 2 chiffres !!
PIRLUMIEREOFFNUIT="22"			 # A partir de quelle heure je mets en veille toutes mes lumières ??
PIR_ACTION_TOUTES_LES="5" 		 # Si Pir à 1 tous les combiens de temps (exprimé en minute) je dois vérifier mes fonctions si dessous: 

# A chaque détection du PIR à 1
PIRACHAQUEDETECTION_ORDER="fais R2D2"  
PIRACHAQUEDETECTION_SAY=""    


#### Divers traitements: ####


# 1)
PIR_traitement_pour="reveil"
PIR_DIRE_DEBUT="C'est bien on se reveil !"
PIR_DIRE_ORDER="température chambre puis météo puis fête à qui puis prochainevenement puis une citation" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="Voilà bonne journée tout le monde"
PIR_DIRE_REP_AQH="08:00"

# 2)
PIR_traitement_pour="prochainevenement"
PIR_DIRE_DEBUT=""
PIR_DIRE_ORDER="prochain évènement" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="18:00"


# 3)
PIR_traitement_pour="citation"
PIR_DIRE_DEBUT="Positif attitude:"
PIR_DIRE_ORDER="une citation" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="12:00 15:40 19:00"

# 4)
PIR_traitement_pour="blague"
PIR_DIRE_DEBUT="La blague du jour:"
PIR_DIRE_ORDER="raconte une blague" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="ça t'as plu ?"
PIR_DIRE_REP_AQH="11:00 13:00 17:00"

# 5)
PIR_traitement_pour="pleinelune"
PIR_DIRE_DEBUT=""
PIR_DIRE_ORDER="prochaine pleine lune puis température chambre" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="20:35"

# 6)
PIR_traitement_pour="boldecafe"
PIR_DIRE_DEBUT="prépare un bol de café Préparation d'un bol de café en cours pour se réveiller ?"
PIR_DIRE_ORDER="" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="Bon appétit"
PIR_DIRE_REP_AQH="08:00"

# 7)
PIR_traitement_pour="tassecafe"
PIR_DIRE_DEBUT="C'est l'heure de la pause café...prépare une tasse de café"
PIR_DIRE_ORDER="" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="Bon appétit"
PIR_DIRE_REP_AQH="13:00"

# 8)
PIR_traitement_pour="temperature"
PIR_DIRE_DEBUT="Température"
PIR_DIRE_ORDER="température chambre" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="20:00"


Le soir à 20h00 il se met en mode silencieux
Le soir à 22 heures il coupe ses lumières et dort
Le matin à 7h00 il allume son "nez" pour dire qu'il est opérationnel et reprend la parole


A partir de 8h00 si je passe devant le détecteur de mouvement il me dit:
La météo (plugin), le prochain évènement (plugin) et un proverbe (plugin)

A 17h00 il raconte une blague

Dans la journée si je suis trop devant il me demande de dégourdir les jambes, il me parle justep our dire bonjour ou comment ca va...

A midi, 12h40 et 20h il me sort une citation, 



etc...

## Author
[Jean-Bernard Hallez](http://domotiquefacile.fr/jarvis/plugins/jarvis-plug-PIR)

