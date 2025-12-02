#!/bin/bash

# Preparation des fonctions

function Reboot() {

# Rédemarrage
    echo "Redémarrage de la machine... "
    echo
    echo " ---------------------------------------------- "
    echo
    # Connexion ssh à la machine pour reboot
    # ssh user@IP machine cible
    sleep 1
    reboot
    

}

function Retour() {

# Retour Menu Linux
    echo "Connexion Module 1... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    source module_1.sh
    return
}






# Création d'une petite interface graphique 
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

while true 
do

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
            break
            ;;

        2)
            echo "Retour Menu Module 1"
            echo
            Retour
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