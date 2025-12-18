#!/bin/bash

#######################################################################################################
# Partie Modification de l'Utilisateur
#######################################################################################################


#Fonction Retour
function end_user_return()
{
    while true
    do
        sleep 2
        clear
        echo -e "Voulez-vous retourner au menu précédent ou sortir du script ?\n"
        echo -e "1 - Retour au Menu de l'Espace Modification Utilisateur.\nX - Sortir.\n"
        read -p "Votre choix : " choice_return_end
        case "$choice_return_end" in
            1)
                echo -e "\nRetour au Menu de l'Espace Modification Utilisateur..."
                Log "ReturnUserModificationArea"
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
    echo -e "\nBienvenue dans l'Espace Modification de l'Utilisateur !"
    Log "WelcomeToUserModificationArea"
    echo -e "\nQuelles modifications voulez-vous apporter à l'utilisateur $user_name ?\n\n1 - Modifier le mot de passe.\n2 - Ajouter $user_name au groupe administrateur.\n3 - Ajouter $user_name à un groupe local.\n4 - Retourner dans l'Espace Personnel Utilisateur ?\nX - Sortir.\n"
    read -p "Votre choix : " choice_modif_user
    case $choice_modif_user in
        1)
            #Modification mot de passe
            echo ""
            ssh -t -o ConnectTimeout=10 cliwin01 "Set-LocalUser -Name '$user_name' -Password (Read-Host -AsSecureString)"
            echo -e "\nMot de passe modifié pour $user_name avec succès !\n"
            Log "PasswordChangedUser"
            end_user_return
            continue
        ;;
        
        2)
            #Vérification orthographe du groupe administrateur en fonction de la langue et s'il existe
            if ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrators' -ErrorAction SilentlyContinue"
            then
                group_name="Administrators"
            elif ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrateurs' -ErrorAction SilentlyContinue"
            then
                group_name="Administrateurs"
            else
                echo "Le groupe Administrateurs n'existe pas sur cette machine."
                return
            fi

            #Vérification si l'utilisateur est déjà dans le groupe administrateur
            if ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroupMember -Group '$group_name' -Member '$user_name' -ErrorAction SilentlyContinue"
            then
                echo -e "\nL'utilisateur $user_name fait déjà partie du groupe $group_name."
            else 
                #Ajout au groupe administrateur    
                ssh -t -o ConnectTimeout=10 cliwin01 "Add-LocalGroupMember -Group '$group_name' -Member '$user_name'"
                echo -e "\nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !\n"
                Log "AddSudoGrpUser"
            fi

            end_user_return
            continue
        ;;
        
        3)
            while true
            do
                clear
                echo -e "\nVoici la liste des groupes locaux existants :\n"
                sleep 1

                #Vérification s'il y a un groupe local dans lequel l'utilisateur peut être ajouté qui n'est pas un groupe système
                if ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup | Where-Object { $_.SID -notmatch '^S-1-5-32-' } | Select-Object -ExpandProperty Name"
                then
                    echo ""
                    echo -e "Dans quel groupe existant ci-dessus souhaitez-vous être ajouté ?\n"
                    read -p "Votre choix : " local_grp

                    #Vérification si le groupe local choisi existe
                    if ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name '$local_grp' -ErrorAction SilentlyContinue"
                    then
                        #Vérification si l'utilisateur est déjà dans le groupe local choisi
                        if ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroupMember -Group '$local_grp' -Member '$user_name' -ErrorAction SilentlyContinue"
                        then
                            echo -e "\nL'utilisateur $user_name fait déjà partie du groupe $local_grp."
                        else
                            #Ajout de l'utilisateur dans le groupe local choisi
                            ssh -t -o ConnectTimeout=10 cliwin01 "Add-LocalGroupMember -Group '$local_grp' -Member '$user_name'"
                            echo -e "\nL'utilisateur $user_name a été ajouté au groupe $local_grp avec succès !"
                            Log "AddLocalGrpUser"
                        fi

                        while true
                        do
                            #Proposition ajout au groupe administrateur
                            sleep 2
                            clear
                            echo -e "\nVoulez-vous accorder des droits administrateurs à l'utilisateur $user_name ?\n\n1 - Oui \n2 - Non\n3 - Retour dans l'Espace Modification Utilisateur.\nX - Sortir.\n"
                            read -p "Votre choix : " mod_sudo
                            case $mod_sudo in
                                1)
                                    #Vérification orthographe du groupe administrateur en fonction de la langue et s'il existe
                                    if ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrators' -ErrorAction SilentlyContinue"
                                    then
                                        group_name="Administrators"
                                    elif ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrateurs' -ErrorAction SilentlyContinue"
                                    then
                                        group_name="Administrateurs"
                                    else
                                        echo "Le groupe Administrateurs n'existe pas sur cette machine."
                                        return
                                    fi

                                    #Vérification si l'utilisateur est déjà dans le groupe administrateur
                                    if ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroupMember -Group '$group_name' -Member '$user_name' -ErrorAction SilentlyContinue"
                                    then
                                        echo -e "\nL'utilisateur $user_name fait déjà partie du groupe $group_name."
                                    else 
                                        #Ajout au groupe administrateur    
                                        ssh -t -o ConnectTimeout=10 cliwin01 "Add-LocalGroupMember -Group '$group_name' -Member '$user_name'"
                                        echo -e "\nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !\n"
                                        Log "AddSudoGrpUser"
                                    fi

                                    end_user_return
                                    continue 3
                                ;;
                                            
                                2)
                                    echo -e "\nL'utilisateur $user_name du groupe $local_grp n'a pas été ajouté au groupe administrateur."
                                    Log "NoAddSudoGroupUser"
                                    end_user_return
                                    continue 3
                                ;;
                                            
                                3)
                                    echo -e "\nRetour au Menu de l'Espace Modification Utilisateur..."  
                                    Log "ReturnUserModificationArea"                                      
                                    continue 3
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
                        clear
                        echo -e "\nLe groupe $local_grp n'existe pas.\nVeuillez réessayer SVP.\n"
                        sleep 3
                        Log "LocalGroupDoesntExist"
                        continue
                    fi
                else 
                    echo -e "\nIl n'y a aucun groupe dans lequel vous pouvez être ajouté."
                    end_user_return
                    continue
                fi
            done
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
            echo -e "\nErreur de saisie.\nVeuillez faire votre choix selon ce qui est proposé."
            Log "InputError"
            continue
        ;;
    esac
done