#######################################################################################################
# Partie Informations Utilisateur
#######################################################################################################


#Fonction retour
function end_user_return() {
    while ($true) {
        Start-Sleep 2
        Clear-Host
        Write-Host "`nDésirez-vous d'autres informations sur l'utilisateur $user_name ou sortir du script ?`n"
        Write-Host "1 - Retourner au Menu de l'Espace Informations Utilisateur."
        Write-Host "X - Sortie.`n"
        $choiceRec = Read-Host "Votre choix"

        switch ($choiceRec) {
            "1" {
                Write-Host "`nRetour au Menu de l'Espace Informations de l'Utilisateur...`n"
                Log "ReturnUserInformationArea"
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
    Write-Host "`nBienvenue dans l'Espace Informations Utilisateur !`n"
    Log "WelcomeToUserInformationArea"
    Write-Host "Quelles informations désirez-vous connaître sur l'utilisateur $user_name ?`n"
    Write-Host "1 - Date de la dernière connexion."
    Write-Host "2 - Date de dernière modification du mot de passe."
    Write-Host "3 - Liste des sessions ouvertes par l’utilisateur."
    Write-Host "4 - Retour à l'Espace Personnel de l'Utilisateur."
    Write-Host "X - Quitter le script.`n"
    $choice = Read-Host "Votre choix"

    switch ($choice) {
        "1" {
            Write-Host "`nDernière connexion de $user_name :`n"

            #Redirection vers une variable pour appeler la commande
            $last_connexion = ssh -t -o ConnectTimeout=10 cliwin01 "quser 2>'$null' | Where-Object { $_ -match '$user_name' }"

            #Vérification s'il y a déjà eu une connexion de la part de l'utilisateur
            if ([string]::IsNullOrWhiteSpace($last_connexion) -or $null -eq $last_connexion) {
                Write-Host "Il n'y a eu aucune connexion de l'utilisateur $user_name.`n"                
            }
            else {
                Write-Host "$last_connexion"
            }
            Log "LastConnexion"
            end_user_return
            continue
        }

        "2" {
            Write-Host "`nDate de dernière modification du mot de passe :"

            #Redirection vers une variable pour appeler la commande 
            $password_date = ssh -t -o ConnectTimeout=10 cliwin01 "(Get-LocalUser -Name '$user_name').PasswordLastSet"

            #Vérification s'il y a déjà eu une modification de mot de passe de la part de l'utilisateur
            if ([string]::IsNullOrWhiteSpace($password_date) -or $null -eq $password_date) {
                Write-Host "`nIl n'y a pas eu de changement de mot de passe pour l'utilisateur $user_name`n"
            }
            else {
                $password_date
            }
            Log "DateLastPasswordChange"
            end_user_return
            continue
        }

        "3" {
            Write-Host "`nSessions ouvertes par $user_name :"

            #Redirection vers une variable pour appeler la commande            
            $session = ssh -t -o ConnectTimeout=10 cliwin01 "Get-WinEvent -FilterHashtable @{LogName = 'Security'; Id = 4624 } | Where-Object { $_.Properties[5].Value -eq '$user_name' } | Select-Object -First 1 TimeCreated"
            
            #Vérification si l'utilisateur a une session ouverte actuellement
            if ([string]::IsNullOrWhiteSpace($session) -or $null -eq $session) {
                Write-Host "`nIl n'y a pas de session ouverte par l'utilisateur $user_name.`n"
            }
            else {
                $session
            }
            Log "ListOpenUserSessions"
            end_user_return
            continue
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
            Write-Host "`nErreur de saisie.`nVeuillez faire selon ce qui est proposé"
            Log "InputError"
            continue
        }
    }
}
