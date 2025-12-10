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
        echo -e "Voulez-vous retourner au menu précédent ou sortir du script ?\n"
        echo -e "1 - Retour dans au Menu Gestion des Utilisateurs.\nX - Sortir.\n"
        read -p "Votre choix : " choice_return_end
        case "$choice_return_end" in
            1)
                echo -e "\nRetour dans l'Espace Modification Utilisateur..."
                break
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
}

while true
do
    sleep 3
    clear
    echo -e "\nBienvenue dans l'Espace Suppression Utilisateur !\n"
    echo -e "\nSouhaitez-vous supprimer l'utilisateur $user_name ?\n1 - Oui\n2 - Retour à l'Espace Personnel Utilisateur ?\nX - Sortir.\n"
    read -p "Votre choix : " del_user
    case "$del_user" in        
        1)  
            ssh -o ConnectTimeout=10 -T clilin01 "sudo -S userdel -r "$user_name" >/dev/null 2>&1"
            echo -e "\nL'utilisateur $user_name ainsi que son répertoire personnel à été suprimé !\n"
            end_user_return
            return
        ;;

        2)
            echo -e "\nRetour à l'Espace Personnel Utilisateur...\n"
            return
        ;;
        
        x|X)
            echo -e "\nA bientôt !\n"
            exit 0
        ;;
        
        *)
            echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            continue
        ;;
    esac
done