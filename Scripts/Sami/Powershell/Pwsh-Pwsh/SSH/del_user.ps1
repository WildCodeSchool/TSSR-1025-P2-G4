
#######################################################################################################
# Partie Suppression Utilisateur
#######################################################################################################


#Fonction retour
function end_user_return() {
    while ($true) {
        Start-Sleep 2
        Clear-Host
        Write-Host "`nVoulez-vous retourner au au Menu Gestion des Utilisateurs ou sortir du script ?`n"
        Write-Host "1 - Retour au Menu Gestion des Utilisateurs.`nX - Sortir.`n"
        $choice_return_end = Read-Host "Votre choix" 
        switch ($choice_return_end) {
            "1" {
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
    Write-Host "`nBienvenue dans l'Espace Suppression Utilisateur !"
    Log "WelcomeToUserDeletionArea"
    Write-Host "`nSouhaitez-vous supprimer l'utilisateur $user_name ?`n`n1 - Oui, supprimer.`n2 - Retour à l'Espace Personnel Utilisateur ?`nX - Sortir.`n"
    $del_user = Read-Host "Votre choix" 
    switch ($del_user) {       
        "1" {
            #Suppression utilisateur ainsi que son répertoire personnel
            ssh -t -o ConnectTimeout=10 cliwin01 "Remove-LocalUser -Name '$user_name'; Remove-Item 'C:\Users\$user_name' -Recurse -Force -ErrorAction SilentlyContinue"
            Write-Host "`nL'utilisateur $user_name ainsi que son répertoire personnel a été supprimé !`n"
            Log "UserDeletion"
            end_user_return
            return
        }

        "2" {
            Write-Host "`nRetour à l'Espace Personnel Utilisateur...`n"
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