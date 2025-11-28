#!/bin/bash

# Preparation des fonctions

Module_1() {

    # Connexion au module 1
    echo "Connexion au module 1... "
    echo
    echo " ---------------------------------------------- "
    echo
    #./

}

Module_2() {

    # Connexion au module 2
    echo "Connexion au module 2... "
    echo
    echo " ---------------------------------------------- "
    echo
    #./

}

Module_3() { 

    # Connexion au module 3
    echo "Connexion au module 3... "
    echo
    echo " ---------------------------------------------- "
    echo
    #./

}

Serveur() { 

    # Retour Menu Serveur
    echo "Retour... "
    echo
    echo " ---------------------------------------------- "
    echo
    ./menu_serveur.sh


}

# Création d'une petite interface graphique 
clear
echo
echo "###############################################"
echo "###############################################"
echo "####                                       ####"
echo "####                                       ####"
echo "####             Menu Linux                ####"
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
    echo "1) Module_1 "
    echo "2) Module_2 "
    echo "3) Module_3 "
    echo "4) Retour Menu Serveur "
    echo "x) Sortir"
    echo
    read -p "Votre choix : " choix
    echo

    case $choix in

        1)
            echo "Module_1 "
            echo
            Module_1
            break
            ;;
        
        2)
            echo "Module_2 "
            echo
            Module_2
            break
            ;;

        3)
            echo "Module 3 "
            echo
            Module_3
            break
            ;;

        4)
            echo "Retour Menu Serveur "
            echo
            Serveur
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