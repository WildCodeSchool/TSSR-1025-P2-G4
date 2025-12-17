#!/bin/bash

#######################################################################################################
# Partie Suppression Utilisateur
#######################################################################################################

# echo "Le nom d'utilisateur entré n'existe pas."

function end_user_return()
{
    while true
    do
        sleep 3
        clear
        echo -e "Voulez-vous retourner au au Menu Gestion des Utilisateurs ou sortir du script ?\n"
        echo -e "1 - Retour au Menu Gestion des Utilisateurs.\nX - Sortir.\n"
        read -p "Votre choix : " choice_return_end
        case "$choice_return_end" in
            1)
                break
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
}

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
    sleep 3
    clear
    echo -e "\nBienvenue dans l'Espace Suppression Utilisateur !\n"
    Log "WelcomeToUserDeletionArea"
    echo -e "\nSouhaitez-vous supprimer l'utilisateur $user_name ?\n1 - Oui, supprimer.\n2 - Retour à l'Espace Personnel Utilisateur ?\nX - Sortir.\n"
    read -p "Votre choix : " del_user
    case "$del_user" in        
        1)  
            ssh -o ConnectTimeout=10 -T clilin01 "sudo -S userdel -r "$user_name" >/dev/null 2>&1"
            echo -e "\nL'utilisateur $user_name ainsi que son répertoire personnel à été suprimé !\n"
            Log "UserDeletion"
            end_user_return
            return
        ;;

        2)
            echo -e "\nRetour à l'Espace Personnel Utilisateur...\n"
            Log "ReturnUserPersonnalArea"
            return
        ;;
        
        x|X)
            echo -e "\nA bientôt !\n"
            Log "EndScript"
            exit 0
        ;;
        
        *)
            echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            Log "InputError"
            continue
        ;;
    esac
done