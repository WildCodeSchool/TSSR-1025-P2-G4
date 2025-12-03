#!/bin/bash

# Varible Linux et Windows

# UserLinux=172.16.40.30
# UserWindows=172.16.40.20


# Preparation des fonctions

function Linux() {

    # Connexion à la machine Linux
    echo "Connexion à la machine Linux... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    source menu_linux.sh 

}

function Windows() {

    # Connexion à la machine Windows
    echo "Connexion à la machine Windows... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    #source menu_windows.sh

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
echo "####             Menu serveur              ####"
echo "####                                       ####"
echo "####                                       ####"
echo "###############################################"
echo "###############################################"
echo 

    # Choix de la machine 
    echo "Chossissez dans quel machine client vous voulez aller. "
    echo
    echo "1) Linux "
    echo "2) Windows "
    echo "x) Sortir "
    echo
    read -p "Votre choix : " client
    echo

    case $client in

        1)
            echo "Machine Linux "
            echo
            Linux
            continue
            ;;
        
        2)
            echo "Machine Windows "
            echo
            Windows
            continue
            ;;

        x|X)
            echo "Au revoir "
            echo
            exit 0
            ;;

        *)
            echo "Choix invalide ! "
            echo
            echo " ---------------------------------------------- "
            echo
            ;;

    esac
done