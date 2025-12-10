#!/bin/bash

while true
do
    sleep 3
    clear
    echo -e "Bienvenue dans l'espace Personnel Utilisateur !\n"
    echo -e "Que souhaitez-vous faire ?\n"
    echo -e "1 - Apporter des modifications à l'utilisateur $user_name.\n2 - Supprimer l'utilisateur $user_name.\n3 - Afficher des Infos sur l'utilisateur $user_name .\n4 - Retourner au Menu Gestion des Utilisateurs.\nX - Sortie.\n"
    read -p "Votre choix : " choice_menu_user_exist
    case $choice_menu_user_exist in
        1)
            echo -e "\nRedirection vers l'Espace Modification Utilisateur...\n"
            ~/Scripts/windows/modif_user.sh
            continue
        ;;
        
        2)
            echo -e "\nRedirection vers l'Espace Supression Utilisateur...\n"
            source del_user.sh
            return
        ;;
        
        3)
            echo -e "\nRedirection vers l'Espace Informations de l'Utilisateur...\n"
            source info_user.sh
            continue
        ;;
        
        4)
            echo -e "\nRetour au Menu Gestion des Utilisateurs...\n"
            return
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
