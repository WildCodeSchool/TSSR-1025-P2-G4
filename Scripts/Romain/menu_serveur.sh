#!/bin/bash

# Preparation des fonctions

function Linux() {

    # Connexion à la machine Linux

    # Recherche via nmap pour trouver les IP du réseau
    nmap -sn -R 192.10.10.0/24 | awk '/Nmap scan report/{print $5, $6}'
    #nmap -sn -R 172.16.40.0/24 | awk '/Nmap scan report/{print $5, $6}'
    echo
    # Saisie rentrdee l'IP pour la création d'une variable
    read -p "Rentrez une adresse IP : " AdresseIp
    echo
    # On recupere le nom des utilisateurs sur la machine cible
    #ssh -o ConnectTimeout=10 -T clilin01 "getent passwd" 2>/dev/null | awk -F: '$3>=1000 {print $1}'
    #ssh -o ConnectTimeout=10 -T clilin01 "cat /etc/group" | grep "sudo"
    cat /etc/group | grep "sudo"
    echo
    # Saisie du nom d'utilisateur pour la création d'une variable
    read -p "Puis rentrez un nom d'utilisateur : " NomMachine
    echo

    # Test de réponse avec la machine
    if ping -c 2 $AdresseIp >/dev/null 2>&1
    then
        echo "Ping OK"
        sleep 0.5
    else
        echo "Ping échoué"
        sleep 0.5
        return 1
    fi

    # Connexion initié
    echo
    echo "Connexion à la machine Linux... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    source menu_linux.sh $NomMachine $AdresseIp

}

function Windows() {

    # Connexion à la machine Windows

    # Recherche via nmap pour trouver les IP du réseau
    nmap -sn -R 172.16.40.0/24 | awk '/Nmap scan report/{print $5, $6}'
    echo
    # Saisie rentrdee l'IP pour la création d'une variable
    read -p "Rentrez une adresse IP : " AdresseIp
    echo
    # On recupere le nom des utilisateurs sur la machine cible
    ssh -o ConnectTimeout=10 -T machine_windows "getent passwd" 2>/dev/null | awk -F: '$3>=1000 {print $1}'
    echo
    # Saisie du nom d'utilisateur pour la création d'une variable
    read -p "Puis rentrez le nom d'un Administrateur : " NomMachine

    if ping -c 2 $AdresseIp >/dev/null 2>&1
    then
        echo "Ping OK"
        sleep 0.5
    else
        echo "Ping échoué"
        sleep 0.5
        return 1
    fi

    echo
    echo "Connexion à la machine windows... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    source menu_windows.sh $NomMachine $AdresseIp
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
            echo "Machines Linux :"
            echo
            Linux
            continue
            ;;
        
        2)
            echo "Machines Windows :"
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
            sleep 1
            ;;

    esac
done