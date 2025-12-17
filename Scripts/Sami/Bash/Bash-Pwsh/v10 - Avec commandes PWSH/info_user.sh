#!/bin/bash

# au lieu de la recopier 4 fois je propose une fonction pour revenir au menu apres avoir eu sa premiere info sur l'utilisateur choisi
function end_user_return()
{
    while true
    do
        sleep 2
        echo -e "Désirez-vous d'autres informations sur l'utilisateur $user_name ou sortir du script ?\n"
        echo "1 - Retourner au Menu de l'Espace Informations Utilisateur."
        echo -e "X - Sortie.\n"
        read -p "Votre choix : " choiceRec

        case "$choiceRec" in
            1)
                echo -e "\nRetour au Menu de l'Espace Informations de l'Utilisateur...\n"
                Log "ReturnUserInformationArea"
                break
                ;;

            x|X)
                echo -e "\nA bientôt !\n"
                Log "EndScript"
                exit 0
                ;;

            *)
                clear
                echo -e "\nErreur de saisie.\nVeuillez recommencer SVP."
                Log "InputError"
                continue
                ;;
        esac
    done
}

function Log() {

    local evenement="$1"
    local fichier_log="/var/log/log_evt.log"
    local date_actuelle=$(date +"%Y%m%d")
    local heure_actuelle=$(date +"%H%M%S")
    local utilisateur=$(whoami)

    # Format demandé <Date>_<Heure>_<Utilisateur>_<Evenement>
    local ligne_log="${date_actuelle}_${heure_actuelle}_${utilisateur}_${evenement}"

    # Ecriture dans le fichier
    echo "$ligne_log" | sudo tee -a "$fichier_log" > /dev/null 2>&1

}

Log "NewScript"

while true
do
    sleep 2
    clear
    echo -e "\nBienvenue dans l'Espace Informations Utilisateur !\n"
    Log "WelcomeToUserInformationArea"
    echo -e "Quelles informations désirez-vous connaître sur l'utilisateur $user_name ?\n"
    echo "1 - Date de la dernière connexion"
    echo "2 - Date de dernière modification du mot de passe"
    echo "3 - Liste des sessions ouvertes par l’utilisateur"
    echo "4 - Retour au Menu Modification de l'Utilisateur"
    echo -e "X - Quitter le script\n"
    read -p "Votre choix : " choice

    case "$choice" in
        1)
            echo -e "\nDernière connexion de $user_name :"
            if ssh -o ConnectTimeout=10 -T cliwin01 "Get-LocalUser -Name \"$user_name\" *>\$null"
            then
                ssh -o ConnectTimeout=10 -T cliwin01 "quser | Where-Object { \$_ -match \"$user_name\" } | Select-Object -First 1"
            else
                echo -e "\nIl n'y a eu aucune connexion de l'utilisateur $user_name.\n"
            fi
            Log "LastConnexion"
            end_user_return
            continue
        ;;

        2)
            echo -e "\nDate de dernière modification du mot de passe :"
            ssh -o ConnectTimeout=10 -T cliwin01 "(Get-LocalUser -Name \"$user_name\").PasswordLastSet"
            Log "DateLastPasswordChange"
            end_user_return
            continue
            ;;

        3)
            echo -e "\nSessions ouvertes par $user_name :"
            ssh -o ConnectTimeout=10 -T cliwin01 "quser | Where-Object { \$_ -match \"$user_name\" }"
            Log "ListOpenUserSessions"
            end_user_return
            continue
            ;;

        4)
            echo -e "\nRetour dans l'Espace Personnel Utilisateur..."
            Log "ReturnUserPersonnalArea"
            return
            ;;

        x|X)
            echo -e "\nA bientôt !\n"
            Log "EndScript"
            exit 0
            ;;

        *)
            clear
            echo -e "\nErreur de saisie.\nVeuillez faire selon ce qui est proposé"
            Log "InputError"
            continue
            ;;
    esac
done
