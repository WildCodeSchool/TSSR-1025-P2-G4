# Menu Linux (PowerShell)

param(
    [string]$NomMachine,
    [string]$IpMachine
)

# Initialisation des fonctions 

# Journalisation
function Log {
    param ([string]$evenement)
    if (-not (Test-Path "C:\Windows\System32\LogFiles")) {
        New-Item -ItemType Directory -Path "C:\Windows\System32\LogFiles" -Force | Out-Null
    }
    $fichier_log = "C:\Windows\System32\LogFiles\log_evt.log"
    $date_actuelle = Get-Date -Format "yyyyMMdd"
    $heure_actuelle = Get-Date -Format "HHmmss"
    $utilisateur = $env:USERNAME
    Add-Content -Path $fichier_log -Value "${date_actuelle}_${heure_actuelle}_${utilisateur}_${evenement}"
}

# Module 1 : Actions Machine
function Module_1 {
    Write-Host "Connexion au module 1..."
    & "$PSScriptRoot\module_1.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}

# Module 2 : Gestion des Utilisateurs
function Module_2 {
    Write-Host "Connexion au module 2..."
    & "$PSScriptRoot\module_2.ps1" -NomMachine $NomMachine -IpMachine $IpMachine
}

# Module 3 : Informations Machine
function Module_3 {
    Write-Host "Connexion au module 3..."
    Write-Host "Utilisation de la session héritée..." -ForegroundColor DarkGray
    Start-Sleep -Seconds 1
    Log "MenuInformationsMachine"
    
    # --- CORRECTION ICI ---
    # On appelle le fichier (vérifie bien que le nom du fichier est correct !)
    # Si ton fichier s'appelle Module3WindowsToBash.ps1, change le nom ci-dessous :
    & "$PSScriptRoot\Module3WindowsToBash.ps1" -Session $Global:SessionLinux
}

# Log au démarrage
Log "NewScript"

# Boucle principale
while ($true) {
    Clear-Host
    Write-Host "###############################################"
    Write-Host "####               Menu Linux              ####"
    Write-Host ("####  Cible : {0} ({1})  ####" -f $IpMachine, $UserSSH)
    Write-Host "###############################################"
    Write-Host "1) Menu action machine"
    Write-Host "2) Menu gestion des utilisateurs"
    Write-Host "3) Menu information machine (SSH Hérité)"
    Write-Host "x) Sortir et fermer la connexion"
    Write-Host ""
    $module = Read-Host "Votre choix"

    switch ($module) {
        "1" { Module_1; Log "MenuActionMachine" }
        "2" { Module_2; Log "MenuGestionDesUtilisateurs" }
        "3" { Module_3; Log "MenuInformationsMachine" } # L'appel corrigé est dans la fonction
        { $_ -ieq "x" } {
            Write-Host "Fermeture de la session SSH et sortie..."
            if ($Global:SessionLinux) { Remove-PSSession $Global:SessionLinux }
            Log "EndScript"
            return # Ou exit
        }
        default { Write-Host "Choix invalide !"; Start-Sleep -Seconds 1 }
    }

}
