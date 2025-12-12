#!/bin/bash

# Création des variables

NomMachine="$1"
IpMachine="$2"

# Preparation des fonctions

function Redemarrage() {

# Rédemarrage
    echo "Redémarrage de la machine... "
    echo
    echo " ---------------------------------------------- "
    echo
    Log "RedémarrageMachine"
    # Connexion ssh à la machine pour reboot
    ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" "shutdown /r /t 0 /f" 

}

# Suite de la fonction log pour suivre des utilistations du script

function Log() {

    local evenement="$1"
    local fichier_log="/var/log/log_evt.log"
    local date_actuelle=$(date +"%Y%m%d")
    local heure_actuelle=$(date +"%H%M%S")
    local utilisateur=$(whoami)

    # Format demandé <Date>_<Heure>_<Utilisateur>_<Evenement>
    local ligne_log="${date_actuelle}_${heure_actuelle}_${utilisateur}_${evenement}"

    # Ecriture dans le fichier
    echo "$ligne_log" | sudo tee -a "$fichier_log" > /dev/null 2>&1

}


# Suite du log

Log "NewScript"

# Création d'une petite interface graphique 

while true 
do

clear
echo
echo "###############################################"
echo "###############################################"
echo "####                                       ####"
echo "####                                       ####"
echo "####           Menu Redémarrage            ####"
printf "####  %-35s  ####\n" "$NomMachine" "$IpMachine"
echo "####                                       ####"
echo "###############################################"
echo "###############################################"
echo 

    # Choix de l'action a éxécuter
    echo "Choississez quelle action effectuer. "
    echo
    echo "1) Redémarrer la machine"
    echo "2) Retour Menu Module 1"
    echo "x) Sortir"
    echo 
    read -p "Votre choix : " redemarrer
    echo

    case $redemarrer in

        1)
            echo "Redémarrage de la machine"
            echo
            Redemarrage "$NomMachine" "$IpMachine"
            continue
            ;;

        2)
            echo "Retour Menu Module 1"
            echo
            echo "Connexion Module 1... "
            echo
            echo " ---------------------------------------------- "
            echo
            sleep 1
            Log "RetourMenuActionMachine"
            return
            ;;

        x|X)
            echo "Au revoir"
            echo 
            Log "EndScript"
            exit 0
            ;;

        *)
            echo "Choix invalide !"
            echo
            echo " ---------------------------------------------- "
            echo
            sleep 1
            Log "MauvaisChoix"
            ;;
        
    esac
done