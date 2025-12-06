#!/bin/bash

# Varible Linux et Windows

# Preparation des fonctions

function Linux() {

    # Connexion à la machine Linux

    cat $HOME/Scripts/ip_machine/linux/liste_ip.txt
    echo
    read -p "Rentrez le nom d'une machine : " NomMachine
    echo
    read -p "Puis rentrez son adresse IP : " AdresseIp
    echo

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
    echo "Connexion à la machine Linux... "
    echo
    echo " ---------------------------------------------- "
    echo
    sleep 1
    source menu_linux.sh $NomMachine $AdresseIp

}

function Windows() {

    # Connexion à la machine Windows
    cat $HOME/Scripts/ip_machine/linux/windows_ip.txt
    echo
    read -p "Rentrez le nom d'une machine : " NomMachine
    echo
    read -p "Puis rentrez son adresse IP : " AdresseIp
    echo

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
    echo "Connexion à la machine Linux... "
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
            echo "Machine Linux :"
            echo
            Linux
            continue
            ;;
        
        2)
            echo "Machine Windows :"
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
            continue
            ;;

    esac
done