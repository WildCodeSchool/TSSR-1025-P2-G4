#!/bin/bash

# -------------------------------------------------------------------------------------
# Module 2
# -------------------------------------------------------------------------------------

NomMachine="$1"
IpMachine="$2"

while true
do
    sleep 3
    clear
    echo "###############################################"
    echo "###############################################"
    echo "####                                       ####"
    echo "####                                       ####"
    echo "####     Menu Gestion des Utilisateurs     ####"
    printf "####  %-35s  ####\n" "$NomMachine" "$IpMachine"
    echo "####                                       ####"
    echo "####                                       ####"
    echo "###############################################"
    echo "###############################################"
    echo -e "\nBienvenue dans le Menu Gestion des Utilisateurs.\n"
    echo -e "1 - Continuer dans le Menu Gestion des Utilisateurs.\n2 - Retourner dans le Menu Linux.\nX - Sortir.\n"
    read -p "Votre choix : " choice_menu_module_2
    case $choice_menu_module_2 in
        1)
            echo ""
            read -p "Entrez un Nom d'Utilisateur : " user_name
            if ssh -o ConnectTimeout=10 -T clilin01 "sudo id "$user_name" &>/dev/null"
            then
                clear
                echo -e "\nBon retour $user_name !\n\nRedirection vers l'espace Personnel Utilisateur... "
                source menu_user_exist.sh
            else
                clear
                echo -e "\nL'utilisateur n'existe pas.\n\nRedirection vers l'espace Création Utilisateur..."
                source create_user.sh
            fi
            continue
        ;;
        
        2)
            echo "Retour au Menu Linux..."
            return
        ;;
        
        x|X)
            echo -e "\nA bientôt !\n"
            exit 0
        ;;
        
        *)
            clear
            echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            continue
        ;;
        
    esac
done