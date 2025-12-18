#!/bin/bash

#######################################################################################################
# Partie Suppression Utilisateur
#######################################################################################################


#Fonction retour
function end_user_return()
{
    while true
    do
        sleep 2
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
#Bloc principal
#######################################################################################################

Log "NewScript"

while true
do
    sleep 2
    clear
    echo -e "\nBienvenue dans l'Espace Suppression Utilisateur !"
    Log "WelcomeToUserDeletionArea"
    echo -e "\nSouhaitez-vous supprimer l'utilisateur $user_name ?\n\n1 - Oui, supprimer.\n2 - Retour à l'Espace Personnel Utilisateur ?\nX - Sortir.\n"
    read -p "Votre choix : " del_user
    case "$del_user" in        
        1)  
            #Suppression utilisateur ainsi que son répertoire personnel
            ssh -t -o ConnectTimeout=10 cliwin01 "Remove-LocalUser -Name '$user_name'; Remove-Item \"C:\\Users\\$user_name\" -Recurse -Force -ErrorAction SilentlyContinue"
            echo -e "\nL'utilisateur $user_name ainsi que son répertoire personnel a été supprimé !\n"
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