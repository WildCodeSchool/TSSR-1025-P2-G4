#!/bin/bash

#######################################################################################################
# Partie Suppression Utilisateur
#######################################################################################################

# echo "Le nom d'utilisateur entré n'existe pas."


while true
do
    sleep 3
    clear
    echo -e "\nBienvenue dans l'Espace Suppression Utilisateur !\n"
    echo -e "\nSouhaitez-vous supprimer l'utilisateur $user_name ?\n1 - Oui\n2 - Retour à l'Espace Personnel Utilisateur ?\nX - Sortir.\n"
    read -p "Votre choix : " del_user
    case "$del_user" in        
        1)  
            ssh -o ConnectTimeout=10 -T clilin01 "sudo userdel -r "$user_name" >/dev/null 2>&1"
            echo -e "\nL'Utilisateur $user_name ainsi que son répertoire personnel à été suprimé !\n"
            while true
            do
                sleep 3
                clear
                echo "Voulez-vous retourner à l'Espace Personnel Utilisateur ou sortir du script ? "
                echo -e "\n1 - Retour à l'Espace Personnel Utilisateur ?\n2 - Sortir.\n"
                read -p "Votre choix : " yes_del_user
                case "$yes_del_user" in
                    1)
                        echo -e "\nRetour à l'Espace Personnel Utilisateur...\n"
                        return
                    ;;
                    
                    2)
                        echo -e "\nA bientôt !\n"
                        exit 0
                    ;;
                    
                    *)
                        echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                        continue
                    ;;
                esac
            done
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