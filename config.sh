# "MesurePIR" est une variable qui donne l'état  OFF ou ON du capteur PIR
# Toutes 5 minutes crontab prend la mesure, de 8h à 21h du Lundi au Vendredi
# dans le crontab cette ligne c'est rajouté */5 8-21 * * 1-5 ~/jarvis/jarvis.sh -x "mesurepir"

PIROEILGAUCHE="gpio write 0" # GPIO Oeil Gauche
PIROEILDROIT="gpio write 2"  # GPIO Oeil Droit
PIRNEZ="gpio write 3"        # GPIO Nez

PIRHDEBUTPARLER="06" # A partir de quelle heure mon PIR se réveille ? Il faut 2 chiffres !!
PIRHFINPARLER="18" # A partir de quelle heure mon PIR ne parle plus ? Il faut 2 chiffres !!
PIRDIREREVEIL="météo puis fête à qui puis une citation" # Que doit t-il énoncé au réveil du matin ?
