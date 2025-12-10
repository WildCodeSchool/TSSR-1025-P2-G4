#!/bin/bash

#######################################################################################################
# Partie Suppression Utilisateur
#######################################################################################################

# echo "Le nom d'utilisateur entré n'existe pas."


while true
do  
    clear
    echo -e "\nBienvenue dans la Partie Suppression Utilisateur !\n"
    echo -e "\nVoulez-vous le Supprimer ?\n1 - Oui\n2 - Retour au Menu Gestion des Utilisateurs ?\n3 - Sortir.\n"
    read -p "Votre choix : " del_user
    case "$del_user" in        
        1)  
            userdel -r "$user_name"
            echo "L'Utilisateur $user_name ainsi que son répertoire personnel à été suprimé !"
            while true
            do
                echo "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? "
                echo -e "\1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                read -p "Votre choix : " yes_del_user
                case "$yes_del_user" in
                    1)
                        echo "Retour au Menu Gestion des Utilisateurs..."
                        return
                    ;;
                    
                    2)
                        echo "A bientôt !"
                        exit 0
                    ;;
                    
                    *)
                        echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                        continue
                    ;;
                esac
            done
        ;;

        2)
            echo "Retour au Menu Gestion des Utilisateurs..."
            return
        ;;
        
        3)
            echo "A bientôt !"
            exit 0
        ;;
        
        *)
            echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            continue
        ;;
    esac
done