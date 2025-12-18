
#######################################################################################################
# Partie Création de l'Utilisateur
#######################################################################################################


#Affichage de la machine distante et de son adresse IP
param (
    [string]$NomMachine,
    [string]$IpMachine
)


#Fonction retour
function end_user_return {
    while ($true) { 
        Start-Sleep 2
        Clear-Host
        Write-Host "`nVoulez-vous retourner au Menu Gestion des Utilisateurs ou sortir du script ?`n"
        Write-Host "1 - Retour au Menu Gestion des Utilisateurs.`nX - Sortir.`n"
        $choice_return_end = Read-Host "Votre choix" 
        switch ($choice_return_end) {
            "1" {
                Write-Host "`nRetour au Menu Gestion des Utilisateurs..."
                Log "ReturnUserManagementMenu"
                return
            }
                                
            { $_ -match '^[xX]$' } {
                Write-Host "`nA bientôt !`n"
                Log "EndScript"
                throw
            }
                                
            Default {
                Clear-Host
                Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
                Log "InputError"
                continue
            }
        }
    }
}


#Fonction mot de passe.
function password { 
    param(
        [string]$user_name
    )

    while ($true) {
        Start-Sleep 2
        Clear-Host
        Write-Host "`nVoulez-vous créer un mot de passe pour l'utilisateur $user_name ?`n`n1 - Oui`n2 - Non`n3 - Retour au Menu Gestion des Utilisateurs.`nX - Sortir.`n"
        $choice_password = Read-Host "Votre choix"
        switch ($choice_password) {
            "1" {
                Write-Host ""
                #Création de mot de passe
                ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Set-LocalUser -Name '$user_name' -Password (Read-Host -AsSecureString)"
                Write-Host "`nMot de passe défini pour $user_name avec succès !"
                Log "PasswordCreatedNewUser"
                return "Continue"
            }

            "2" {
                Write-Host "`nMot de passe non défini pour $user_name."
                Log "PasswordNotCreatedNewUser"
                return "Continue"
            }

            "3" {
                Write-Host "`nRetour au Menu Gestion des Utilisateurs..."
                Log "ReturnUserManagementMenu"
                return "Return"
            }

            { $_ -match '^[xX]$' } {
                Write-Host "`nA bientôt !`n"
                Log "EndScript"
                throw
            }

            Default {        
                Clear-Host
                Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
                Log "InputError"                   
            }
        }
    }
}


#Fonction Log
function Log {
    param (
        [string]$evenement
    )

    #Créer le dossier si nécessaire
    if (-not (Test-Path "C:\Windows\System32\LogFiles")) {
        New-Item -ItemType Directory -Path "C:\Windows\System32\LogFiles" -Force | Out-Null
    }

    $fichier_log = "C:\Windows\System32\LogFiles\log_evt.log"
    $date_actuelle = Get-Date -Format "yyyyMMdd"
    $heure_actuelle = Get-Date -Format "HHmmss"
    $utilisateur = $env:USERNAME

    $ligne_log = "${date_actuelle}_${heure_actuelle}_${utilisateur}_${evenement}"

    Add-Content -Path $fichier_log -Value $ligne_log  
}


#######################################################################################################
# Bloc Principal
#######################################################################################################

Log "NewScript"

while ($true) {
    Start-Sleep 2
    Clear-Host
    Write-Host "`nBienvenue dans l'Espace Création Utilisateur !"
    Log "WelcomeToUserCreationArea"
    Write-Host "`nVoulez-vous créer l'utilisateur $user_name ?`n`n1 - Oui`n2 - Non`n3 - Retour au Menu Gestion des Utilisateurs.`nX - Sortir.`n"
    $create_user = Read-Host "Votre choix" 
    switch ($create_user) {
        "1" {
            # Création utilisateur
            ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "New-LocalUser -Name '$user_name' -NoPassword -ErrorAction SilentlyContinue"
            Write-Host "L'utilisateur $user_name a été créé avec succès !"
            Log "NewUserCreated"
            #Proposition création mot de passe
            $result_password = password $user_name
            switch ($result_password) {
                "Continue" {
                    break
                }
                "Return" {
                    return
                }
            }

            while ($true) {
                #Proposition ajout à un groupe
                Start-Sleep 2
                Clear-Host
                Write-Host "`nVoulez-vous l'ajouter à un groupe ?`n`n1 - Ajouter $user_name au groupe administrateur.`n2 - Ajouter $user_name à un groupe local.`n3 - Retourner au Menu Gestion des Utilisateurs ?`nX - Sortir.`n"
                $choice_grp = Read-Host "Votre choix" 
                switch ($choice_grp) {
                    "1" {
                        #Vérification orthographe du groupe administrateur en fonction de la langue et s'il existe
                        $group_name = if (ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Get-LocalGroup -Name 'Administrators' -ErrorAction SilentlyContinue") {
                            "Administrators"
                        }
                        elseif (ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Get-LocalGroup -Name 'Administrateurs' -ErrorAction SilentlyContinue") {
                            "Administrateurs"
                        }
                        else {
                            Write-Host "Le groupe Administrateurs n'existe pas sur cette machine."
                            return
                        }
                        #Ajout au groupe administrateur
                        ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Add-LocalGroupMember -Group '$group_name' -Member '$user_name'"
                        Write-Host "`nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !"
                        Log "AddSudoGrpNewUser"
                        end_user_return
                        return
                    }

                    "2" {
                        while ($true) {
                            Clear-Host                        
                            Write-Host "`nVoici la liste des groupes locaux existants :`n"
                            Start-Sleep 1

                            #Vérification s'il y a un groupe local dans lequel l'utilisateur peut être ajouté qui n'est pas un groupe système
                            if (ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Get-LocalGroup | Where-Object { $_.SID -notmatch '^S-1-5-32-' } | Select-Object -ExpandProperty Name") {
                                Write-Host ""
                                Write-Host  "Dans quel groupe existant ci-dessus souhaitez-vous être ajouté ?`n"
                                $local_grp = Read-Host "Votre choix"

                                #Vérification si le groupe local choisi existe 
                                if (ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Get-LocalGroup -Name '$local_grp' -ErrorAction SilentlyContinue") {
                                    #Ajout au groupe local
                                    ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Add-LocalGroupMember -Group '$local_grp' -Member '$user_name'"
                                    Write-Host "`nL'utilisateur $user_name a été ajouté au groupe $local_grp avec succès !"
                                    Log "AddLocalGrpNewUser"

                                    while ($true) {
                                        #Proposition ajout au groupe administrateur
                                        Start-Sleep 2
                                        Clear-Host
                                        Write-Host "`nVoulez-vous accorder des droits administrateurs à l'utilisateur ?`n`n1 - Oui`n2 - Non`n3 - Retour au Menu Gestion des Utilisateurs.`nX - Sortir.`n"
                                        $mod_sudo = Read-Host "Votre choix"
                                        
                                        switch ($mod_sudo) {
                                            "1" {
                                                #Vérification orthographe du groupe administrateur en fonction de la langue et s'il existe
                                                $group_name = if (ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Get-LocalGroup -Name 'Administrators' -ErrorAction SilentlyContinue") {
                                                    "Administrators"
                                                }
                                                elseif (ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Get-LocalGroup -Name 'Administrateurs' -ErrorAction SilentlyContinue") {
                                                    "Administrateurs"
                                                }
                                                else {
                                                    Write-Host "Le groupe Administrateurs n'existe pas sur cette machine."
                                                    return
                                                }

                                                #Ajout au groupe adminisitrateur
                                                ssh -t -o ConnectTimeout=10 "wilder@172.16.40.20" "Add-LocalGroupMember -Group '$group_name' -Member '$user_name'"
                                                Write-Host "`nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !"
                                                Log "AddSudoGrpNewUser"
                                                end_user_return
                                                return                                          
                                            }

                                            "2" {
                                                Write-Host "`nL'utilisateur $user_name du groupe $local_grp n'a pas été ajouté au groupe administrateur."
                                                Log "NoAddSudoGroupNewUser"
                                                end_user_return
                                                return                                         
                                            }

                                            "3" {
                                                Write-Host "`nRetour au Menu Gestion des Utilisateurs..." 
                                                Log "ReturnUserManagementMenu"                                       
                                                return
                                            }

                                            { $_ -match '^[xX]$' } {
                                                Write-Host "`nA bientôt !`n"
                                                Log "EndScript"
                                                throw
                                            }

                                            Default {
                                                Clear-Host
                                                Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
                                                Log "InputError"
                                                continue
                                            }
                                        } 
                                    }
                                }
                                else {
                                    Write-Host "`nLe groupe $local_grp n'existe pas. Veuillez réessayer SVP.`n"
                                    Log "LocalGroupDoesntExist"
                                    Start-Sleep 3
                                    continue
                                }
                            }
                            else { 
                                Write-Host "Il n'y a aucun groupe dans lequel vous pouvez être ajouté."
                                end_user_return
                                return
                            }
                        }                         
                    }

                    "3" {
                        Write-Host "`nRetour au Menu Gestion des Utilisateurs..."
                        Log "ReturnUserManagementMenu"
                        return
                    }

                    { $_ -match '^[xX]$' } {
                        Write-Host "`nA bientôt !`n"
                        Log "EndScript"
                        throw
                    }

                    Default {
                        Clear-Host
                        Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
                        Log "InputError"
                        continue
                    }
                }                
            }                 
        }        

        "2" {
            Write-Host "`nL'utilisateur $user_name n'a pas été créé."
            Log "NewUserNotCreated"
            end_user_return
            return
        }

        "3" {
            Write-Host "`nRetour au Menu Gestion des Utilisateurs..."
            Log "ReturnUserManagementMenu"            
            return
        }

        { $_ -match '^[xX]$' } {
            Write-Host "`nA bientôt !`n"
            Log "EndScript"
            throw
        }

        Default {
            Clear-Host
            Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
            Log "InputError"
            continue
        }
    }
}
return
