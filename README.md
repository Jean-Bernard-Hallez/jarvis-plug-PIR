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

Si vous avez la même configuration que moi un jarvis avec des leds et un detecteur de mouvement... voir ici:
https://github.com/Jean-Bernard-Hallez/jarvis-testjb/blob/master/Jarvis%20de%20JB-2.pdf


## Languages

* Français


## Usage

```
Vous pourrez alors configurer vous même ceci qui est l'exemple du mien:
PIROEILGAUCHE="gpio write 0" # GPIO Oeil Gauche
PIROEILDROIT="gpio write 2"  # GPIO Oeil Droit
PIRNEZ="gpio write 3"        # GPIO Nez

PIRHDEBUTPARLER="07"   # A partir de quelle heure mon PIR se réveille ? Il faut 2 chiffres !!
PIRHFINPARLER="20"     # A partir de quelle heure mon PIR ne parle plus ? Il faut 2 chiffres !!
PIRLUMIEREOFFNUIT="22" # A partir de quelle heure je mets en veille toutes mes lumières ??

Divers traitements:
1)
PIR_traitement_pour="reveil"
PIR_DIRE_DEBUT="C'est bien on se reveil !"
PIR_DIRE_ORDER="météo puis fête à qui puis une citation" # Que doit t-il énoncé au réveil du matin ?
PIR_DIRE_FIN="Voilà bonne journée tout le monde"
PIR_DIRE_REP_AQH=""

2)
PIDR_traitement_pour="prochainevenement"
PIDR_DIRE_DEBUT=""
PIDR_DIRE_ORDER="prochain évènement" # Que doit t-il énoncé au réveil du matin ?
PIDR_DIRE_FIN=""
PIDR_DIRE_REP_AQH=""

3)
PIR_traitement_pour="citation"
PIR_DIRE_DEBUT="Positif attitude:"
PIR_DIRE_ORDER="un proverbe" # Que doit t-il énoncé au réveil du matin ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="12"

Le soir à 20h00 il se met en mode silencieux
Le soir à 22 heures il coupe ses lumières et dort
Le matin à 7h00 il allume son "nez" pour dire qu'il est opérationnel et reprend la parole


A partir de 7h00 si je passe devant le détecteur de mouvement il me dit:
La météo et un proverbe

Dans la journée si je suis trop devant il me demande de dégourdir les jambes

A midi il me sort une citation

etc...

## Author
[Jean-Bernard Hallez](http://domotiquefacile.fr/jarvis/plugins/jarvis-plug-PIR)

