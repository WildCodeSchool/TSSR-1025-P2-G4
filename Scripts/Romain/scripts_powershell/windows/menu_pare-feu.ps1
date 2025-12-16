# Menu Windows (PowerShell)

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

# Fonction de l'état du pare-feu
function Etat {
    Write-Host "Le pare-feu est : "
    Log "EtatPareFeu_${NomMachine}_${IpMachine}"
    
    try {
        # Cette commande donne l'état du pare feu sur la machine cible
        $sshCommand = "Get-NetFirewallProfile | Select-Object Name, Enabled"
        ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" $sshCommand 2>&1 | Out-Null
        
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "Erreur lors de la récupération de l'état : $_"
        Write-Host ""
    }
    
    Start-Sleep -Seconds 4
}

# Fonction Activation du pare-feu
function Activation {
    Write-Host "Activation du pare-feu"
    Log "ActivationPareFeu_${NomMachine}_${IpMachine}"
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    
    try {
        # Cette commande donne l'état du pare feu sur la machine cible
        $sshCommand = "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True"
        ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" $sshCommand 2>&1 | Out-Null
        
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "Erreur lors de l'activation : $_"
        Write-Host ""
    }
    
    Start-Sleep -Seconds 2
    
}

# Fonction Désactivation du pare-feu
function Desactivation {
    Write-Host "Desactivation du pare-feu"
    Log "ActivationPareFeu_${NomMachine}_${IpMachine}"
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    
    try {
        # Cette commande donne l'état du pare feu sur la machine cible
        $sshCommand = "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False"
        ssh -o ConnectTimeout=10 -t "$NomMachine@$IpMachine" $sshCommand 2>&1 | Out-Null
        
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "Erreur lors de la désactivation : $_"
        Write-Host ""
    }
    
    Start-Sleep -Seconds 2
    
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
    Write-Host "####             Menu Pare-feu             ####"
    Write-Host ("####  {0,-37}  ####" -f "$NomMachine $IpMachine")
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host ""

    Write-Host "Choisissez quelle action effectuer."
    Write-Host ""
    Write-Host "1) Etat du pare-feu"
    Write-Host "2) Activation du pare-feu"
    Write-Host "3) Désactivation du pare-feu"
    Write-Host "4) Retour menu action machine"
    Write-Host "x) Sortir"
    Write-Host ""
    $choix = Read-Host "Votre choix"
    Write-Host ""

    switch ($choix) {
        "1" {
            Write-Host "Etat du pare-feu"
            Write-Host ""
            Etat
        }
        
        "2" {
            Write-Host "Activation du pare-feu"
            Write-Host ""
            Start-Sleep -Seconds 1
            Activation
        }

        "3" {
            Write-Host "Désactivation du pare-feu"
            Write-Host ""
            Start-Sleep -Seconds 1
            Desactivation
        }
        
        "4" {
            Write-Host "Retour Menu Action Machine"
            Write-Host ""
            Start-Sleep -Seconds 1
            Log "RetourMenuActionMachine"
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
            Start-Sleep -Seconds 1
            Log "MauvaisChoix"
        }
    }
}
