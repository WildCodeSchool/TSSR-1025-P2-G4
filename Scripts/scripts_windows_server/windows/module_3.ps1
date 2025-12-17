

# ==============================================================================
# 0. Gestion du Nettoyage (Equivalent du trap cleanup)
# ==============================================================================
$Global:RemoteSession = $null

function Cleanup-Session {
    if ($Global:RemoteSession) {
        Write-Host "`n>>> Fermeture de la connexion distante..." -ForegroundColor Yellow
        Remove-PSSession $Global:RemoteSession
        $Global:RemoteSession = $null
    }
}

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
    if ($Global:RemoteSession) { Remove-PSSession $Global:RemoteSession }
}

# ==============================================================================
# 1. Configuration de la connexion
# ==============================================================================
Clear-Host
Write-Host "=== CONFIGURATION DE LA CONNEXION DISTANTE (WinRM) ===" -ForegroundColor Cyan

$TargetIP = Read-Host "Entrez l'adresse IP ou le nom de la machine cible"
Write-Host "Veuillez entrer les identifiants administrateur de la cible :" -ForegroundColor Gray
$Creds = Get-Credential

Write-Host "`n>>> Ã‰tablissement de la connexion persistante..." -ForegroundColor Yellow

try {
    $Global:RemoteSession = New-PSSession -ComputerName $TargetIP -Credential $Creds -ErrorAction Stop
    Write-Host ">>> Connexion Ã©tablie avec succÃ¨s !" -ForegroundColor Green
    Start-Sleep -Seconds 1
}
catch {
    Write-Host "ERREUR : Impossible de se connecter Ã  $TargetIP." -ForegroundColor Red
    Write-Host "VÃ©rifiez que :"
    Write-Host "1. WinRM est activÃ© sur la cible (Enable-PSRemoting)"
    Write-Host "2. L'utilisateur est administrateur"
    Write-Host "3. Le pare-feu autorise WinRM"
    exit
}

function Invoke-RemoteCmd {
    param (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Command,
        [string]$Title = "ExÃ©cution"
    )

    Write-Host ">>> $Title sur $TargetIP..." -ForegroundColor Cyan
    try {
        Invoke-Command -Session $Global:RemoteSession -ScriptBlock $Command
    }
    catch {
        Write-Host "Erreur lors de l'exÃ©cution : $_" -ForegroundColor Red
    }
    
    Write-Host "`n>>> Fin de la commande." -ForegroundColor DarkGray
    Read-Host "Appuyez sur EntrÃ©e pour continuer..."
}

# ==============================================================================
# 2. Fonctions des Sous-Menus
# ==============================================================================

# --- A. Information RÃ©seau ---
function Show-MenuReseau {
    do {
        Clear-Host
        Write-Host "==== Information rÃ©seau ====" -ForegroundColor Cyan
        Write-Host "1. DNS actuels"
        Write-Host "2. Listing interfaces"
        Write-Host "3. Table ARP (Voisins)"
        Write-Host "4. Table de routage"
        Write-Host "5. Toutes les informations"
        Write-Host "6. Retour menu principal"
        $choix = Read-Host "Votre choix"

        switch ($choix) {
            '1' { Invoke-RemoteCmd -Command { Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, ServerAddresses } -Title "DNS Actuels" }
            '2' { Invoke-RemoteCmd -Command { Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, MacAddress, LinkSpeed } -Title "Interfaces" }
            '3' { Invoke-RemoteCmd -Command { Get-NetNeighbor -AddressFamily IPv4 | Format-Table -AutoSize } -Title "Table ARP" }
            '4' { Invoke-RemoteCmd -Command { Get-NetRoute -AddressFamily IPv4 | Format-Table -AutoSize } -Title "Table de Routage" }
            '5' {
                Invoke-RemoteCmd -Command { 
                    Write-Host "--- DNS ---" -ForegroundColor Yellow
                    Get-DnsClientServerAddress -AddressFamily IPv4 | Out-String
                    Write-Host "`n--- Interfaces ---" -ForegroundColor Yellow
                    Get-NetIPConfiguration | Out-String
                    Write-Host "`n--- ARP ---" -ForegroundColor Yellow
                    Get-NetNeighbor -AddressFamily IPv4 | Format-Table -AutoSize | Out-String
                    Write-Host "`n--- Routage ---" -ForegroundColor Yellow
                    Get-NetRoute -AddressFamily IPv4 | Format-Table -AutoSize | Out-String
                } -Title "Full Info RÃ©seau"
            }
            '6' { return }
            Default { Write-Host "Choix invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    } until ($choix -eq '6')
}

# --- B. Information Sys et MatÃ©riel ---

function Show-MenuSys {
    do {
        Clear-Host
        Write-Host "==== Information Système et matériel ====" -ForegroundColor Cyan
        Write-Host "1. BIOS/UEFI"
        Write-Host "2. Adresse IP, masque"
        Write-Host "3. Version de l'OS"
        Write-Host "4. Carte graphique"
        Write-Host "5. Uptime"
        Write-Host "6. Toutes les informations"
        Write-Host "7. Retour au Menu principal"
        $choix = Read-Host "Votre choix"

        switch ($choix) {
            # Utilisation de Format-List | Out-String pour forcer l'affichage textuel propre
            '1' { 
                Invoke-RemoteCmd -Command { 
                    Get-CimInstance Win32_BIOS | Select-Object Manufacturer, SMBIOSBIOSVersion, SerialNumber | Format-List | Out-String 
                } -Title "BIOS" 
            }
            
            # Utilisation de Format-Table pour les adresses IP (plus lisible en tableau)
            '2' { 
                Invoke-RemoteCmd -Command { 
                    Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" } | Select-Object InterfaceAlias, IPAddress, PrefixLength | Format-Table -AutoSize | Out-String 
                } -Title "IP Configuration" 
            }
            
            # Concaténation explicite pour l'OS
            '3' { 
                Invoke-RemoteCmd -Command { 
                    $os = Get-CimInstance Win32_OperatingSystem
                    "Système : $($os.Caption)"
                    "Version : $($os.Version)"
                } -Title "Version OS" 
            }
            
            '4' { 
                Invoke-RemoteCmd -Command { 
                    Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion | Format-List | Out-String 
                } -Title "GPU" 
            }
            
            '5' { 
                Invoke-RemoteCmd -Command { 
                    $os = Get-CimInstance Win32_OperatingSystem
                    $uptime = (Get-Date) - $os.LastBootUpTime
                    "Uptime: $($uptime.Days) jours, $($uptime.Hours) heures, $($uptime.Minutes) minutes"
                } -Title "Uptime"
            }
            
            '6' {
                Invoke-RemoteCmd -Command {
                    Write-Host "--- BIOS ---" -ForegroundColor Yellow
                    Get-CimInstance Win32_BIOS | Select-Object Manufacturer, SMBIOSBIOSVersion | Format-List | Out-String

                    Write-Host "`n--- IP ---" -ForegroundColor Yellow
                    Get-NetIPAddress -AddressFamily IPv4 | Where-Object IPAddress -notlike "169.254*" | Select-Object InterfaceAlias, IPAddress | Format-Table -AutoSize | Out-String

                    Write-Host "`n--- OS ---" -ForegroundColor Yellow
                    (Get-CimInstance Win32_OperatingSystem).Caption | Out-String

                    Write-Host "`n--- GPU ---" -ForegroundColor Yellow
                    Get-CimInstance Win32_VideoController | Select-Object Name | Format-List | Out-String

                    Write-Host "`n--- Uptime ---" -ForegroundColor Yellow
                    $t = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
                    "$($t.Days)j $($t.Hours)h $($t.Minutes)m"
                } -Title "Full Info Système"
            }
            
            '7' { return }
            Default { Write-Host "Choix invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    } until ($choix -eq '7')
}
# --- C. EvÃ¨nements Logs ---
function Show-MenuLogs {
    do {
        Clear-Host
        Write-Host "==== Information évènement logs ====" -ForegroundColor Cyan
        Write-Host "1. 10 derniers events critiques/erreurs (System)"
        Write-Host "2. Événements Sécurité (Auth - Échecs)"
        Write-Host "3. Événements System récents"
        Write-Host "4. Événements Application récents"
        Write-Host "5. Toutes les informations"
        Write-Host "6. Retour au Menu principal"
        $choix = Read-Host "Votre choix"

        switch ($choix) {
            '1' { 
                Invoke-RemoteCmd -Command { 
     
                 $events = Get-WinEvent -FilterHashtable @{LogName = 'System'; Level = 1, 2 } -MaxEvents 10 -ErrorAction SilentlyContinue
        
      
                 if ($events) {
                    $events | Select-Object TimeCreated, Id, LevelDisplayName, Message | Format-Table -AutoSize -Wrap | Out-String
                 } 
        
                 else {
                    Write-Warning "Aucune erreur critique ou grave trouvée dans les 10 derniers logs System."
                     }
                 } -Title "Erreurs Critiques (System)" 
            }

            '2' { 
                Invoke-RemoteCmd -Command { 
                    Get-WinEvent -FilterHashtable @{LogName = 'Security'; Keywords = 'Audit Failure' } -MaxEvents 10 -ErrorAction SilentlyContinue | 
                    Select-Object TimeCreated, Id, Message | 
                    Format-Table -AutoSize -Wrap | Out-String 
                } -Title "Echecs Auth (Security)" 
            }

            '3' { 
                Invoke-RemoteCmd -Command { 
                    Get-WinEvent -LogName System -MaxEvents 20 -ErrorAction SilentlyContinue | 
                    Select-Object TimeCreated, LevelDisplayName, Message | 
                    Format-Table -AutoSize -Wrap | Out-String 
                } -Title "Logs Système (Récents)" 
            }

            '4' { 
                Invoke-RemoteCmd -Command { 
                    Get-WinEvent -LogName Application -MaxEvents 10 -ErrorAction SilentlyContinue | 
                    Select-Object TimeCreated, LevelDisplayName, Message | 
                    Format-Table -AutoSize -Wrap | Out-String 
                } -Title "Logs Application (Récents)" 
            }

            '5' {
                Invoke-RemoteCmd -Command {
                    Write-Host "--- CRITIQUE (System - Max 5) ---" -ForegroundColor Yellow
                    $crit = Get-WinEvent -FilterHashtable @{LogName = 'System'; Level = 1, 2 } -MaxEvents 5 -ErrorAction SilentlyContinue
                    if ($crit) { $crit | Format-Table TimeCreated, Message -AutoSize -Wrap | Out-String } else { "Aucune erreur critique récente.`n" }
                    
                    Write-Host "--- SECURITE (Echecs - Max 5) ---" -ForegroundColor Yellow
                    $sec = Get-WinEvent -FilterHashtable @{LogName = 'Security'; Keywords = 'Audit Failure' } -MaxEvents 5 -ErrorAction SilentlyContinue
                    if ($sec) { $sec | Format-Table TimeCreated, Message -AutoSize -Wrap | Out-String } else { "Aucun échec d'authentification récent.`n" }

                    Write-Host "--- SYSTEME (Derniers - Max 5) ---" -ForegroundColor Yellow
                    Get-WinEvent -LogName System -MaxEvents 5 -ErrorAction SilentlyContinue | Format-Table TimeCreated, LevelDisplayName, Message -AutoSize | Out-String
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
    Write-Host "   PRISE D'INFO SUR WINDOWS (WinRM)    "
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host "1. Information rÃ©seau"
    Write-Host "2. Informations sys et matÃ©riel"
    Write-Host "3. Recherche d'Ã©vÃ©nement logs"
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