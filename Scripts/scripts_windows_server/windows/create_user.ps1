# Partie Création de l'Utilisateur

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
                                
            {$_ -match '^[xX]$' }{
                Write-Host "`nA bientôt !`n"
                Log "EndScript"
                throw
            }
                                
            Default {
                Clear-Host
                Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
                Log "Input_Error"
                continue
            }
        }
    }
}

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
                $password = Read-Host "Entrez le mot de passe" -AsSecureString
                #ssh cliwin01 "Set-LocalUser -Name \"$user_name\" -Password (ConvertTo-SecureString \"$password\" -AsPlainText -Force)"
                Set-LocalUser -Name $user_name -Password $password
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

            {$_ -match '^[xX]$' }{
                Write-Host "`nA bientôt !`n"
                Log "EndScript"
                throw
            }

            Default {        
                Clear-Host
                Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
                Log "Input_Error"                   
            }
        }
    }
}
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
            #ssh cliwin01 "New-LocalUser -Name \"$user_name\" -NoPassword"
            New-LocalUser -Name $user_name -NoPassword -ErrorAction SilentlyContinue
            Write-Host "L'utilisateur $user_name a été créé avec succès !"
            Log "NewUserCreated"
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
                Start-Sleep 2
                Clear-Host
                Write-Host "`nVoulez-vous l'ajouter à un groupe ?`n`n1 - Ajouter $user_name au groupe administrateur.`n2 - Ajouter $user_name à un groupe local.`n3 - Retourner au Menu Gestion des Utilisateurs ?`nX - Sortir.`n"
                $choice_grp = Read-Host "Votre choix" 
                switch ($choice_grp) {
                    "1" {
                        #ssh cliwin01 "Add-LocalGroupMember -Group \"Administrators\" -Member \"$user_name\""
                        $group_name = if (Get-LocalGroup -Name "Administrators" -ErrorAction SilentlyContinue) {
                            "Administrators"
                        }
                        elseif (Get-LocalGroup -Name "Administrateurs" -ErrorAction SilentlyContinue) {
                            "Administrateurs"
                        }
                        else {
                            Write-Host "Le groupe Administrateurs n'existe pas sur cette machine."
                            break
                        }
                        Add-LocalGroupMember -Group $group_name -Member $user_name
                        Write-Host "`nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !"
                        Log "AddSudoGrpNewUser"
                        end_user_return
                        return
                    }

                    "2" {
                        Clear-Host                        
                        Write-Host "`nVoici la liste des groupes locaux existants :`n"
                        Start-Sleep 1
                        #ssh cliwin01 "Get-LocalGroup | Where-Object { \$_.Name -notmatch '^(Administrators|Users|Guests)$' } | Sort-Object Name"
                        Get-LocalGroup | Where-Object { $_.SID -notmatch '^S-1-5-32-' } | Select-Object -ExpandProperty Name 
                        Write-Host ""
                        
                        while ($true) {
                            Write-Host  "Dans quel groupe existant ci-dessus souhaitez-vous être ajouté ?"
                            $local_grp = Read-Host "Votre choix"
                            #if ssh cliwin01 "Get-LocalGroup -Name \"$local_grp\" *>\$null"
                            #if ssh cliwin01 "Get-LocalGroup -Name \"$local_grp\" -ErrorAction SilentlyContinue"
                            if (Get-LocalGroup -Name $local_grp -ErrorAction SilentlyContinue) {
                                #ssh cliwin01 "Add-LocalGroupMember -Group \"$local_grp\" -Member \"$user_name\""
                                Add-LocalGroupMember -Group $local_grp -Member $user_name
                                Write-Host "`nL'utilisateur $user_name a été ajouté au groupe $local_grp avec succès !"
                                Log "AddLocalGrpNewUser"
                                while ($true) {
                                    Start-Sleep 2
                                    Clear-Host
                                    Write-Host "`nVoulez-vous accorder des droits administrateurs à l'utilisateur ?`n`n1 - Oui`n2 - Non`n3 - Retour au Menu Gestion des Utilisateurs.`nX - Sortir.`n"
                                    $mod_sudo = Read-Host "Votre choix"
                                    switch ($mod_sudo) {
                                        "1" {
                                            #ssh cliwin01 "Add-LocalGroupMember -Group \"Administrators\" -Member \"$user_name\""
                                            $group_name = if (Get-LocalGroup -Name "Administrators" -ErrorAction SilentlyContinue) {
                                                "Administrators"
                                            }
                                            elseif (Get-LocalGroup -Name "Administrateurs" -ErrorAction SilentlyContinue) {
                                                "Administrateurs"
                                            }
                                            else {
                                                Write-Host "Le groupe Administrateurs n'existe pas sur cette machine."
                                                break
                                            }
                                            Add-LocalGroupMember -Group $group_name -Member $user_name
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

                                        {$_ -match '^[xX]$' }{
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
                                Write-Host "`nLe groupe $local_grp n'existe pas. Veuiller réessayer SVP.`n"
                                Log "LocalGroupDoesntExist"
                                continue
                            }
                            
                        }
                                               
                    }

                    "3" {
                        Write-Host "`nRetour au Menu Gestion des Utilisateurs..."
                        Log "ReturnUserManagementMenu"
                        return
                    }

                    {$_ -match '^[xX]$' }{
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

        {$_ -match '^[xX]$' }{
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
