#!/bin/bash

function end_user_return()
{
    while true
    do
        sleep 3
        clear
        echo -e "Voulez-vous retourner au menu précédent ou sortir du script ?\n"
        echo -e "1 - Retour dans l'Espace Modification Utilisateur.\nX - Sortir.\n"
        read -p "Votre choix : " choice_return_end
        case "$choice_return_end" in
            1)
                echo -e "\nRetour dans l'Espace Modification Utilisateur..."
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
    echo "Bienvenue dans l'Espace Modification de l'Utilisateur !"
    echo -e "\nQuelles modifications voulez-vous apporter à l'utilisateur $user_name ?\n\n1 - Modifier le mot de passe.\n2 - Ajouter $user_name au groupe administrateur.\n3 - Ajouter $user_name à un groupe local.\n4 - Retourner dans l'Espace Personnel Utilisateur ?\nX - Sortir.\n"
    read -p "Votre choix : " choice_modif_user
    case $choice_modif_user in
        1)
            ssh -o ConnectTimeout=10 -T clilin01 "sudo passwd "$user_name""
            echo -e "\nMot de passe modifié pour $user_name avec succès !\n"
            end_user_return
            continue
        ;;
        
        2)
            ssh -o ConnectTimeout=10 -T clilin01 "sudo usermod -aG sudo "$user_name""
            echo -e "\nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !\n"
            end_user_return
            continue
        ;;
        
        3)
            clear
            echo -e "\nVoici la liste des groupes locaux existants :\n"
            sleep 3
            ssh -o ConnectTimeout=10 -T clilin01 "awk -F: '$3 >= 1000 {print $1}' /etc/group | sort | more"
            echo ""
            
            while true
            do
                read -p "Dans quel groupe existant ci-dessus souhaitez-vous être ajouté ? " local_grp
                if ssh -o ConnectTimeout=10 -T clilin01 "sudo getent group "$local_grp" >/dev/null 2>&1"
                then
                    if ssh -o ConnectTimeout=10 -T clilin01 "sudo usermod -aG "$local_grp" "$user_name""
                    echo -e "\nL'utilisateur $user_name a été ajouté au groupe $local_grp avec succès !"
                    while true
                    do
                        sleep 3
                        clear
                        echo -e "\nVoulez-vous accorder des droits administrateurs à l'utilisateur $user_name ?\n\n1 - Oui \n2 - Non\n3 - Retour dans l'Espace Modification Utilisateur.\nX - Sortir.\n"
                        read -p "Votre choix : " mod_sudo
                        case $mod_sudo in
                            1)
                                if ssh -o ConnectTimeout=10 -T clilin01 "sudo usermod -aG sudo "$user_name""
                                echo -e "\nL'utilisateur $user_name du groupe $local_grp a aussi été ajouté au groupe administrateur avec succès !"
                                end_user_return
                                continue 3
                            ;;
                                        
                            2)
                                echo -e "\nL'utilisateur $user_name du groupe $local_grp n'a pas été ajouté au groupe administrateur."
                                end_user_return
                                continue 3
                            ;;
                                        
                            3)
                                echo -e "\nRetour dans l'Espace Modification Utilisateur..."                                        
                                continue 3
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
                else
                    clear
                    echo -e "\nLe groupe $local_grp n'existe pas. Veuiller réessayer SVP.\n"
                    continue
                fi
            done
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
            echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            continue
        ;;
    esac
done