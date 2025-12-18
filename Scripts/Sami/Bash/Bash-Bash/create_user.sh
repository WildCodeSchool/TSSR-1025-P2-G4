#!/bin/bash

#######################################################################################################
# Partie Création Utilisateur
#######################################################################################################


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


#Fonction retour
function end_user_return()
{
    while true
    do
        sleep 2
        clear
        echo -e "Voulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ?\n"
        echo -e "1 - Retour au Menu Gestion des Utilisateurs.\nX - Sortir.\n"
        read -p "Votre choix : " choice_return_end
        case "$choice_return_end" in
            1)
                echo -e "\nRetour au Menu Gestion des Utilisateurs..."
                Log "ReturnUserManagementMenu"
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


#######################################################################################################
# Bloc Principal
#######################################################################################################

Log "NewScript"

while true
do
    sleep 2
    clear
    echo -e "\nBienvenue dans l'Espace Création Utilisateur !"
    Log "WelcomeToUserCreationArea"
    echo -e "\nVoulez-vous créer l'utilisateur $user_name ?\n\n1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs.\nX - Sortir.\n"
    read -p "Votre choix : " create_user
    case "$create_user" in
        1)
            # Création utilisateur
            ssh -t -o ConnectTimeout=10 clilin01 "sudo -S useradd '$user_name'"
            echo -e "\nL'utilisateur $user_name a été créé avec succès !"
            Log "NewUserCreated"
            while true
            do
                #Proposition création mot de passe
                sleep 2
                clear
                echo -e "\nVoulez-vous créer un mot de passe pour l'utilisateur $user_name ?\n\n1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs.\nX - Sortir.\n"
                read -p "Votre choix : " choice_password
                case $choice_password in
                    1)
                        #Création de mot de passe
                        ssh -t -o ConnectTimeout=10 clilin01 "sudo -S passwd '$user_name'"
                        echo -e "\nMot de passe défini pour $user_name avec succès !"
                        Log "PasswordCreatedNewUser"
                        break
                    ;;
                    
                    2)
                        echo -e "\nMot de passe non défini pour $user_name."
                        Log "PasswordNotCreatedNewUser"
                        break
                    ;;
                    
                    3)
                        echo -e "\nRetour au Menu Gestion des Utilisateurs..."
                        Log "ReturnUserManagementMenu"
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
            
            while true
            do
                #Proposition ajout à un groupe
                sleep 2
                clear
                echo -e "\nVoulez-vous l'ajouter à un groupe ?\n\n1 - Ajouter $user_name au groupe administrateur.\n2 - Ajouter $user_name à un groupe local.\n3 - Retourner au Menu Gestion des Utilisateurs ?\nX - Sortir.\n"
                read -p "Votre choix : " choice_grp
                case $choice_grp in
                    1)
                        #Vérification orthographe si le groupe sudo existe
                        if ! ssh -T -o ConnectTimeout=10 clilin01 "getent group sudo" >/dev/null 2>&1
                        then
                            echo "Le groupe sudo n'existe pas sur cette machine."
                            return
                        fi

                        #Ajout au groupe administrateur
                        ssh -t -o ConnectTimeout=10 clilin01 "sudo -S usermod -aG sudo '$user_name'"
                        echo -e "\nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !"
                        Log "AddSudoGrpNewUser"
                        end_user_return
                        return
                    ;;
                    
                    2)
                        while true
                        do
                            clear                        
                            echo -e "\nVoici la liste des groupes locaux existants :\n"
                            sleep 1

                            #Redirection vers une variable pour appeler la commande
                            group_list=$(ssh -T -o ConnectTimeout=10 clilin01 'awk -F: '\''$3>=1000 {print $1}'\'' /etc/group | sort')

                            #Vérification s'il y a un groupe local dans lequel l'utilisateur peut être ajouté qui n'est pas un groupe système
                            if [[ -n "$group_list" ]]
                            then
                                echo "$group_list"
                                echo ""
                                read -p "Dans quel groupe existant ci-dessus souhaitez-vous être ajouté ? " local_grp

                                #Vérification si le groupe local choisi existe
                                if ssh -T -o ConnectTimeout=10 clilin01 "getent group '$local_grp' >/dev/null 2>&1"
                                then
                                    ssh -t -o ConnectTimeout=10 clilin01 "sudo -S usermod -aG '$local_grp' '$user_name'"
                                    echo -e "\nL'utilisateur $user_name a été ajouté au groupe $local_grp avec succès !"
                                    Log "AddLocalGrpNewUser"

                                    while true
                                    do
                                        #Proposition ajout au groupe administrateur
                                        sleep 2
                                        clear
                                        echo -e "\nVoulez-vous accorder des droits administrateurs à l'utilisateur ?\n\n1 - Oui\n2 - Non\n3 - Retour au Menu Gestion des Utilisateurs.\nX - Sortir.\n"
                                        read -p "Votre choix : " mod_sudo


                                        case $mod_sudo in
                                            1)
                                                #Vérification orthographe si le groupe administrateur existe
                                                if ! ssh -T -o ConnectTimeout=10 clilin01 "getent group sudo" >/dev/null 2>&1
                                                then
                                                    echo "Le groupe Administrateurs n'existe pas sur cette machine."
                                                    return
                                                fi

                                                #Ajout au groupe administrateur
                                                ssh -t -o ConnectTimeout=10 clilin01 "sudo -S usermod -aG sudo '$user_name'"
                                                echo -e "\nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !"
                                                Log "AddSudoGrpNewUser"
                                                end_user_return
                                                return
                                            ;;
                                            
                                            2)
                                                echo -e "\nL'utilisateur $user_name du groupe $local_grp n'a pas été ajouté au groupe administrateur."
                                                Log "NoAddSudoGroupNewUser"
                                                end_user_return
                                                return
                                            ;;
                                            
                                            3)
                                                echo -e "\nRetour au Menu Gestion des Utilisateurs..." 
                                                Log "ReturnUserManagementMenu"                                       
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
                                else
                                    echo -e "\nLe groupe $local_grp n'existe pas. Veuillez réessayer SVP.\n"
                                    Log "LocalGroupDoesntExist"
                                    sleep 3
                                    continue
                                fi
                            else
                                echo "Il n'y a aucun groupe dans lequel vous pouvez être ajouté."
                                end_user_return
                                return
                            fi
                        done
                    ;;
                    
                    3)
                        echo -e "\nRetour au Menu Gestion des Utilisateurs..."
                        Log "ReturnUserManagementMenu"
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
        ;;
        
        2)
            echo -e "\nL'utilisateur $user_name n'a pas été créé."
            Log "NewUserNotCreated"
            end_user_return
            return
        ;;
        
        3)
            echo -e "\nRetour au Menu Gestion des Utilisateurs..."
            Log "ReturnUserManagementMenu"            
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