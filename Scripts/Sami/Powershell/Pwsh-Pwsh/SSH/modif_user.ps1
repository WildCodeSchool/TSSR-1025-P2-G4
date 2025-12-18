
#######################################################################################################
# Partie Modification de l'Utilisateur
#######################################################################################################


#Fonction Retour
function end_user_return {
    while ($true) { 
        Start-Sleep 2
        Clear-Host
        Write-Host "`nVoulez-vous retourner au menu précédent ou sortir du script ?`n"
        Write-Host "1 - Retour au Menu de l'Espace Modification Utilisateur.`nX - Sortir.`n"
        $choice_return_end = Read-Host "Votre choix" 
        switch ($choice_return_end) {
            "1" {
                Write-Host "`nRetour au Menu de l'Espace Modification Utilisateur..."
                Log "ReturnUserModificationArea"
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


#Fonction ajout au groupe administrateur
function add_user_admin_grp {
    param(
        [string]$user_name
    )
    while ($true) {
        #Proposition ajout au groupe administrateur
        Start-Sleep 2
        Clear-Host
        Write-Host "`nVoulez-vous accorder des droits administrateurs à l'utilisateur ?`n`n1 - Oui`n2 - Non`n3 - Retour au Menu Gestion des Utilisateurs.`nX - Sortir.`n"
        $mod_sudo = Read-Host "Votre choix"
        switch ($mod_sudo) {
            "1" {
                #Vérification orthographe du groupe administrateur en fonction de la langue et s'il existe
                $group_name = if (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrators' -ErrorAction SilentlyContinue") {
                    "Administrators"
                }
                elseif (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrateurs' -ErrorAction SilentlyContinue") {
                    "Administrateurs"
                }
                else {
                    Write-Host "Le groupe Administrateurs n'existe pas sur cette machine."
                    break
                }

                #Vérification si l'utilisateur est déjà dans le groupe administrateur
                if (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroupMember -Group '$group_name' -Member '$user_name' -ErrorAction SilentlyContinue") {
                    Write-Host "`nL'utilisateur $user_name fait déjà partie du groupe $group_name."
                }
                else {
                    #Ajout au groupe administrateur
                    ssh -t -o ConnectTimeout=10 cliwin01 "Add-LocalGroupMember -Group '$group_name' -Member '$user_name'"
                    Write-Host "`nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !"
                    Log "AddSudoGrpUser"
                }
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
                Write-Host "`nRetour au Menu de l'Espace Modification Utilisateur..." 
                Log "ReturnUserModificationArea"                                       
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
#Bloc principal
#######################################################################################################

Log "NewScript"

while ($true) {

    Start-Sleep 2
    Clear-Host
    Write-Host "`nBienvenue dans l'Espace Modification de l'Utilisateur !"
    Log "WelcomeToUserModificationArea"
    Write-Host "`nQuelles modifications voulez-vous apporter à l'utilisateur $user_name ?`n`n1 - Modifier le mot de passe.`n2 - Ajouter $user_name au groupe administrateur.`n3 - Ajouter $user_name à un groupe local.`n4 - Retourner dans l'Espace Personnel Utilisateur ?`nX - Sortir.`n"
    $choice_modif_user = Read-Host "Votre choix"
    switch ($choice_modif_user) {
        "1" {
            #Modification mot de passe
            Write-Host ""
            ssh -t -o ConnectTimeout=10 cliwin01 "Set-LocalUser -Name '$user_name' -Password (Read-Host -AsSecureString)"
            Write-Host "`nMot de passe modifié pour $user_name avec succès !`n"
            Log "PasswordChangedUser"
            end_user_return
            continue
        }
        
        "2" {
            #Vérification orthographe du groupe administrateur en fonction de la langue et s'il existe
            $group_name = if (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrators' -ErrorAction SilentlyContinue") {
                "Administrators"
            }
            elseif (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name 'Administrateurs' -ErrorAction SilentlyContinue") {
                "Administrateurs"
            }
            else {
                Write-Host "Le groupe Administrateurs n'existe pas sur cette machine."
                break
            }

            #Vérification si l'utilisateur est déjà dans le groupe administrateur
            if (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroupMember -Group '$group_name' -Member '$user_name' -ErrorAction SilentlyContinue") {
                Write-Host "`nL'utilisateur $user_name fait déjà partie du groupe $group_name."
            }
            else {
                #Ajout au groupe administrateur
                ssh -t -o ConnectTimeout=10 cliwin01 "Add-LocalGroupMember -Group '$group_name' -Member '$user_name'"
                Write-Host "`nL'utilisateur $user_name a été ajouté au groupe administrateur avec succès !"
                Log "AddSudoGrpUser"
            }
            end_user_return
            continue
        }

        "3" {
            while ($true) {
                Clear-Host                        
                Write-Host "`nVoici la liste des groupes locaux existants :`n"
                Start-Sleep 1

                #Vérification s'il y a un groupe local dans lequel l'utilisateur peut être ajouté qui n'est pas un groupe système
                if (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup | Where-Object { $_.SID -notmatch '^S-1-5-32-' } | Select-Object -ExpandProperty Name") {
                    Write-Host ""
                    Write-Host  "Dans quel groupe existant ci-dessus souhaitez-vous être ajouté ?`n"
                    $local_grp = Read-Host "Votre choix"

                    #Vérification si le groupe local choisi existe
                    if (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroup -Name '$local_grp' -ErrorAction SilentlyContinue") {
                        
                        #Vérification si l'utilisateur est déjà dans le groupe local choisi
                        if (ssh -t -o ConnectTimeout=10 cliwin01 "Get-LocalGroupMember -Group '$local_grp' -Member '$user_name' -ErrorAction SilentlyContinue") {
                            Write-Host "`nL'utilisateur $user_name fait déjà partie du groupe $local_grp."
                        }
                        else {
                            #Ajout de l'utilisateur dans le groupe local choisi
                            ssh -t -o ConnectTimeout=10 cliwin01 "Add-LocalGroupMember -Group '$local_grp' -Member '$user_name'"
                            Write-Host "`nL'utilisateur $user_name a été ajouté au groupe $local_grp avec succès !"
                            Log "AddLocalGrpUser"
                        }
                        add_user_admin_grp $user_name
                        break                
                    }
                    else {
                        Write-Host "`nLe groupe $local_grp n'existe pas. Veuillez réessayer SVP.`n"
                        Log "LocalGroupDoesntExist"
                        Start-Sleep 3
                        continue
                    }
                }
                else { 
                    Write-Host "`nIl n'y a aucun groupe dans lequel vous pouvez être ajouté."
                    end_user_return
                    continue
                }
            }            
        }

        "4" { 
            Write-Host "`nRetour dans l'Espace Personnel Utilisateur..."
            Log "ReturnUserPersonnalArea"
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