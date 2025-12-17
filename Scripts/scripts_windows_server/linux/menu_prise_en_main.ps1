# Mene Prise En Main (PowerShell)

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

# Prise en main
function PriseEnMain {
    Write-Host "Lancement de la prise en main distante..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Log "PriseEnMainDistanteEnCLI_${NomMachine}_${IpMachine}"
    
    Write-Host "Connexion SSH vers $NomMachine@$IpMachine..."
    Write-Host "Tapez 'exit' pour revenir au menu."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    
    try {
        # Connexion SSH interactive vers la machine Windows
        ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine"
        
        Write-Host ""
        Write-Host "Deconnexion de la prise en main distante."
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "Erreur lors de la connexion SSH : $_"
        Write-Host ""
    }
    
    Start-Sleep -Seconds 2
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
    Write-Host ("####  {0,-35}  ####" -f "$NomMachine")
    Write-Host ("####  {0,-35}  ####" -f "$IpMachine")
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
