# "MesurePIR" est une variable qui donne l'état  OFF ou ON du capteur PIR
# Toutes 5 minutes crontab prend la mesure, de 8h à 21h du Lundi au Vendredi
# dans le crontab cette ligne c'est rajouté */5 8-21 * * 1-5 ~/jarvis/jarvis.sh -x "mesurepir"

PIROEILGAUCHE="gpio write 0" # GPIO Oeil Gauche
PIROEILDROIT="gpio write 2"  # GPIO Oeil Droit
PIRNEZ="gpio write 3"        # GPIO Nez

PIRHDEBUTPARLER="07"   # A partir de quelle heure mon PIR se réveille ? Il faut 2 chiffres !!
PIRHFINPARLER="20"     # A partir de quelle heure mon PIR ne parle plus ? Il faut 2 chiffres !!
PIRLUMIEREOFFNUIT="22" # A partir de quelle heure je mets en veille toutes mes lumières ??

# Divers traitements:
# 1)
PIR_traitement_pour="reveil"
PIR_DIRE_DEBUT="C'est bien on se reveil !"
PIR_DIRE_ORDER="météo puis fête à qui puis une citation" # Que doit t-il énoncé au réveil du matin ?
PIR_DIRE_FIN="Voilà bonne journée tout le monde"
PIR_DIRE_REP_AQH="19:00"

# 2)
PIDR_traitement_pour="prochainevenement"
PIDR_DIRE_DEBUT=""
PIDR_DIRE_ORDER="prochain évènement" # Que doit t-il énoncé au réveil du matin ?
PIDR_DIRE_FIN=""
PIDR_DIRE_REP_AQH=""



