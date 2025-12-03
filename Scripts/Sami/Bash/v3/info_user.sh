#!/bin/bash

# au lieu de la recopier 4 fois je propose une fonction pour revenir au menu apres avoir eu sa premiere info sur l'utilisateur choisi
retour_menu() {
    while true
    do
        echo "Menu: désirez-vous d'autres informations sur l'utilisateur $user_name ?"
        echo "1 - Retourner au menu Informations sur l'utilisateur $user_name"
        echo "2 - Quitter le script"
        read -p "Choisissez une option : " choiceRec

        case "$choiceRec" in
            1)
                echo -e "\nRetour au Menu des Informations de l'Utilisateur\n"
                continue 2
                ;;
            2)
                echo -e "\nSortie du script."
                exit 0
                ;;
            *)
                echo -e "\nChoix invalide."
                ;;
        esac
    done
}

    while true
    do
        clear
        echo -e "Bienvenue dans le Menu des Informations de l'Utilisateur $user_name !\n"
        echo "1 - Date de la dernière connexion"
        echo "2 - Date de dernière modification du mot de passe"
        echo "3 - Liste des sessions ouvertes par l’utilisateur"
        echo "4 - Retour au Menu Modification de l'Utilisateur"
        echo -e "5 - Quitter le script\n"
        read -p "Choisissez une option : " choice

        case "$choice" in
            1)
                echo -e "\nDernière connexion de $user_name :"
                last -n 1 "$user_name"
                retour_menu
                ;;
            2)
                echo -e "\nDate de dernière modification du mot de passe :"
                chage -l "$user_name" | grep -i "last password change"
                retour_menu
                ;;
            3)
                echo -e "\nSessions ouvertes par $user_name :"
                loginctl list-sessions --no-legend --no-pager \
                awk -v user="$user_name" '$3 == user {print "user="$3, "uid="$2, "session="$1}'
                retour_menu
                ;;
            4)
                echo -e "\nRetour au Menu Modification de l'Utilisateur"
                return
                ;;
            5)
                echo -e "\nSortie du script."
                exit 0
                ;;
            *)
                echo -e "\nChoix invalide."
                continue
                ;;
        esac
    done
