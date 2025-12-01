#!/bin/bash

# -------------------------------------------------------------------------------------
# Module 2
# -------------------------------------------------------------------------------------
while true
do
    echo "Bienvenue dans le Menu Gestion des Utilisateurs."
    echo -e "1 - Pour rester dans le Menu Gestion des Utilisateurs.\n2 - Retourner dans le Menu Linux.\n3 - Sortir."
    read -p "Votre choix : " choice_menu_module_2
    case $choice_menu_module_2 in
        1)
            read -p "Entrez un Nom d'Utilisateur : " user_name
            if id "$user_name" &>/dev/null
            then
                source menu_user_exist.sh
            else
                echo -e "L'utilisateur n'existe pas.\nRedirection vers l'espace Création d'Utilisateur."
                source create_user.sh
            fi
            continue
        ;;
        
        2)
            echo "Retour au Menu Linux..."
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