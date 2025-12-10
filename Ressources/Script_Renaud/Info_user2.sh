#!/bin/bash

# au lieu de la recopier 4 fois je propose une fonction pour revenir au menu apres avoir eu sa premiere info sur l'utilisateur choisi
retour_menu() {
    while true; do
        echo "Menu: désirez-vous d'autres informations sur l'utilisateur "$user_name?""
        echo "1 - Retourner au menu Informations sur l'utilisateur "$user_name""
        echo "2 - Quitter le script"
        read -p "Choisissez une option : "choiceRec

        case "$choiseRec" in
            1)
                # On revient au menu de informations sur utilisateurs
                 break 
                ;;
            2)
                echo "Sortie du script."
                exit 0
                ;;
            *)
                echo "Choix invalide."
                ;;
        esac
    done
}
 
    while true; do
        echo "Menu: informations sur l'utilisateur $user_name"
        echo "1 - Date de la dernière connexion"
        echo "2 - Date de dernière modification du mot de passe"
        echo "3 - Liste des sessions ouvertes par l’utilisateur"
        echo "4 - Retour au menu Gestion des utilisateurs"
        echo "5 - Quitter le script"
        read -p "Choisissez une option : " choice

        case "$choice" in
            1)
                echo "Dernière connexion de $user_name :"
                last -n 1 "$user_name"
                retour_menu
                ;;
            2)
                echo "Date de dernière modification du mot de passe :"
                chage -l "$user_name" | grep -i "last password change"
                retour_menu
                ;;
            3)
                echo "Sessions ouvertes par $user_name :"
                loginctl list-sessions --no-legend --no-pager \
                  | awk -v user="$user_name" '$3 == user {print "user="$3, "uid="$2, "session="$1}'
                retour_menu
                ;;
            4)
                # Retour au menu gestion des utilisateurs 
                break
                
                ;;
            5)
                echo "Sortie du script."
                exit 0
                ;;
            *)
                echo "Choix invalide."
                ;;
        esac
    done
