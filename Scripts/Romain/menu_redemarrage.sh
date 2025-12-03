#!/bin/bash

# Preparation des fonctions

function Reboot() {

# Rédemarrage
    echo "Redémarrage de la machine... "
    echo
    echo " ---------------------------------------------- "
    echo
    # Connexion ssh à la machine pour reboot
    # ssh user@IP machine cible >/dev/null 2>&1
    sleep 1
    reboot
    

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
echo "####           Menu Redémarrage            ####"
echo "####                                       ####"
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
            Reboot
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
            ;;
        
    esac
done