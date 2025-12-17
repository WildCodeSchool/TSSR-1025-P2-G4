# Menu Redémarrage (PowerShell)

# Initialisation des arguments

param(
    [string]$NomMachine,
    [string]$IpMachine
)

# Initialisation des fonctions

# Fonction de redémarrage
function Redemarrage {
    Write-Host "Redemarrage de la machine..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Log "RedemarrageMachine_${NomMachine}_${IpMachine}"
    
    try {
        Write-Host "Envoi de la commande de redemarrage..."

        # Commande de redémarrage en Bash
        $sshCommand = "sudo reboot now"
        ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" $sshCommand 2>&1
        
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
    Write-Host "2) Retour Menu Module 1"
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
            Write-Host "Retour Menu Module 1"
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
