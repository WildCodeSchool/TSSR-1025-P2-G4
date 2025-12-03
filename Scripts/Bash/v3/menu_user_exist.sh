#!/bin/bash

while true
do
    clear
    echo "Bienvenue $user_name !"
    echo -e "Que voulez-vous faire ?\n"
    echo -e "\n1 - Apporter des modifications à l'Utilisateur $user_name.\n2 - Supprimer l'Utilisateur $user_name.\n3 - Afficher des Infos sur l'Utilisateur $user_name .\n4 - Retourner au Menu Gestion des Utilisateurs.\n5 - Sortie."
    read -p "Votre choix : " choice_menu_user_exist
    case $choice_menu_user_exist in
        1)
            source modif_user.sh
            continue
        ;;
        
        2)
            source del_user.sh
            return
        ;;
        
        3)
            source info_user.sh
            continue
        ;;
        
        4)
            echo -e "\nRetour au Menu Gestion des Utilisateurs.\n"
            return
        ;;
        
        5)
            echo -e "\nA bientôt !\n"
            exit 0
        ;;
        
        *)
            echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            continue
        ;;
    esac
done
