# Menu Redémarrage (PowerShell)

# Initialisation des arguments

param(
    [string]$NomMachine,
    [string]$IpMachine
)

# Initialisation des fonctions 

# Journalisation
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

# Fonction de redémarrage
function Redemarrage {
    Write-Host "Redemarrage de la machine..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Log "RedemarrageMachine_${NomMachine}_${IpMachine}"
    
    try {
        Write-Host "Envoi de la commande de redemarrage..."
        
        # Méthode 1 : Via Invoke-Command (WinRM)
        # Invoke-Command -ComputerName $IpMachine -ScriptBlock { Restart-Computer -Force }
        
        # Méthode 2 : Via SSH (si OpenSSH est installé sur la cible Windows)
        $sshCommand = "shutdown /r /t 0 /f"
        ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" $sshCommand 2>&1 | Out-Null
        
        Write-Host ""
        Write-Host "Commande de redemarrage envoyee avec succes !"
        Write-Host "La machine $NomMachine ($IpMachine) est en cours de redemarrage..."
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "Erreur lors du redemarrage : $_"
        Write-Host ""
    }
    
    Start-Sleep -Seconds 1
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
    Write-Host "####           Menu Redemarrage            ####"
    Write-Host ("####  {0,-35}  ####" -f "$NomMachine")
    Write-Host ("####  {0,-35}  ####" -f "$IpMachine")
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host ""

    Write-Host "Choisissez quelle action effectuer."
    Write-Host ""
    Write-Host "1) Redemarrer la machine"
    Write-Host "2) Retour menu action machine"
    Write-Host "x) Sortir"
    Write-Host ""
    $choix = Read-Host "Votre choix"
    Write-Host ""

    switch ($choix) {
        "1" {
            Write-Host "Redemarrage de la machine"
            Write-Host ""
            
            # Demande de confirmation
            $confirmation = Read-Host "Etes-vous sur de vouloir redemarrer $NomMachine ? (O/N)"
            if ($confirmation -ieq "O" -or $confirmation -ieq "Oui") {
                Redemarrage
            }
            else {
                Write-Host "Redemarrage annule."
                Start-Sleep -Seconds 1
            }
        }
        
        "2" {
            Write-Host "Retour Menu action machine"
            Write-Host ""
            Start-Sleep -Seconds 1
            Log "RetourMenuActionMachine"
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
            Start-Sleep -Seconds 1
            Log "MauvaisChoix"
        }
    }
}

