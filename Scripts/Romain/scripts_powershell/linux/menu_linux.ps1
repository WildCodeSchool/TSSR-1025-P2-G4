# Menu Linux (PowerShell)

# Initialisation des arguments

param(
    [string]$NomMachine,
    [string]$IpMachine
)

# Initialisation des fonctions 

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

# Module 1 : Actions Machine
function Module_1 {
    Write-Host "Connexion au module 1..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1
    Log "MenuActionMachine"
    
    # Appel du script module_1.ps1
    & "$PSScriptRoot\linux\module_1.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}

# Module 2 : Gestion des Utilisateurs
function Module_2 {
    Write-Host "Connexion au module 2..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1
    Log "MenuGestionDesUtilisateurs"
    
    # Appel du script module_2.ps1
    & "$PSScriptRoot\linux\module_2.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}

# Module 3 : Informations Machine
function Module_3 {
    Write-Host "Connexion au module 3..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1
    Log "MenuInformationsMachine"
    
    # Appel du script module_3.ps1
    & "$PSScriptRoot\linux\module_3.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}


Log "NewScript"

# Boucle principale du menu
while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host "####                                       ####"
    Write-Host "####                                       ####"
    Write-Host "####             Menu Linux                ####"
    Write-Host ("####  {0,-37}  ####" -f "$NomMachine $IpMachine")
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host ""

    # Choix du module
    Write-Host "Choisissez dans quel module vous voulez aller."
    Write-Host ""
    Write-Host "1) Menu action machine"
    Write-Host "2) Menu gestion des utilisateurs"
    Write-Host "3) Menu information machine"
    Write-Host "4) Retour Menu Serveur"
    Write-Host "x) Sortir"
    Write-Host ""
    $module = Read-Host "Votre choix"
    Write-Host ""

    switch ($module) {
        "1" {
            Write-Host "Menu action machine"
            Write-Host ""
            Module_1
            Log "MenuActionMachine"
        }
        "2" {
            Write-Host "Menu Gestion des Utilisateurs"
            Write-Host ""
            Module_2
            Log "MenuGestionDesUtilisateurs"
        }
        "3" {
            Write-Host "Menu information machine"
            Write-Host ""
            Module_3
            Log "MenuInformationsMachine"
        }
        "4" {
            Write-Host "Retour Menu Serveur"
            Write-Host ""
            Write-Host "Connexion Menu Serveur..."
            Write-Host ""
            Write-Host " ---------------------------------------------- "
            Write-Host ""
            Start-Sleep -Seconds 1
            Log "RetourMenuServeur"
            return
        }
        { $_ -ieq "x" } {
            Write-Host "Au revoir"
            Write-Host ""
            Log "EndScript"
            exit 0
        }
        default {
            Write-Host "Choix invalide !"
            Write-Host ""
            Write-Host " ---------------------------------------------- "
            Write-Host ""
            Start-Sleep -Seconds 1
            Log "MauvaisChoix"
        }
    }

}
