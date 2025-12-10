#!/bin/bash

# -------------------------------------------------------------------------------------
# Module 2
# -------------------------------------------------------------------------------------

NomMachine="$1"
IpMachine="$2"

function Log() {

    local evenement="$1"
    local fichier_log="/var/log/log_evt.log"
    local date_actuelle=$(date +"%Y%m%d")
    local heure_actuelle=$(date +"%H%M%S")
    local utilisateur=$(whoami)

    # Format demandé <Date>_<Heure>_<Utilisateur>_<Evenement>
    local ligne_log="${date_actuelle}"_${heure_actuelle}_${utilisateur}_${evenement}

    # Ecriture dans le fichier
    echo "$ligne_log" | sudo tee -a "$fichier_log" > /dev/null 2>&1

}

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
            if ssh -o ConnectTimeout=10 -T clilin01 "id "$user_name" &>/dev/null"
            then
                clear
                echo -e "\nBon retour $user_name !\n\nRedirection vers l'Espace Personnel Utilisateur... "
                Log "UserEntryExists"
                Log "UserPersonnalAreaRedirection"
                source ~/scripts_debian/linux/menu_user_exist.sh
            else
                clear
                echo -e "\nL'utilisateur $user_name n'existe pas.\n\nRedirection vers l'Espace Création Utilisateur..."
                Log "UserEntryDoesntExist"
                Log "UserCreationAreaRedirection"                
                source ~/scripts_debian/linux/create_user.sh
            fi
            continue
        ;;
        
        2)
            echo "Retour au Menu Linux..."
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