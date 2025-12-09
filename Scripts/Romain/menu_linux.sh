#!/bin/bash

# Création des variables

NomMachine=$1
IpMachine=$2

# Preparation des fonctions

function Module_1() {

    # Connexion au module 1
    echo "Connexion au module 1... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    Log "MenuActionMachine"
    # Sans oublié les arguments
    source module_1.sh "$NomMachine" "$IpMachine"

}

function Module_2() {

    # Connexion au module 2
    echo "Connexion au module 2... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    Log "MenuGestionDesUtilisateurs"
    # Sans oublié les arguments
    source module_2.sh "$NomMachine" "$IpMachine"

}

function Module_3() { 

    # Connexion au module 3
    echo "Connexion au module 3... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    Log "MenuInformationsMachine"
    # Sans oublié les arguments
    source module3.sh "$NomMachine" "$IpMachine"

}

# Suite de la fonction log pour suivre des utilistations du script

function Log() {

    local evenement="$1"
    local fichier_log="/var/log/log_evt.log"
    local date_actuelle=$(date +"%Y%m%d")
    local heure_actuelle=$(date +"%H%M%S")
    local utilisateur=$(whoami)

    # Format demandé <Date>_<Heure>_<Utilisateur>_<Evenement>
    local ligne_log="${date_actuelle}"_${heure_actuelle}_${utilisateur}_${evenement}

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
echo "####             Menu Linux                ####"
printf "####  %-35s  ####\n" "$NomMachine" "$IpMachine"
echo "####                                       ####"
echo "###############################################"
echo "###############################################"
echo 

    # Choix de la machine 
    echo "Chossissez dans quel machine client vous voulez aller. "
    echo
    echo "1) Menu action machine"
    echo "2) Menu gestion des utilisateurs"
    echo "3) Menu information machine"
    echo "4) Retour Menu Serveur"
    echo "x) Sortir"
    echo
    read -p "Votre choix : " module
    echo

    case $module in

        1)
            echo "Menu action machine"
            echo
            Module_1 "$NomMachine" "$IpMachine"
            Log "MenuActionMachine"
            continue
            ;;
        
        2)
            echo "Menu Gestion des Utilisateurs"
            echo
            Module_2 "$NomMachine" "$IpMachine"
            Log "MenuGestionDesUtilisateurs"
            continue
            ;;

        3)
            echo "Menu information machine"
            echo
            Module_3 "$NomMachine" "$IpMachine"
            Log "MenuInformationMachine"
            continue
            ;;

        4)
            echo "Retour Menu Serveur"
            echo
            echo "Connexion Menu Serveur... "
            echo
            echo " ---------------------------------------------- "
            echo
            sleep 1
            Log "RetourMenuServeur"
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