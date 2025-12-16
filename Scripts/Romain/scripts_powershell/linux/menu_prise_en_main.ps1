# Module 1 (PowerShell)

# Initialisation des arguments

param(
    [string]$NomMachine,
    [string]$IpMachine
)

# Initialisation des fonctions 

function Log {


}

# Prise en main
function PriseEnMain {
    Write-Host "Lancement de la prise en main..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1

    # Connexion ssh pour la prise en main
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
    Write-Host "####          Menu Action Machine          ####"
    Write-Host ("####  {0,-37}  ####" -f "$NomMachine $IpMachine")
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host ""

    # Choix du module
    Write-Host "Choisissez dans quel module vous voulez aller."
    Write-Host ""
    Write-Host "1) Prise en main distante"
    Write-Host "2) Retour Menu Action Machine"
    Write-Host "x) Sortir"
    Write-Host ""
    $module = Read-Host "Votre choix"
    Write-Host ""

    switch ($module) {
        "1" {
            Write-Host "Prise en main distante en CLI"
            Write-Host ""
            PriseEnMain "$NomMachine" "$IpMachine"
            Log "PriseEnMain"
        }
        "2" {
            Write-Host "Retour Menu Linux"
            Write-Host ""
            Write-Host "Connexion Menu Linux..."
            Write-Host ""
            Write-Host " ---------------------------------------------- "
            Write-Host ""
            Start-Sleep -Seconds 1
            Log "RetourModule1"
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