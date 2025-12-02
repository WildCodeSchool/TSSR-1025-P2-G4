#!/bin/bash

# Preparation des fonctions

function Main() {

# Connexion Prise en main à distance
    echo "Connexion Menu prise en main à distance... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    #./

}

function Feu() {

# Connexion Pare-feu
    echo "Connexion Menu pare-feu... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    #./

}

function Redemarrer() {

# Connexion Redémarrer
    echo "Connexion Menu redémarrer... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    #./

}

function Repertoire() {

# Connexion Gestion de répertoires
    echo "Connexion Menu gestion de répertoires... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    #./

}

function Retour() {

# Retour Menu Linux
    echo "Connexion Menu Linux... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    source ./menu_linux.sh

}

# Création d'une petite interface graphique 
clear
echo
echo "###############################################"
echo "###############################################"
echo "####                                       ####"
echo "####                                       ####"
echo "####               Module 1                ####"
echo "####             (Provisoire)              ####"
echo "####                                       ####"
echo "###############################################"
echo "###############################################"
echo 

while true 
do

    # Choix de l'action a éxécuter
    echo "Choississez quelle action effectuer. "
    echo
    echo "1) Menu prise en main à distance"
    echo "2) Menu pare-feu"
    echo "3) Menu redémarrage"
    echo "4) Menu gestion de répertoires"
    echo "5) Retour Menu Linux"
    echo "x) Sortir"
    echo 
    read -p "Votre choix : " action
    echo

    case $action in

        1)
            echo "Menu prise en main à distance"
            echo
            Main 
            break
            ;;

        2)
            echo "Menu pare-feu"
            echo
            Feu
            break
            ;;

        3)
            echo "Menu Redémarrage"
            echo
            Redemarrer
            break
            ;;
        
        4) 
            echo "Menu gestion de répertoires"
            echo
            Repertoire
            break
            ;;

        5)
            echo "Retour Menu Linux"
            echo
            Retour
            break
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