# "MesurePIR" est une variable qui donne l'état  OFF ou ON du capteur PIR
# Toutes 5 minutes crontab prend la mesure, de 8h à 21h du Lundi au Vendredi
# A EFFACER dans le crontab cette ligne c'est rajouté */5 8-21 * * 1-5 ~/jarvis/jarvis.sh -x "mesurepir"
# Avec plugin "jarvis-home-control" utilisera le mot "détecteur" pour le nom et numéroté l'adresse donnée pour le Pir-Virtuel ON/OFF (Domoticz Interupteur/Ajout manuel/Matériel Virtuel/Type Motion Sensor

PIRINSTALLE="OFF"                         # Est ce qu'un PIR est installé si oui ON si non OFF il faudra le sorcer en posant la question "Qu'est que tu as à me dire"
PIROEILGAUCHE_GPIO="0"			 # GPIO Oeil Gauche
PIROEILDROIT_GPIO="2" 			 # GPIO Oeil Droit
PIRNEZ_GPIO="3"       			 # GPIO Nez
PIRDETECTEUR_GPIO="4" 			 # GPIO PIR
PIR_ALARME="OFF"       			 # Si sur OFF il ne se passe rien si sur ON il va lire le fichir ALARME.txt (ON OU OFF) si il est à ON PIR fonctionnera en conséquence 
PIRLOG="ON"          			 # ON = LOG enregistre tous les état de pir OFF = ne le fait pas
PIRRETOURCONSOLE="ON"			 # ON = affiche tout retour de PIR en console OFF = cache tout
PIRHDEBUTPARLER="07" 			 # A partir de quelle heure mon PIR se réveille ? Il faut 2 chiffres !!
PIRHFINPARLER="21"    			 # A partir de quelle heure mon PIR ne parle plus ? Il faut 2 chiffres !!
PIRLUMIEREOFFNUIT="22"			 # A partir de quelle heure je mets en veille toutes mes lumières ??
PIR_ACTION_TOUTES_LES="5"                # Toutes les (en minute) et si PIR = 1 j'exécute tout ce qu'il y a ci dessous:

# A chaque détection du PIR à 1
PIRACHAQUEDETECTION_ORDER="fais le R2D2"  
PIRACHAQUEDETECTION_SAY=""    

# Divers traitements:
# 1)
PIR_traitement_pour="reveil"
PIR_DIRE_DEBUT="C'est bien on se réveil ! voici les températures:"
PIR_DIRE_ORDER="température chambre + météo + l'indice de pollution + fête à qui + AVERTIRSILENCEEVENEMENT + une citation" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="Voilà bonne journée tout le monde"
PIR_DIRE_REP_AQH="08:00"

# 2)
PIR_traitement_pour="actualite"
PIR_DIRE_DEBUT=""
PIR_DIRE_ORDER="actualité du jour" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="09:00"

# 3)
PIR_traitement_pour="prochainevenement"
PIR_DIRE_DEBUT=""
PIR_DIRE_ORDER="AVERTIRSILENCEEVENEMENT" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="18:00"


# 4)
PIR_traitement_pour="citation"
PIR_DIRE_DEBUT="Positif attitude:"
PIR_DIRE_ORDER="une citation" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="12:00 15:40 19:00"

# 5)
PIR_traitement_pour="blague"
PIR_DIRE_DEBUT="La blague du jour:"
PIR_DIRE_ORDER="raconte une blague" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="ça t'as plu ?"
PIR_DIRE_REP_AQH="11:00 13:00 17:00"

# 6)
PIR_traitement_pour="pleinelune"
PIR_DIRE_DEBUT=""
PIR_DIRE_ORDER="prochaine pleine lune + température chambre" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="20:35"

# 7)
PIR_traitement_pour="boldecafe"
PIR_DIRE_DEBUT="Préparation d'un bol de café pour se réveiller ?"
PIR_DIRE_ORDER="" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="Bon appétit"
PIR_DIRE_REP_AQH="08:00"

# 8)
PIR_traitement_pour="tassecafe"
PIR_DIRE_DEBUT="C'est l'heure de la pause café..."
PIR_DIRE_ORDER="Une tasse de café" # Que doit t-il énoncé  ?
PIR_DIRE_FIN="Bon appétit"
PIR_DIRE_REP_AQH="13:00"

# 9)
PIR_traitement_pour="temperature"
PIR_DIRE_DEBUT="Température"
PIR_DIRE_ORDER="température chambre" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="20:00"

# 10)
PIR_traitement_pour="traitementpucepique"
PIR_DIRE_DEBUT=""
PIR_DIRE_ORDER="AVERTIRPUCEPIQUERETARD" # Que doit t-il énoncé  ?
PIR_DIRE_FIN=""
PIR_DIRE_REP_AQH="20:00"