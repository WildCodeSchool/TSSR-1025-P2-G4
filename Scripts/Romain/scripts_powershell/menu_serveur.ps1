# Menu Serveur (PowerShell)


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

function Linux {

    # Menu et actions pour machines Linux
    Write-Host "Connexion à la Linux..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1

    # Pour l'instant on demande l'IP à la main
    # Adapter avec nmap pour windows
    # Scan simple du réseau
    Log "RecuperationIP"
    Write-Host " Scan du réseau en cours..."
    # Commande pour scanner le réseau et garder juste le nom de machine et l'IP associer
    nmap -sn 172.16.40.0/24 -oG - | Select-String 'Host: ' | ForEach-Object {
        if ($_ -match 'Host: (\S+) \((.*)\)'){
            [PSCustomObject]@{
                IP       = $matches[1]
                Hostname = if ($matches[2]) { $matches[2] } else { "Inconnu" }
            }
        }
    } | Format-Table -AutoSize
    Write-Host ""
    $AdresseIp = Read-Host "Rentrez une adresse IP"
    Write-Host ""

    # Pour l'instant on rentre un admin à la main
    # Trouver une commande pour le faire en SSH
    # Récuperation des comptes admin
    Log "RecuperationCompteAdmin"
    Write-Host "Liste des utilisateurs disponible sur la cible..."
    Write-Host ""
    # Connexion ssh sans personalisation pour trouver un compte administrateur
    ssh -o ConnectTimeout=10 wilder@172.16.40.30 "cat /etc/group" | grep "sudo"
    Write-Host ""
    $NomMachine = Read-Host "Puis rentrez un nom d'utilisateur"
    Write-Host ""

    # Test de réponse avec la machine cible
    Log "Ping"
    if (Test-Connection -ComputerName $AdresseIp -Count 2 -Quiet) {
        Write-Host "Ping OK"
        Start-Sleep -Seconds 1
    }

    else {
        Write-Host "Ping échoué"
        Start-Sleep -Seconds 1
        return
    }

    # Connexion initiée
    Write-Host ""
    Write-Host "Connexion à la machine Linux..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Log "ConnexionMachineLinux"
    Start-Sleep -Seconds 1

    # Appel du script menu_linux.ps1 
    & "$PSScriptRoot\linux\menu_linux.ps1" -NomMachine $NomMachine -IpMachine $AdresseIp
    Start-Sleep -Seconds 10
}

function Windows {

    # Menu et actions pour machines Linux
    Write-Host "Connexion à la Windows..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Start-Sleep -Seconds 1

    # Pour l'instant on demande l'IP à la main
    # Adapter avec nmap pour windows
    # Scan simple du réseau
    Log "RecuperationIP"
    Write-Host " Scan du réseau en cours..."
    # Commande pour scanner le réseau et garder juste le nom de machine et l'IP associer
    nmap -sn 172.16.40.0/24 -oG - | Select-String -Pattern 'Host: ' | ForEach-Object {
        $_.Line -replace '.*Host: (\S+) \(([^)]*)\).*', '$1 ($2)'
    }
    Write-Host ""
    $AdresseIp = Read-Host "Rentrez une adresse IP"
    Write-Host ""

    # Pour l'instant on rentre un admin à la main
    # Trouver une commande pour le faire en SSH
    # Récuperation des comptes admin
    Log "RecuperationCompteAdmin"
    Write-Host "Liste des utilisateurs disponible sur la cible..."
    Write-Host ""
    # Connexion ssh sans personalisation pour trouver un compte administrateur
    # Je n'ai pas pu faire plus propre
    ssh -o ConnectTimeout=10 wilder@$AdresseIp "net localgroup Administrateurs"
    Write-Host ""
    $NomMachine = Read-Host "Puis rentrez un nom d'utilisateur"
    Write-Host ""

    # Test de réponse avec la machine cible
    Log "Ping"
    if (Test-Connection -ComputerName $AdresseIp -Count 2 -Quiet) {
        Write-Host "Ping OK"
        Start-Sleep -Seconds 1
    }

    else {
        Write-Host "Ping échoué"
        Start-Sleep -Seconds 1
        return
    }

    # Connexion initiée
    Write-Host ""
    Write-Host "Connexion à la machine Windows..."
    Write-Host ""
    Write-Host " ---------------------------------------------- "
    Write-Host ""
    Log "ConnexionMachineWindows"
    Start-Sleep -Seconds 1

    # Appel du script menu_linux.ps1 
    & "$PSScriptRoot\windows\menu_windows.ps1" -NomMachine $NomMachine -IpMachine $AdresseIp

}


# Debut du log
Log "StartScript"

# Creation d'une petite interface graphique

while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host "####                                       ####"
    Write-Host "####                                       ####"
    Write-Host "####             Menu serveur              ####"
    Write-Host "####                                       ####"
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host ""

    # Choix de la machine

    Write-Host "Choisissez dans quelle machine client vous voulez aller. "
    Write-Host ""
    Write-Host "1) Linux "
    Write-Host "2) Windows "
    Write-Host "x) Sortir "
    Write-Host ""
    $client = Read-Host "Votre choix"
    Write-Host ""

    switch ($client) {
        "1" {
            Write-Host "Machines Linux :"
            Write-Host ""
            Log "MenuSelectionLinux"
            Linux
        }
        "2" {
            Write-Host "Machines Windows :"
            Write-Host ""
            Log "MenuSelectionWindows"
            Windows
        }
        { $_ -ieq "x" } {
            Write-Host "Au revoir "
            Write-Host ""
            Log "EndScript"
            exit 0
        }
        default {
            Write-Host "Choix invalide ! "
            Write-Host ""
            Write-Host " ---------------------------------------------- "
            Write-Host ""
            Start-Sleep -Seconds 1
            Log "MauvaisChoix"
        }
    }
}





