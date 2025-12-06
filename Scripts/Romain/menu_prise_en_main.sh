#!/bin/bash

NomMachine="$1"
IpMachine="$2"

# Preparation des fonctions

function PriseEnMain() {

# Lancement de la prise en main distante
    echo "Lancement de la prise en main distante... "
    echo
    echo " ---------------------------------------------- "
    echo
    # Connexion ssh à la machine pour reboot
    ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine"


}


# Création d'une petite interface graphique 

while true 
do

clear
echo
echo "###############################################"
echo "###############################################"
echo "####                                       ####"
echo "####                                       ####"
echo "####      Menu Prise en main distante      ####"
printf "####  %-35s  ####\n" "$NomMachine" "$IpMachine"
echo "####                                       ####"
echo "###############################################"
echo "###############################################"
echo 

    # Choix de l'action a éxécuter
    echo "Choississez quelle action effectuer. "
    echo
    echo "1) Prise en main distante"
    echo "2) Retour Menu Module 1"
    echo "x) Sortir"
    echo 
    read -p "Votre choix : " redemarrer
    echo

    case $redemarrer in

        1)
            echo "Prise en main distante en CLI"
            echo
            PriseEnMain "$NomMachine" "$IpMachine"
            ;;

        2)
            echo "Retour Menu Module 1"
            echo
            echo "Connexion Module 1... "
            echo
            echo " ---------------------------------------------- "
            echo
            sleep 1
            return
            ;;

        x|X)
            echo "Au revoir"
            echo 
            exit 0
            ;;

        *)
            echo "Choix invalide !"
            echo
            echo " ---------------------------------------------- "
            echo
            continue
            ;;
        
    esac
done