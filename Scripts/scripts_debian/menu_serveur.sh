#!/bin/bash

# Preparation des fonctions

function Linux() {

    # Connexion à la machine Linux

    # Recherche via nmap pour trouver les IP du réseau
    Log "RecuperationIP"

    #commande machine test
    #nmap -sn -R 192.10.10.0/24 | awk '/Nmap scan report/{print $5, $6}'

    nmap -sn -R 172.16.40.0/24 | awk '/Nmap scan report/{print $5, $6}'
    echo
    # Saisie rentrdee l'IP pour la création d'une variable
    read -p "Rentrez une adresse IP : " AdresseIp
    echo
    # On recupere le nom des utilisateurs sur la machine cible
    Log "RecuperationCompteAdmin"
    #ssh -o ConnectTimeout=10 -T clilin01 "getent passwd" 2>/dev/null | awk -F: '$3>=1000 {print $1}'
    ssh -o ConnectTimeout=10 -T clilin01 "cat /etc/group" | grep "sudo"
    
    #commande machine test
    #ssh -o ConnectTimeout=10 -T romii@192.10.10.20 "cat /etc/group" | grep "sudo"
    #commande machine test
    #cat /etc/group | grep "sudo"

    # Saisie du nom d'utilisateur pour la création d'une variable
    echo
    read -p "Puis rentrez un nom d'utilisateur : " NomMachine
    echo

    # Test de réponse avec la machine
    Log "Ping"
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
    Log "ConnexionMachineLinux"
    sleep 1
    source ~/scripts_debian/linux/menu_linux.sh $NomMachine $AdresseIp

}

function Windows() {

    # Connexion à la machine Windows

    # Recherche via nmap pour trouver les IP du réseau
    Log "RecuperationIP"

    #commande machine test
    #nmap -sn -R 192.10.10.0/24 | awk '/Nmap scan report/{print $5, $6}'

    nmap -sn -R 172.16.40.0/24 | awk '/Nmap scan report/{print $5, $6}'
    echo
    # Saisie rentrdee l'IP pour la création d'une variable
    read -p "Rentrez une adresse IP : " AdresseIp
    echo
    # On recupere le nom des utilisateurs sur la machine cible
    Log "RecuperationCompteAdmin"
    ssh -o ConnectTimeout=10 -T cliwin01 "Get-LocalGroupMember -Group Administrateurs | Select-Object Name"
    echo

    if [$? -ne 0 ]
    then    
        ssh -o ConnectTimeout=10 -T cliwin01 "Get-LocalGroupMember -Group Administrators | Select-Object Name"
    fi
    echo

    #commande machine test
    #ssh -o ConnectTimeout=10 -T romain@192.10.10.10 "(Get-LocalGroupMenber -Name "Administrateurs")"

    # Saisie du nom d'utilisateur pour la création d'une variable
    read -p "Puis rentrez un nom d'utilisateur : " NomMachine
    echo

    # Test de réponse avec la machine
    Log "Ping"
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
    source ~/scripts_debian/windows/menu_windows.sh $NomMachine $AdresseIp 
}

# Ajout d'une fonction log pour créer un suivis des utilistations du script

function Log() {

    local evenement="$1"
    local fichier_log="/var/log/log_evt.log"
    local date_actuelle=$(date +"%Y%m%d")
    local heure_actuelle=$(date +"%H%M%S")
    local utilisateur=$(whoami)

    # Format demandé <Date>_<Heure>_<Utilisateur>_<Evenement>
    local ligne_log="${date_actuelle}_${heure_actuelle}_${utilisateur}_${evenement}"

    # Ecriture dans le fichier
    echo "$ligne_log" | sudo tee -a "$fichier_log" > /dev/null 2>&1

}


# Début du log

Log "StartScript"


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
            Log "MenuSelectionLinux"
            Linux
            continue
            ;;
        
        2)
            echo "Machines Windows :"
            echo
            Log "MenuSelectionWindows"
            Windows
            continue
            ;;

        x|X)
            echo "Au revoir "
            echo
            Log "EndScript"
            exit 0
            ;;

        *)
            echo "Choix invalide ! "
            echo
            echo " ---------------------------------------------- "
            echo
            sleep 1
            Log "MauvaisChoix"
            ;;

    esac
done
