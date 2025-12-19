# Module 1 (PowerShell)

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

# Menu prise en main
function PriseEnMain {
    Write-Host "Connexion au menu prise en main..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1
    
    # Appel du script menu_prise_en_main.ps1
    & "$PSScriptRoot\menu_prise_en_main.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}

# Menu pare-feu
function PareFeu {
    Write-Host "Connexion au menu pare-feu..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1
    
    # Appel du script menu_pare-feu.ps1
    & "$PSScriptRoot\menu_pare-feu.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}

# Menu redémarrage
function Redemarrage {
    Write-Host "Connexion au menu rdémarrage..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1
    
    # Appel du script menu_redemarrage.ps1
    & "$PSScriptRoot\menu_redemarrage.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}

# Menu répertoire
function Repertoire {
    Write-Host "Connexion au menu répértoire..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1
    
    # Appel du script menu_redemarrage.ps1
    & "$PSScriptRoot\directory_management.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}


# Log au démarrage du script
Log "NewScript"

# Boucle principale du menu
while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host "####                                       ####"
    Write-Host "####                                       ####"
    Write-Host "####          Menu Action Machine          ####"
    Write-Host ("####  {0,-35}  ####" -f "$NomMachine")
    Write-Host ("####  {0,-35}  ####" -f "$IpMachine")
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host ""

    # Choix du module
    Write-Host "Choisissez dans quel module vous voulez aller."
    Write-Host ""
    Write-Host "1) Menu prise en main distante"
    Write-Host "2) Menu pare-feu"
    Write-Host "3) Menu redémarrage"
    Write-Host "4) Menu gestion de répertoire (En cours)"
    Write-Host "5) Retour menu Linux"
    Write-Host "x) Sortir"
    Write-Host ""
    $module = Read-Host "Votre choix"
    Write-Host ""

    switch ($module) {
        "1" {
            Write-Host "Menu prise en main distante"
            Write-Host ""
            PriseEnMain "$NomMachine" "$IpMachine"
            Log "PriseEnMain"
        }
        "2" {
            Write-Host "Menu pare-feu"
            Write-Host ""
            PareFeu "$NomMachine" "$IpMachine"
            Log "PareFeu"
        }
        "3" {
            Write-Host "Menu redémarrage"
            Write-Host ""
            Redemarrage "$NomMachine" "$IpMachine"
            Log "MenuRedemarrage"
        }
        "4" {
            Write-Host "Menu gestion de répértoire"
            Write-Host ""
            Repertoire "$NomMachine" "$IpMachine"
            Log "MenuRepertoire"
        }
        "5" {
            Write-Host "Retour Menu Linux"
            Write-Host ""
            Write-Host "Connexion Menu Linux..."
            Write-Host ""
            Write-Host " ---------------------------------------------- "
            Write-Host ""
            Start-Sleep -Seconds 1
            Log "RetourMenuLinux"
            return
        }
        { $_ -ieq "x" } {
            Write-Host "Au revoir"
            Write-Host ""
            Log "EndScript"
            throw
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


