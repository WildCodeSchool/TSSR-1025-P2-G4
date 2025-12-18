#!/bin/bash

#####################################################################################################################################################################
# Partie Gestion des Répertoires
#####################################################################################################################################################################


#Affichage de la machine distante et de son adresse IP
NomMachine="$1"
IpMachine="$2"


#Fonction retour
function end_rep_return()
{
    while true
    do
        sleep 2
        clear
        echo -e "Voulez-vous retourner au Menu Gestion des Répertoires ou sortir du script ?\n"
        echo -e "1 - Retour au Menu Gestion des Répertoires.\nX - Sortir.\n"
        read -p "Votre choix : " choice_return_end
        case "$choice_return_end" in
            1)
                echo -e "\nRetour au Menu Gestion des Répertoires..."
                Log "ReturnDirectoryManagementMenu"
                break
            ;;
                                
            x|X)
                echo -e "\nA bientôt !\n"
                Log "EndScript"
                exit 0
            ;;
                                
            *)
                clear
                echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                Log "InputError"
                continue
            ;;
        esac
    done
}


#Fonction Log
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


#######################################################################################################
#Bloc principal
#######################################################################################################

Log "NewScript"

while true
do
    sleep 2
    clear
    echo ""
    echo "###############################################"
    echo "###############################################"
    echo "####                                       ####"
    echo "####                                       ####"
    echo "####     Menu Gestion des Répertoires      ####"
    printf "####  %-35s  ####\n" "$NomMachine" "$IpMachine"
    echo "####                                       ####"
    echo "####                                       ####"
    echo "###############################################"
    echo "###############################################"
    echo -e "\nBienvenue dans le Menu Gestion des Répertoires.\n"
    Log "WelcomeToDirectoryManagementMenu"
    echo -e "Que souhaitez-vous faire ?\n"
    echo -e "1 - Créer un répertoire.\n2 - Renommer un répertoire.\n3 - Supprimer un répertoire.\n4 - Retourner au Menu Action Machine.\nX - Sortir.\n"
    read -p "Votre choix : " choice_menu_gestion_rep
    case $choice_menu_gestion_rep in
        1)
            while true
            do
                sleep 2
                clear
                echo ""
                read -p "Entrez le chemin complet du répertoire à créer (Exemple : C:\User\monUtilisateur\monRépertoire) : " rep_name
                
                #Vérification si le répertoire saisi est correcte et non vide
                if [[ "$rep_name" != C:\\* || -z "$rep_name" ]]
                then
                    clear
                    echo -e "\nAttention !\nVous n'avez rien saisi ou la saisie est incorrecte !\n\nVeuillez recommencer SVP."
                    Log "InputError"
                    continue

                #Vérification si le répertoire saisi existe déjà
                elif ssh -t -o ConnectTimeout=10 cliwin01 "Test-Path -Path '$rep_name' -PathType Container"
                then
                    clear
                    echo -e "\nAttention ! Le répertoire $rep_name existe déjà !"
                    Log "DirectoryEntryAlreadyExists"
                    end_rep_return
                    continue 2
                else
                    #Création du répertoire saisi
                    ssh -t -o ConnectTimeout=10 cliwin01 "New-Item -Path '$rep_name' -ItemType Directory -Force -ErrorAction SilentlyContinue"
                    echo -e "\nRépertoire $rep_name créé avec succès !\n"
                    Log "DirectoryCreated"
                    end_rep_return
                    continue 2
                fi
            done
        ;;

        2)
            while true
            do
                sleep 2
                clear
                echo ""
                read -p "Entrez le chemin complet du répertoire à renommer/modifier (Exemple : C:\User\monUtilisateur\monRépertoire) : " rep_rename
                echo ""

                #Vérification si le répertoire saisi est correcte et non vide
                if [[ "$rep_rename" != C:\\* || -z "$rep_rename" ]]
                then
                    clear
                    echo -e "\nAttention !\nVous n'avez rien saisi ou la saisie est incorrecte !\n\nVeuillez recommencer SVP."
                    Log "InputError"
                    continue

                #Vérification si le répertoire saisi existe
                elif ! ssh -t -o ConnectTimeout=10 cliwin01 "Test-Path -Path '$rep_rename' -PathType Container"
                then
                    clear
                    echo -e "\nAttention ! Le répertoire $rep_rename n'existe pas !\n"
                    Log "DirectoryEntryDoesntExist"
                    end_rep_return
                    continue 2
                else
                    read -p "Entrez le nouveau chemin complet du répertoire à renommer (Exemple : C:\User\monUtilisateur\monRépertoire) : " new_rep_name

                    #Vérification si le nouveau répertoire saisi est correcte et non vide
                    if [[ "$new_rep_name" != C:\\* || -z "$new_rep_name" ]]
                    then
                        clear
                        echo -e "\nAttention !\nVous n'avez rien saisi ou la saisie est incorrecte !\n\nVeuillez recommencer SVP."
                        Log "InputError"
                        continue
                    else
                        #Modification du répertoire
                        ssh -t -o ConnectTimeout=10 cliwin01 "Move-Item -Path '$rep_rename' -Destination '$new_rep_name' -Force -ErrorAction SilentlyContinue"
                        echo -e "\nLe répertoire $rep_rename a été déplacé et/ou renommé en $new_rep_name !\n"
                        Log "DirectoryRenamed"
                        end_rep_return
                        continue 2
                    fi
                fi
            done
        ;;

        3)
            while true
            do
                sleep 2
                clear
                echo ""
                read -p "Entrez le chemin complet du répertoire à supprimer (Exemple : C:\User\monUtilisateur\monRépertoire) : " rep_del

                #Vérification si le répertoire saisi est correcte et non vide
                if [[ "$rep_del" != C:\\* || -z "$rep_del" ]]
                then
                    clear
                    echo -e "\nAttention !\nVous n'avez rien saisi ou la saisie est incorrecte !\n\nVeuillez recommencer SVP."
                    Log "InputError"
                    continue

                #Vérification si le répertoire saisi existe
                elif ! ssh -t -o ConnectTimeout=10 cliwin01 "Test-Path -Path '$rep_del' -PathType Container"
                then
                    clear
                    echo -e "\nAttention ! Le répertoire $rep_del n'existe pas !\n"
                    Log "DirectoryEntryDoesntExist"
                    end_rep_return
                    continue 2
                else
                    while true
                    do                     
                        echo ""

                        #Confirmation de suppression du répertoire saisi
                        read -p "Confirmez-vous la suppression du répertoire $rep_del ? (O/n) " confirm_rep_del
                        if [[ "$confirm_rep_del" = "O" || "$confirm_rep_del" = "o" ]]
                        then

                            #Suppression du répertoire saisi et ce qu'il contient
                            ssh -t -o ConnectTimeout=10 cliwin01 "Remove-Item -Path '$rep_del' -Recurse -Force -ErrorAction SilentlyContinue"
                            echo -e "\nLe répertoire $rep_del a bien été supprimé !"
                            Log "DirectoryDeleted"
                            end_rep_return
                            continue 3
                        elif [[ "$confirm_rep_del" = "N" || "$confirm_rep_del" = "n" ]]
                        then
                            echo -e "\nLe répertoire $rep_del n'a pas été supprimé."
                            Log "DirectoryNotDeleted"
                            end_rep_return
                            continue 3
                        else
                            clear
                            echo -e "\nSaisie incorrecte.\nVeuillez recommencer SVP."
                            Log "InputError"
                            continue
                        fi
                    done
                fi
            done
        ;;

        4)
            echo -e "\nRetour au Menu Action Machine...\n"
            Log "ReturnMachineActionMenu"
            return
        ;;

        x|X)
            echo -e "\nA bientôt !\n"
            Log "EndScript"
            exit 0 
        ;;

        *)
            clear
            echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            Log "InputError"
            continue
        ;;  
    esac
done
