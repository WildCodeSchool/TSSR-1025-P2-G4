# ==============================================================================
# 0. Gestion du Nettoyage
# ==============================================================================
$Global:RemoteSession = $null

function Cleanup-Session {
    if ($Global:RemoteSession) {
        Write-Host "`n>>> Fermeture de la connexion SSH..." -ForegroundColor Yellow
        Remove-PSSession $Global:RemoteSession
        $Global:RemoteSession = $null
    }
}

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
    if ($Global:RemoteSession) { Remove-PSSession $Global:RemoteSession }
}

# ==============================================================================
# 1. Configuration de la connexion (SSH)
# ==============================================================================
Clear-Host
Write-Host "=== CONFIGURATION DE LA CONNEXION DISTANTE (SSH vers Linux) ===" -ForegroundColor Cyan
Write-Host "Note: La machine cible (Ubuntu) doit avoir PowerShell (pwsh) et SSH installés." -ForegroundColor Gray

$TargetIP = Read-Host "Entrez l'adresse IP de la machine Ubuntu"
$UserName = Read-Host "Entrez le nom d'utilisateur distant (ex: root ou user)"

Write-Host "`n>>> Établissement de la connexion SSH..." -ForegroundColor Yellow

try {
   
    $Global:RemoteSession = New-PSSession -HostName $TargetIP -UserName $UserName -ErrorAction Stop
    Write-Host ">>> Connexion SSH établie avec succès !" -ForegroundColor Green
    Start-Sleep -Seconds 1
}
catch {
    Write-Host "ERREUR : Impossible de se connecter à $TargetIP via SSH." -ForegroundColor Red
    Write-Host "Vérifiez que :"
    Write-Host "1. Le service SSH tourne sur Ubuntu (sudo systemctl status ssh)"
    Write-Host "2. PowerShell est installé sur Ubuntu (snap install powershell --classic)"
    Write-Host "3. Le pare-feu (ufw) autorise le port 22"
    Write-Host "Détail erreur : $_"
    exit
}

function Invoke-RemoteCmd {
    param (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Command,
        [string]$Title = "Exécution"
    )

    Write-Host ">>> $Title sur $TargetIP..." -ForegroundColor Cyan
    try {
        Invoke-Command -Session $Global:RemoteSession -ScriptBlock $Command
    }
    catch {
        Write-Host "Erreur lors de l'exécution : $_" -ForegroundColor Red
    }
    
    Write-Host "`n>>> Fin de la commande." -ForegroundColor DarkGray
    Read-Host "Appuyez sur Entrée pour continuer..."
}

# ==============================================================================
# 2. Fonctions des Sous-Menus (Adaptées Linux)
# ==============================================================================

# --- A. Information Réseau (Commandes Linux) ---
function Show-MenuReseau {
    do {
        Clear-Host
        Write-Host "==== Information réseau (Linux) ====" -ForegroundColor Cyan
        Write-Host "1. DNS actuels (resolvectl/resolv.conf)"
        Write-Host "2. Listing interfaces (ip addr)"
        Write-Host "3. Table ARP (ip neigh)"
        Write-Host "4. Table de routage (ip route)"
        Write-Host "5. Toutes les informations"
        Write-Host "6. Retour menu principal"
        $choix = Read-Host "Votre choix"

        switch ($choix) {
            '1' { Invoke-RemoteCmd -Command { cat /etc/resolv.conf | grep "nameserver" } -Title "DNS Actuels" }
            '2' { Invoke-RemoteCmd -Command { ip -c addr } -Title "Interfaces" }
            '3' { Invoke-RemoteCmd -Command { ip neigh } -Title "Table ARP" }
            '4' { Invoke-RemoteCmd -Command { ip route } -Title "Table de Routage" }
            '5' {
                Invoke-RemoteCmd -Command { 
                    Write-Host "--- DNS ---" -ForegroundColor Yellow
                    cat /etc/resolv.conf | grep "nameserver"
                    Write-Host "`n--- Interfaces ---" -ForegroundColor Yellow
                    ip -br addr
                    Write-Host "`n--- ARP ---" -ForegroundColor Yellow
                    ip neigh
                    Write-Host "`n--- Routage ---" -ForegroundColor Yellow
                    ip route
                } -Title "Full Info Réseau"
            }
            '6' { return }
            Default { Write-Host "Choix invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    } until ($choix -eq '6')
}

# --- B. Information Sys et Matériel (Commandes Linux) ---
function Show-MenuSys {
    do {
        Clear-Host
        Write-Host "==== Information Système et matériel (Linux) ====" -ForegroundColor Cyan
        Write-Host "1. Info CPU/BIOS"
        Write-Host "2. Adresse IP"
        Write-Host "3. Version de l'OS (Release)"
        Write-Host "4. Carte graphique (GPU)"   
        Write-Host "5. Uptime"
        Write-Host "6. Toutes les informations"
        Write-Host "7. Retour au Menu principal"
        $choix = Read-Host "Votre choix"

        switch ($choix) {
            '1' { 
                Invoke-RemoteCmd -Command { 
                    lscpu | grep "Model name"
                    Write-Host "BIOS (si accessible):"
                    if (Test-Path "/sys/class/dmi/id/bios_version") { cat /sys/class/dmi/id/bios_version } else { "Non accessible (besoin sudo)" }
                } -Title "CPU/BIOS" 
            }
            
            '2' { 
                Invoke-RemoteCmd -Command { 
                    hostname -I
                } -Title "IP Address" 
            }
            
            '3' { 
                Invoke-RemoteCmd -Command { 
                    cat /etc/os-release | grep "PRETTY_NAME"
                    uname -r
                } -Title "Version OS" 
            }
            
            '4' { 
                Invoke-RemoteCmd -Command { 
                    $gpu = lspci | grep -i -E "vga|3d|display"
                    if ($gpu) { 
                        $gpu 
                    }
                    else { 
                        Write-Warning "Aucun GPU détecté ou 'lspci' non installé (sudo apt install pciutils)." 
                    }
                } -Title "Carte Graphique" 
            }
            # ------------------------------
            
            '5' { 
                Invoke-RemoteCmd -Command { 
                    uptime -p
                } -Title "Uptime"
            }
            
            '6' {
                Invoke-RemoteCmd -Command {
                    Write-Host "--- CPU ---" -ForegroundColor Yellow
                    lscpu | grep "Model name"
                    
                    Write-Host "`n--- OS ---" -ForegroundColor Yellow
                    cat /etc/os-release | grep "PRETTY_NAME"
                    
                    Write-Host "`n--- GPU ---" -ForegroundColor Yellow
                    $gpu = lspci | grep -i -E "vga|3d|display"
                    if ($gpu) { $gpu } else { "N/A" }
                    # --------------------------------------------------

                    Write-Host "`n--- Disque (Espace) ---" -ForegroundColor Yellow
                    df -h / | grep "/"

                    Write-Host "`n--- Uptime ---" -ForegroundColor Yellow
                    uptime -p
                } -Title "Full Info Système"
            }
            
            '7' { return }
            Default { Write-Host "Choix invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    } until ($choix -eq '7')
}

# --- C. Evènements Logs (Journalctl) ---
function Show-MenuLogs {
    do {
        Clear-Host
        Write-Host "==== Information Logs (Journalctl) ====" -ForegroundColor Cyan
        Write-Host "1. 10 dernières erreurs (Priorité 0-3)"
        Write-Host "2. Échecs d'authentification (SSH/Sudo)"
        Write-Host "3. Logs système récents (Tout)"
        Write-Host "4. Logs Kernel (dmesg style)"
        Write-Host "5. Toutes les informations"
        Write-Host "6. Retour au Menu principal"
        $choix = Read-Host "Votre choix"

        switch ($choix) {
            '1' { 
                Invoke-RemoteCmd -Command { 
                    journalctl -p 0..3 -n 10 --no-pager
                } -Title "Erreurs Critiques" 
            }

            '2' { 
                Invoke-RemoteCmd -Command { 
                    grep "Failed password" /var/log/auth.log | tail -n 10
                } -Title "Echecs Auth" 
            }

            '3' { 
                Invoke-RemoteCmd -Command { 
                    journalctl -n 20 --no-pager
                } -Title "Logs Système (Récents)" 
            }

            '4' { 
                Invoke-RemoteCmd -Command { 
                    journalctl -k -n 10 --no-pager
                } -Title "Logs Kernel" 
            }

            '5' {
                Invoke-RemoteCmd -Command {
                    Write-Host "--- CRITIQUE (Derniers 5) ---" -ForegroundColor Yellow
                    journalctl -p 0..3 -n 5 --no-pager
                    
                    Write-Host "`n--- AUTH FAILURES (Derniers 5) ---" -ForegroundColor Yellow
                    grep -i "Failed password" /var/log/auth.log | tail -n 5

                    Write-Host "`n--- KERNEL (Derniers 5) ---" -ForegroundColor Yellow
                    journalctl -k -n 5 --no-pager

                    Write-Host "`n--- SYSTEME (Derniers 5) ---" -ForegroundColor Yellow
                    journalctl -n 5 --no-pager
                } -Title "Full Logs"
            }

            '6' { return }
            Default { Write-Host "Choix invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    } until ($choix -eq '6')
}

# ==============================================================================
# 3. Boucle Principale
# ==============================================================================
do {
    Clear-Host
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host "   PRISE D'INFO LINUX VIA SSH (Win->Lin) "
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host "1. Information réseau"
    Write-Host "2. Informations sys et matériel"
    Write-Host "3. Recherche logs (Journalctl)"
    Write-Host "4. Quitter"
    Write-Host ""
    $main_choice = Read-Host "Votre choix"

    switch ($main_choice) {
        '1' { Show-MenuReseau }
        '2' { Show-MenuSys }
        '3' { Show-MenuLogs }
        '4' { Write-Host "Au revoir !"; Cleanup-Session; exit }
        Default { Write-Host "Option invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} until ($main_choice -eq '4')