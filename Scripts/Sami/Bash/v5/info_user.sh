#!/bin/bash

# au lieu de la recopier 4 fois je propose une fonction pour revenir au menu apres avoir eu sa premiere info sur l'utilisateur choisi
retour_menu() {
    while true
    do
        sleep 3
        clear
        echo -e "Désirez-vous d'autres informations sur l'utilisateur $user_name ou sortir du script ?\n"
        echo "1 - Retourner au menu de l'Espace Informations Utilisateur."
        echo "X - Sortie."
        read -p "Choisissez une option : " choiceRec

        case "$choiceRec" in
            1)
                echo -e "\nRetour au Menu des Informations de l'Utilisateur...\n"
                break
                ;;

            x|X)
                echo -e "\nA bientôt !\n"
                exit 0
                ;;

            *)
                clear
                echo -e "\nErreur de saisie.\nVeuillez recommencer SVP."
                continue
                ;;
        esac
    done
}

    while true
    do
        sleep 3
        clear
        echo -e "\nBienvenue dans l'Espace Informations Utilisateur !\n"
        echo -e "Quelles informations désirez-vous connaître sur l'utilisateur $username ?\n"
        echo "1 - Date de la dernière connexion"
        echo "2 - Date de dernière modification du mot de passe"
        echo "3 - Liste des sessions ouvertes par l’utilisateur"
        echo "4 - Retour au Menu Modification de l'Utilisateur"
        echo -e "X - Quitter le script\n"
        read -p "Votre choix : " choice

        case "$choice" in
            1)
                echo -e "\nDernière connexion de $user_name :"
                ssh -o ConnectTimeout=10 -T clilin01 "sudo last -n 1 "$user_name""
                retour_menu
                continue
                ;;

            2)
                echo -e "\nDate de dernière modification du mot de passe :"
                ssh -o ConnectTimeout=10 -T clilin01 "sudo chage -l "$user_name" | grep -i "last password change""
                retour_menu
                continue
                ;;

            3)
                echo -e "\nSessions ouvertes par $user_name :"
                ssh -o ConnectTimeout=10 -T clilin01 "loginctl list-sessions --no-legend --no-pager"
                ssh -o ConnectTimeout=10 -T clilin01 "sudo awk -v user="$user_name" '$3 == user {print "user="$3, "uid="$2, "session="$1}'"
                retour_menu
                continue
                ;;

            4)
                echo -e "\nRetour dans l'Espace Personnel Utilisateur..."
                return
                ;;

            x|X)
                echo -e "\nA bientôt !\n"
                exit 0
                ;;

            *)
                clear
                echo -e "\nErreur de saisie.\nVeuillez faire selon ce qui est proposé"
                continue
                ;;
        esac
    done
