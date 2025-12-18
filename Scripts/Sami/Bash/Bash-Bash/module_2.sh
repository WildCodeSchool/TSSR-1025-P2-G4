#!/bin/bash

#######################################################################################################
# Script Module 2 : Menu Gestion des Utilisateurs
#######################################################################################################


#Affichage de la machine distante et de son adresse IP
NomMachine="$1"
IpMachine="$2"


#Fonction Log
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


#######################################################################################################
# Bloc Principal
#######################################################################################################

Log "NewScript"

while true
do
    sleep 2
    clear
    echo ""
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
    Log "WelcomeToUserManagementMenu"
    echo -e "1 - Continuer dans le Menu Gestion des Utilisateurs.\n2 - Retourner dans le Menu Linux.\nX - Sortir.\n"
    read -p "Votre choix : " choice_menu_module_2
    case $choice_menu_module_2 in
        1)
            echo ""
            read -p "Entrez un Nom d'Utilisateur : " user_name
            
            if ssh -t -o ConnectTimeout=10 clilin01 "id '$user_name' &>/dev/null"
            then
                # Si l'utilisateur existe -> Espace Personnel Utilisateur
                clear
                echo -e "\nBon retour $user_name !\n\nRedirection vers l'Espace Personnel Utilisateur... "
                Log "UserEntryExists"
                Log "UserPersonnalAreaRedirection"
                source ~/scripts_debian/linux/menu_user_exist.sh
            else
                # S'il n'existe pas --> Espace Création Utilisateur
                clear
                echo -e "\nL'utilisateur $user_name n'existe pas.\n\nRedirection vers l'Espace Création Utilisateur..."
                Log "UserEntryDoesntExist"
                Log "UserCreationAreaRedirection"                
                source ~/scripts_debian/linux/create_user.sh
            fi
            continue
        ;;
        
        2)
            echo -e "\nRetour au Menu Linux..."
            Log "ReturnLinuxMenu"
            return
        ;;
        
        x|X)
            echo -e "\nA bientôt !\n"
            Log "EndScript"
            exit 0
        ;;
        
        *)
            clear
            echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            Log "InputError"
            continue
        ;;        
    esac
done