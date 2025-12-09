#!/bin/bash

#####################################################################################################################################################################
# Partie Gestion des Répertoires
#####################################################################################################################################################################

function check_path_absolute()
{
    if [[ "$1" != /* ]]
    then
        clear
        echo -e "Saisie incorrecte.\nLe chemin du répertoire doit être absolu comme indiqué dans l'exemple précédemment donné.\nVeuillez recommencer SVP\n"
    fi
}

function end_rep_return()
{
    while true
    do
        sleep 3
        clear
        echo -e "Voulez-vous retourner au Menu Gestion des Répertoires ou sortir du script ?\n"
        echo -e "1 - Retour au Menu Gestion des Répertoires.\nX - Sortir.\n"
        read -p "Votre choix : " choice_return_end
        case "$choice_return_end" in
            1)
                echo -e "\nRetour au Menu Gestion des Répertoires..."
                break
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
}

while true
do
    sleep 3
    clear
    echo "###############################################"
    echo "###############################################"
    echo "####                                       ####"
    echo "####                                       ####"
    echo "####     Menu Gestion des Répertoires      ####"
    echo "####                                       ####"
    echo "####                                       ####"
    echo "###############################################"
    echo "###############################################"
    echo -e "\nBienvenue dans le Menu Gestion des Répertoires.\n"
    echo -e "Que souhaitez-vous faire ?\n"
    echo -e "1 - Créer un répertoire.\n2 - Renommer un répertoire.\n3 - Supprimer un répertoire.\n4 - Retourner au menu précédent.\nX - Sortir.\n"
    read -p "Votre choix : " choice_menu_gestion_rep
    case $choice_menu_gestion_rep in
        1)
            echo ""
            read -p "Entrez le chemin complet du répertoire à créer (Exemple : /home/wilder/monRépertoire) : " rep_name
            if [ -d "$rep_name" ]
            then
                clear
                echo -e "\nAttention ! Le répertoire $rep_name existe déjà !\n"
                end_rep_return
                continue
            else
                mkdir -p "$rep_name"
                echo -e "\nRépertoire $rep_name créé avec succès !\n"
                end_rep_return
                continue
            fi
            continue
        ;;

        2)
            echo ""
            read -p "Entrez le chemin complet du répertoire à renommer/modifier (Exemple : /home/wilder/monRépertoire) : " rep_rename
            echo ""
            if ssh -o ConnectTimeout=10 -T clilin01 "[ ! -d "$rep_rename" ]"
            then
                clear
                echo -e "Attention ! Le répertoire $rep_rename n'existe pas !\n"
                end_rep_return
                continue
            else
                read -p "Entrez le nouveau chemin complet du répertoire à renommer (Exemple : /home/wilder/monRépertoire) : " new_rep_name
                ssh -o ConnectTimeout=10 -T clilin01 "mv $rep_rename $new_rep_name"
                echo -e "\nLe répertoire $rep_rename a été déplacé et/ou renommé en $new_rep_name !\n"
                end_rep_return
                continue
            fi
            continue
        ;;

        3)
            echo ""
            read -p "Entrez le chemin complet du répertoire à supprimer (Exemple : /home/wilder/monRépertoire) : " rep_del
            echo ""
            if ssh -o ConnectTimeout=10 -T clilin01 "[ ! -d "$rep_del" ]"
            then
                clear
                echo -e "Attention ! Le répertoire $rep_del n'existe pas !\n"
                end_rep_return
                continue
            else
                while true
                do
                    read -p "Confirmez la supression du répertoire $rep_del ? (O/n) " confirm_rep_del
                    if ssh -o ConnectTimeout=10 -T clilin01 "[[ "$confirm_rep_del" = "O" || "$confirm_rep_del" = "o" ]]"
                    then
                        ssh -o ConnectTimeout=10 -T clilin01 "rm -r $rep_del"
                        echo -e "\nLe répertoire $rep_del a bien été supprimé !\n"
                        end_rep_return
                        continue 2
                    elif [[ "$confirm_rep_del" = "N" || "$confirm_rep_del" = "n" ]]
                    then
                        echo -e "\nLe répertoire $rep_del n'a pas été supprimé.\n"
                        end_rep_return
                        continue 2
                    else
                        clear
                        echo -e "\nSaisie incorrecte.\nVeuillez recommencez SVP."
                        continue
                    fi
                    continue 2
                done
            fi
            continue
        ;;

        4)
            echo -e "\nRetour au menu précédent...\n"
            return
        ;;

        x|X)
            echo -e "\nA bientôt !\n"
            exit 0 
        ;;
    esac
done
