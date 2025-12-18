
param (
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.Runspaces.PSSession]$Session
)

$script:RemoteSession = $Session

# ==============================================================================
# 1. Fonction Utilitaire d'Exécution
# ==============================================================================

function Invoke-RemoteCmd {
    param (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Command,
        [string]$Title = "Exécution"
    )

    $TargetName = $script:RemoteSession.ComputerName

    Write-Host ">>> $Title sur $TargetName..." -ForegroundColor Cyan
    try {
        Invoke-Command -Session $script:RemoteSession -ScriptBlock $Command
    }
    catch {
        Write-Host "Erreur lors de l'exécution : $_" -ForegroundColor Red
    }
    
    Write-Host "`n>>> Fin de la commande." -ForegroundColor DarkGray
    Read-Host "Appuyez sur Entrée pour continuer..."
}

# ==============================================================================
# 2. Fonctions des Sous-Menus
# ==============================================================================

# --- A. Information Réseau ---
function Show-MenuReseau {
    do {
        Clear-Host
        Write-Host "==== Information réseau (Windows) ====" -ForegroundColor Cyan
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
                } -Title "Full Info Réseau"
            }
            '6' { return }
            Default { Write-Host "Choix invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    } until ($choix -eq '6')
}

# --- B. Information Sys et Matériel ---
function Show-MenuSys {
    do {
        Clear-Host
        Write-Host "==== Information Système et matériel (Windows) ====" -ForegroundColor Cyan
        Write-Host "1. BIOS/UEFI"
        Write-Host "2. Adresse IP, masque"
        Write-Host "3. Version de l'OS"
        Write-Host "4. Carte graphique"
        Write-Host "5. Uptime"
        Write-Host "6. Toutes les informations"
        Write-Host "7. Retour au Menu principal"
        $choix = Read-Host "Votre choix"

        switch ($choix) {
            '1' { 
                Invoke-RemoteCmd -Command { 
                    Get-CimInstance Win32_BIOS | Select-Object Manufacturer, SMBIOSBIOSVersion, SerialNumber | Format-List | Out-String 
                } -Title "BIOS" 
            }
            '2' { 
                Invoke-RemoteCmd -Command { 
                    Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" } | Select-Object InterfaceAlias, IPAddress, PrefixLength | Format-Table -AutoSize | Out-String 
                } -Title "IP Configuration" 
            }
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

# --- C. Evènements Logs ---
function Show-MenuLogs {
    do {
        Clear-Host
        Write-Host "==== Information logs (Windows) ====" -ForegroundColor Cyan
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
                    else { Write-Warning "Aucune erreur critique trouvée." }
                } -Title "Erreurs Critiques (System)" 
            }

            '2' { 
                Invoke-RemoteCmd -Command { 
                    Get-WinEvent -FilterHashtable @{LogName = 'Security'; Keywords = 'Audit Failure' } -MaxEvents 10 -ErrorAction SilentlyContinue | 
                    Select-Object TimeCreated, Id, Message | Format-Table -AutoSize -Wrap | Out-String 
                } -Title "Echecs Auth (Security)" 
            }

            '3' { 
                Invoke-RemoteCmd -Command { 
                    Get-WinEvent -LogName System -MaxEvents 20 -ErrorAction SilentlyContinue | 
                    Select-Object TimeCreated, LevelDisplayName, Message | Format-Table -AutoSize -Wrap | Out-String 
                } -Title "Logs Système (Récents)" 
            }

            '4' { 
                Invoke-RemoteCmd -Command { 
                    Get-WinEvent -LogName Application -MaxEvents 10 -ErrorAction SilentlyContinue | 
                    Select-Object TimeCreated, LevelDisplayName, Message | Format-Table -AutoSize -Wrap | Out-String 
                } -Title "Logs Application (Récents)" 
            }

            '5' {
                Invoke-RemoteCmd -Command {
                    Write-Host "--- CRITIQUE (System - Max 5) ---" -ForegroundColor Yellow
                    $crit = Get-WinEvent -FilterHashtable @{LogName = 'System'; Level = 1, 2 } -MaxEvents 5 -ErrorAction SilentlyContinue
                    if ($crit) { $crit | Format-Table TimeCreated, Message -AutoSize -Wrap | Out-String } else { "R.A.S.`n" }
                    
                    Write-Host "--- SECURITE (Echecs - Max 5) ---" -ForegroundColor Yellow
                    $sec = Get-WinEvent -FilterHashtable @{LogName = 'Security'; Keywords = 'Audit Failure' } -MaxEvents 5 -ErrorAction SilentlyContinue
                    if ($sec) { $sec | Format-Table TimeCreated, Message -AutoSize -Wrap | Out-String } else { "R.A.S.`n" }

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
# 3. Boucle Principale du Module
# ==============================================================================
do {
    Clear-Host
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host "   PRISE D'INFO WINDOWS (SESSION ACTIVE) "
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host "1. Information réseau"
    Write-Host "2. Informations sys et matériel"
    Write-Host "3. Recherche d'événement logs"
    Write-Host "4. Retour au script parent"
    Write-Host ""
    $main_choice = Read-Host "Votre choix"

    switch ($main_choice) {
        '1' { Show-MenuReseau }
        '2' { Show-MenuSys }
        '3' { Show-MenuLogs }
        '4' { Write-Host "Retour au menu principal..."; return }
        Default { Write-Host "Option invalide." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} until ($main_choice -eq '4')