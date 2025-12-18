
#######################################################################################################
# Partie Espace Personnel des Utilisateurs
#######################################################################################################


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
    Write-Host "`nBienvenue dans l'Espace Personnel Utilisateur !`n"
    Log "WelcomeToUserPersonnalArea"
    Write-Host "Que souhaitez-vous faire ?`n"
    Write-Host "1 - Apporter des modifications à l'utilisateur $user_name.`n2 - Supprimer l'utilisateur $user_name.`n3 - Afficher des Infos sur l'utilisateur $user_name.`n4 - Retourner au Menu Gestion des Utilisateurs.`nX - Sortie.`n"
    $choice_menu_user_exist = Read-Host "Votre choix" 
    switch ($choice_menu_user_exist) {
        "1" {
            #Vers Espace Modification Utilisateur
            Write-Host "`nRedirection vers l'Espace Modification Utilisateur...`n"
            Log "UserModificationAreaRedirection"
            . "$HOME\scripts_windows_server\linux\modif_user.ps1"
            continue
        }
        
        "2" {
            #Vers Espace Suppression Utilisateur
            Write-Host "`nRedirection vers l'Espace Supression Utilisateur...`n"
            Log "UserDeletionAreaRedirection"
            . "$HOME\scripts_windows_server\linux\del_user.ps1"
            
            #Vérification si l'utilisateur existe toujours après passage dans l'Espace Suppression Utilisateur
            if (ssh -t -o ConnectTimeout=10 clilin01 "id '$user_name' &>/dev/null") { 
                continue
            }
            else {
                Write-Host "`nRetour au Menu Gestion des Utilisateurs...`n"
                Log "ReturnUserManagementMenu"
                return
            }
        }
        
        "3" {
            Write-Host "`nRedirection vers l'Espace Informations Utilisateur...`n"
            Log "UserInformationAreaRedirection"
            . "$HOME\scripts_windows_server\linux\info_user.ps1"
            continue
        }
        
        "4" {
            Write-Host "`nRetour au Menu Gestion des Utilisateurs...`n"
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