#!/bin/bash


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

Log "NewScript"

while true
do
    sleep 2
    clear
    echo -e "\nBienvenue dans l'Espace Personnel Utilisateur !\n"
    Log "WelcomeToUserPersonnalArea"
    echo -e "Que souhaitez-vous faire ?\n"
    echo -e "1 - Apporter des modifications à l'utilisateur $user_name.\n2 - Supprimer l'utilisateur $user_name.\n3 - Afficher des Infos sur l'utilisateur $user_name .\n4 - Retourner au Menu Gestion des Utilisateurs.\nX - Sortie.\n"
    read -p "Votre choix : " choice_menu_user_exist
    case $choice_menu_user_exist in
        1)
            echo -e "\nRedirection vers l'Espace Modification Utilisateur...\n"
            Log "UserModificationAreaRedirection"
            source ~/scripts_debian/linux/modif_user.sh
            continue
        ;;
        
        2)
            echo -e "\nRedirection vers l'Espace Supression Utilisateur...\n"
            Log "UserDeletionAreaRedirection"
            source ~/scripts_debian/linux/del_user.sh
            if ssh -o ConnectTimeout=10 -T clilin01 "id "$user_name" &>/dev/null"
            then
                continue
            else
                echo -e "\nRetour au Menu Gestion des Utilisateurs...\n"
                Log "ReturnUserManagementMenu"
                return
            fi
        ;;
        
        3)
            echo -e "\nRedirection vers l'Espace Informations Utilisateur...\n"
            Log "UserInformationAreaRedirection"
            source ~/scripts_debian/linux/info_user.sh
            continue
        ;;
        
        4)
            echo -e "\nRetour au Menu Gestion des Utilisateurs...\n"
            Log "ReturnUserManagementMenu"
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
