#!/bin/bash

#######################################################################################################
# Partie Suppression Utilisateur
#######################################################################################################

# echo "Le nom d'utilisateur entré n'existe pas."


while true
do
    echo -e "\nBienvenue dans la Partie Suppression Utilisateur !\n"
    echo -e "\nVoulez-vous le Supprimer ?\n1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs ?\n4 - Sortir.\n"
    read -p "Votre choix : " del_user
    case "$del_user" in
        
         1)  
            sudo userdel -r "$user_name"
            echo "L'Utilisateur $user_name ainsi que son repertoire personnel à été suprimé !"
            while true
            do

        2)
            echo "L'Utilisateur $user_name n'a pas été suprimé."
            while true
            do
                echo "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? "
                echo -e "\1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                read -p "Votre choix : " not_del_user
                case "$not_del_user" in
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
        
        3)
            echo "Retour au Menu Gestion des Utilisateurs..."
            return
        ;;
        
        4)
            echo "A bientôt !"
            exit 0
        ;;
        
        *)
            echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            continue
        ;;
    esac
done