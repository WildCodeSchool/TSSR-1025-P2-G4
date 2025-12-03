#!/bin/bash

while true
do
    clear
    echo "Bienvenue dans le Menu Modification de l'Utilisateur !"
    sleep 2
    echo -e "\nQuelles modifications voulez-vous apporter à l'Utilisateur $user_name ?\n\n1 - Modifier le mot de passe.\n2 - Ajouter $user_name au groupe administrateur.\n3 - Ajouter $user_name à un groupe local.\n4 - Retourner au Menu Gestion des Utilisateurs ?\nX - Sortir."
    read -p "Votre choix : " choice_modif_user
    case $choice_modif_user in
        1)
            passwd "$user_name"
            echo -e "\nMot de passe modifié pour $user_name !\n"
            while true
            do
                echo "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? "
                echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                read -p "Votre choix : " end_modif_pass
                case "$end_modif_pass" in
                    1)
                        echo "Retour au Menu Gestion des Utilisateurs..."
                        return
                    ;;
                    
                    2)
                        echo "A bientôt !"
                        exit 0
                    ;;
                    
                    *)
                        echo -e "Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                        continue
                    ;;
                esac
            done
        ;;
        
        2)
            sudo usermod -aG sudo "$user_name"
            echo "L'Utilisateur $user_name a été ajouté au groupe administrateur !"
            while true
            do
                echo "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? "
                echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                read -p "Votre choix : " end_add_sudo_v4
                case "$end_add_sudo_v4" in
                    1)
                        echo "Retour au Menu Gestion des Utilisateurs..."
                        return
                    ;;
                    
                    2)
                        echo "A bientôt !"
                        exit 0
                    ;;
                    
                    *)
                        echo -e "Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                        continue
                    ;;
                esac
            done
        ;;
        
        3)
            echo -e "\nVoici la liste des groupes locaux existants :\n"
            sleep 1
            cat /etc/group | awk -F":" '{print $1}' | sort
            
            while true
            do
                read -p "Dans quel groupe existant ci-dessus souhaitez-vous être ajouté ? " local_grp
                if getent group "$local_grp" >/dev/null 2>&1
                then
                    usermod -aG "$local_grp" "$user_name"
                    echo "L'Utilisateur $user_name a été ajouté au groupe $local_grp !"
                    while true
                    do
                        echo -e "Voulez-vous accorder des droits administrateurs à l'utilisateur ?\n1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs ?\n4 - Sortir."
                        read -p "Votre choix : " mod_sudo_v2
                        case $mod_sudo_v2 in
                            1)
                                usermod -aG sudo "$user_name"
                                echo "L'Utilisateur $user_name du groupe $local_grp a aussi été ajouté au groupe administrateur !"
                                while true
                                do
                                    echo "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? "
                                    echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                                    read -p "Votre choix : " end_add_sudo_v5
                                    case "$end_add_sudo_v5" in
                                        1)
                                            echo "Retour au Menu Gestion des Utilisateurs..."
                                            return
                                        ;;
                                        
                                        2)
                                            echo "A bientôt !"
                                            exit 0
                                        ;;
                                        
                                        *)
                                            echo -e "Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                                            continue
                                        ;;
                                    esac
                                done
                            ;;
                            
                            2)
                                echo "L'Utilisateur $user_name du groupe $local_grp n'a pas été ajouté au groupe administrateur."
                                while true
                                do
                                    echo "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? "
                                    echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                                    read -p "Votre choix : " end_add_sudo_v6
                                    case "$end_add_sudo_v6" in
                                        1)
                                            echo "Retour au Menu Gestion des Utilisateurs..."
                                            return
                                        ;;
                                        
                                        2)
                                            echo "A bientôt !"
                                            exit 0
                                        ;;
                                        
                                        *)
                                            echo -e "Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                                            continue
                                        ;;
                                    esac
                                done
                            ;;
                            
                            3)
                                echo "Retour au Menu Gestion des Utilisateurs..."
                                return
                            ;;
                            
                            4)
                                echo "A bientôt !"
                                exit 0
                            ;;
                            
                            *)
                                echo -e "Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                                continue
                            ;;
                        esac
                    done
                else
                    echo "Le groupe $local_grp n'existe pas. Veuiller réessayer SVP."
                    continue
                fi
            done
        ;;
    esac
done