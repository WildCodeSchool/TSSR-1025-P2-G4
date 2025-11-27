#!/bin/bash

# Preparation des fonctions

Linux() {

    # Connexion à la machine Linux
    echo "Connexion à la machine Linux... "
    echo
    echo " ---------------------------------------------- "
    ./menu_linux.sh
    # local ssh $USERNAME@$HOSTNAME

}

Windows() {

    # Connexion à la machine Windows
    echo "Connexion à la machine Windows... "
    echo
    echo " ---------------------------------------------- "
    #./menu_windows.sh
    # local ssh $USERNAME@$HOSTNAME

}

# Création d'une petite interface graphique 
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

while true
do 

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
            #./menu_linux.sh
            break
            ;;
        
        2)
            echo "Machine Windows "
            echo
            Windows
            #./menu_windows.sh
            break
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