#!/bin/bash

#######################################################################################################
# Partie Création Utilisateur
#######################################################################################################

echo "Le nom d'utilisateur entré n'existe pas."

while true
do
    echo -e "Voulez-vous le créer ?\n1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs ?\n4 - Sortir."
    read -p "Votre choix : " create_user
    case "$create_user" in
        1)
            sudo useradd "$user_name"
            echo "L'Utilisateur $user_name a été créé !"
            while true
            do
                echo -e "Voulez-vous créer un mot de passe ?\n1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs ?\n4 - Sortir."
                read -p "Votre choix : " choice_password
                case $choice_password in
                    1)
                        sudo passwd "$user_name"
                        echo "Mot de passe défini pour $user_name !"
                        break
                    ;;
                    
                    2)
                        echo "Mot de passe non défini pour $user_name."
                        break
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
                        echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                        continue
                    ;;
                esac
            done
            
            while true
            do
                echo -e "Voulez-vous l'ajouter à un groupe ?\n1 - Ajouter $user_name au groupe administrateur.\n2- Ajouter $user_name à un groupe local.\n3 - Retour au Menu Gestion des Utilisateurs ?\n4 - Sortir."
                read -p "Votre choix : " choice_grp
                case $choice_grp in
                    1)
                        sudo usermod -aG sudo "$user_name"
                        echo "L'Utilisateur $user_name a été ajouté au groupe administrateur !"
                        while true
                        do
                            read -p "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? " end_add_sudo
                            echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                            case "$end_add_sudo" in
                                1)
                                    echo "Retour au Menu Gestion des Utilisateurs..."
                                    return
                                ;;
                                
                                2)
                                    echo "A bientôt !"
                                    exit 0
                                ;;
                                
                                *)
                                    echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                                    continue
                                ;;
                            esac
                        done
                    ;;
                    
                    2)
                        echo -e "Voici la liste des groupes locaux existants :\n"
                        cat /etc/group | awk -F":" '{print $1}'
                        
                        while true
                        do
                            read -p "Dans quel groupe existant ci-dessus voulez-vous être ajouté ?" local_grp
                            if getent group "$local_grp" >/dev/null 2>&1
                            then
                                sudo usermod -aG "$local_grp" "$user_name"
                                echo "L'Utilisateur $user_name a été ajouté au groupe $local_grp !"
                                while true
                                do
                                    echo -e "Voulez-vous accorder des droits administrateurs à l'utilisateur ?\n 1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs ?\n4 - Sortir."
                                    read -p "Votre choix : " mod_sudo
                                    case $mod_sudo in
                                        1)
                                            sudo usermod -aG sudo "$user_name"
                                            echo "L'Utilisateur $user_name du groupe $local_grp a aussi été ajouté au groupe administrateur !"
                                            while true
                                            do
                                                echo "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? "
                                                echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                                                read -p "Votre choix : " end_add_sudo
                                                case "$end_add_sudo_v2" in
                                                    1)
                                                        echo "Retour au Menu Gestion des Utilisateurs..."
                                                        return
                                                    ;;
                                                    
                                                    2)
                                                        echo "A bientôt !"
                                                        exit 0
                                                    ;;
                                                    
                                                    *)
                                                        echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                                                        continue
                                                    ;;
                                                esac
                                            done
                                        ;;
                                        
                                        2)
                                            echo "L'Utilisateur $user_name du groupe $local_grp n'a pas été ajouté au groupe administrateur."
                                            while true
                                            do
                                                read -p "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? " end_add_sudo_v3
                                                echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                                                case "$end_add_sudo_v3" in
                                                    1)
                                                        echo "Retour au Menu Gestion des Utilisateurs..."
                                                        return
                                                    ;;
                                                    
                                                    2)
                                                        echo "A bientôt !"
                                                        exit 0
                                                    ;;
                                                    
                                                    *)
                                                        echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
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
                                            echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
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
                    
                    3)
                        echo "Retour au Menu Gestion des Utilisateurs..."
                        return
                    ;;
                    
                    4)
                        echo "A bientôt !"
                        exit 0
                    ;;
                    
                    *)
                        echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
                        continue
                    ;;
                esac
            done
        ;;
        
        2)
            echo "L'Utilisateur $user_name n'a pas été créé."
            while true
            do
                read -p "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ? " not_create_user
                echo -e "1 - Retour au Menu Gestion des Utilisateurs ?\n2 - Sortir."
                case "$not_create_user" in
                    1)
                        echo "Retour au Menu Gestion des Utilisateurs..."
                        return
                    ;;
                    
                    2)
                        echo "A bientôt !"
                        exit 0
                    ;;
                    
                    *)
                        echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
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
            echo -e " Erreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            continue
        ;;
    esac
done
