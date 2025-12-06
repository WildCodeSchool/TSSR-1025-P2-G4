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

    # Sans oublié les arguments
    source module3.sh "$NomMachine" "$IpMachine"

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
echo "####             Menu Linux                ####"
printf "####  %-35s  ####\n" "$NomMachine" "$IpMachine"
echo "####                                       ####"
echo "###############################################"
echo "###############################################"
echo 

    # Choix de la machine 
    echo "Chossissez dans quel machine client vous voulez aller. "
    echo
    echo "1) Module_1"
    echo "2) Module_2"
    echo "3) Module_3"
    echo "4) Retour Menu Serveur"
    echo "x) Sortir"
    echo
    read -p "Votre choix : " module
    echo

    case $module in

        1)
            echo "Module_1"
            echo
            Module_1 "$NomMachine" "$IpMachine"
            continue
            ;;
        
        2)
            echo "Module_2"
            echo
            Module_2 "$NomMachine" "$IpMachine"
            continue
            ;;

        3)
            echo "Module 3"
            echo
            Module_3 "$NomMachine" "$IpMachine"
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
            sleep 1
            ;;

    esac
done