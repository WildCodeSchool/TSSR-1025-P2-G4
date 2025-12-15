# Script Module 2 : Menu Gestion des Utilisateurs

param (
    [string]$NomMachine,
    [string]$IpMachine
)

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
    Write-Host ""
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host "####                                       ####"
    Write-Host "####                                       ####"
    Write-Host "####     Menu Gestion des Utilisateurs     ####"
    Write-Host ("####  {0,-20} {1,-14}  ####`n" -f $NomMachine, $IpMachine)
    Write-Host "####                                       ####"
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host "Bienvenue dans le Menu Gestion des Utilisateurs."
    Write-Host ""
    Log "WelcomeToUserManagementMenu"
    Write-Host "1 - Continuer dans le Menu Gestion des Utilisateurs."
    Write-Host "2 - Retourner dans le Menu Linux."
    Write-Host "X - Sortir."
    Write-Host ""
    $choice_menu_module_2 = Read-Host "Votre choix" 
    switch ($choice_menu_module_2) {
        "1" {
            Write-Host ""
            $user_name = Read-Host "Entrez un Nom d'Utilisateur"
            #ssh cliwin01 "Get-LocalUser -Name \"$user_name\" *>\$null"
            #ssh cliwin01 "Get-LocalUser -Name \"$user_name\" -ErrorAction SilentlyContinue"
            if (Get-LocalUser -Name $user_name -ErrorAction SilentlyContinue) {
                Clear-Host
                Write-Host "`nBon retour $user_name !`n`nRedirection vers l'Espace Personnel Utilisateur..."
                Log "UserEntryExists"
                Log "UserPersonnalAreaRedirection"
                . "$HOME\scripts_windows_server\windows\menu_user_exist.ps1"
            }
            else {
                Clear-Host
                Write-Host "`nL'utilisateur $user_name n'existe pas.`n`nRedirection vers l'Espace Création Utilisateur..."
                Log "UserEntryDoesntExist"
                Log "UserCreationAreaRedirection" 
                . "$HOME\scripts_windows_server\create_user.ps1"
            }
            continue
        }

        "2" {
            Write-Host "`nRetour au Menu Linux..."
            Log "ReturnLinuxMenu"
            return
        }
        
        {$_ -match '^[xX]$' } {
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
