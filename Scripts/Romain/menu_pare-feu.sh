#!/bin/bash

# Création des variables

NomMachine="$1"
IpMachine="$2"

# Preparation des fonctions

function Etat() {

# Etat du pare-feu
    echo "Le pare-feu est : "
    # Cette commande donne l'état du pare feu sur la machine cible
    ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" "sudo ufw status verbose"
    sleep 4

}

function Activation() {

# Activation du pare-feu
    echo "Activation du pare-feu... "
    echo
    echo " ---------------------------------------------- "
    echo
    # Connexion ssh à la machine pour activé le pare-feu
    # Attention au sudo
    ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" "sudo ufw enable"
    sleep 2

}

function Desactivation() {

# Activation du pare-feu
    echo "Desactivation du pare-feu... "
    echo
    echo " ---------------------------------------------- "
    echo
    # Connexion ssh à la machine pour désactivé le pare-feu
    # Attention au sudo
    ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" "sudo ufw disable"
    sleep 2

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
echo "####            Menu Pare-feu              ####"
printf "####  %-35s  ####\n" "$NomMachine" "$IpMachine"
echo "####                                       ####"
echo "###############################################"
echo "###############################################"
echo 

    # Choix de l'action a éxécuter
    echo "Choississez quelle action effectuer. "
    echo
    echo "1) Etat du pare-feu"
    echo "2) Activer le pare-feu"
    echo "3) Desactiver le pare-feu"
    echo "4) Retour Module 1"
    echo "x) Sortir"
    echo 
    read -p "Votre choix : " redemarrer
    echo

    case $redemarrer in

        1)
            echo "Etat du pare-feu"
            echo
            Etat "$NomMachine" "$IpMachine"
            continue
            ;;

        2)
            echo "Activer le pare-feu"
            echo
            Activation "$NomMachine" "$IpMachine"
            continue
            ;;

        3)
            echo "Désactiver le pare-feu"
            echo
            Desactivation "$NomMachine" "$IpMachine"
            continue
            ;;

        4)
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
            sleep 1
            ;;
        
    esac
done