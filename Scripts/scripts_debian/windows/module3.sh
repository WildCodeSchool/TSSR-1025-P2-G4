#!/bin/bash

# ==============================================================================
# 0. CONFIGURATION & LOGGING
# ==============================================================================

# Fonction de log (reste locale sur le Debian)
function Log() {

    local evenement="$1"
    local fichier_log="/var/log/log_evt.log"
    local date_actuelle=$(date +"%Y%m%d")
    local heure_actuelle=$(date +"%H%M%S")
    local utilisateur=$(whoami)

    # Format demandé <Date>_<Heure>_<Utilisateur>_<Evenement>
    local ligne_log="${date_actuelle}"_${heure_actuelle}_${utilisateur}_${evenement}

    # Ecriture dans le fichier
    echo "$ligne_log" | sudo tee -a "$fichier_log" > /dev/null 2>&1
}

# --- C. Initialisation des Variables ---

# 1. Récupération des variables du parent
if [ -n "$IpMachine" ]; then
    REMOTE_IP="$IpMachine"
fi
if [ -n "$NomMachine" ]; then
    REMOTE_USER="$NomMachine"
fi

# 2. Si les variables sont vides
if [ -z "$REMOTE_IP" ] || [ -z "$REMOTE_USER" ]; then
    clear
    echo "======================================="
    echo "   CONFIGURATION CIBLE (WINDOWS 10)    "
    echo "======================================="
    [ -z "$REMOTE_IP" ] && read -p "Adresse IP Windows : " REMOTE_IP
    [ -z "$REMOTE_USER" ] && read -p "Utilisateur Windows : " REMOTE_USER
fi

# Chemin du Socket SSH
SSH_SOCKET="/tmp/ssh_mux_win_${REMOTE_IP}_${REMOTE_USER}"

# --- D. Nettoyage et Fin de Script ---
function cleanup {
    if [ "$CONNEXION_CREEE_ICI" == "oui" ]; then
        echo ""
        echo ">>> Fermeture de la connexion maître..."
        ssh -S "$SSH_SOCKET" -O exit "$REMOTE_USER@$REMOTE_IP" 2>/dev/null
    else
        echo ""
        echo ">>> Retour au menu principal..."
    fi
    Log "EndScript"
}
trap cleanup EXIT

# --- E. Gestion de la Connexion SSH ---

if [ -S "$SSH_SOCKET" ]; then
    ssh -S "$SSH_SOCKET" -O check "$REMOTE_USER@$REMOTE_IP" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo ">>> Connexion existante détectée..."
        CONNEXION_HERITEE="oui"
    else
        echo ">>> Socket obsolète. Nettoyage..."
        rm -f "$SSH_SOCKET"
    fi
fi

if [ "$CONNEXION_HERITEE" != "oui" ]; then
    echo ""
    echo ">>> Connexion SSH vers Windows ($REMOTE_IP)..."
    echo ">>> Note : Si le shell par défaut de Windows n'est pas Bash, c'est normal."
    
    # On force la connexion
    ssh -M -S "$SSH_SOCKET" -fN "$REMOTE_USER@$REMOTE_IP"
    
    if [ $? -ne 0 ]; then
        echo "!!! Erreur : Impossible de se connecter au Windows."
        echo "Vérifiez que le service OpenSSH Server est lancé sur le Windows."
        exit 1
    fi
    CONNEXION_CREEE_ICI="oui"
fi

Log "StartScript"

# ==============================================================================
# 1. Fonction d'Exécution SSH (Adaptée Windows)
# ==============================================================================

function ssh_exec(){
    echo ">>> Exécution sur Windows ($REMOTE_IP)..."
    ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "$1"
    echo ">>> Fin de la commande.."
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
}

# ==============================================================================
# 2. Fonctions des Sous-Menus (Adaptés Commandes Windows)
# ==============================================================================

# ---A. Information Réseau
function menu_reseau(){
    while true;do
    clear
    echo    ======================
    echo "====Information réseau (Win10)===="
    echo    ======================
    echo "1. DNS actuels"
    echo "2. Listing interfaces"
    echo "3. Table ARP"
    echo "4. Table de routage"
    echo "5. Toutes les informations"
    echo "6. Retour menu principal"
    echo -n "Votre choix : "
    read choix

        case $choix in
        1) 
            Log "ReseauConsultDNS"
            ssh_exec "powershell -Command \"Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, ServerAddresses | Format-Table -AutoSize\"" 
            ;;
        2) 
            Log "ReseauConsultInterfaces"
            ssh_exec "ipconfig /all" 
            ;; 
        3) 
            Log "ReseauConsultARP"
            ssh_exec "arp -a" 
            ;; 
        4) 
            Log "ReseauConsultRoutes"
            ssh_exec "route print" 
            ;;
        5) 
            Log "ReseauConsultALL"
            ssh_exec "echo --- DNS --- && powershell -Command \"Get-DnsClientServerAddress -AddressFamily IPv4\" && echo. && echo --- IPCONFIG --- && ipconfig /all && echo. && echo --- ARP --- && arp -a && echo. && echo --- ROUTE --- && route print" 
            ;;
        6) break 
            ;;
        *) echo "choix invalide." 
            ;;
        esac
    done
}

# ---B. Information sys et matériel
function menu_sys(){
    while true;do
    clear
    echo    ===================================
    echo "====Info Système et matériel (Win10)===="
    echo    ===================================
    echo "1. BIOS/UEFI"
    echo "2. Adresse IP, masque"
    echo "3. Version de l'OS"
    echo "4. Carte graphique"
    echo "5. Uptime"
    echo "6. Toutes les informations"
    echo "7. Retour au Menu principal"
    echo -n "Votre choix : "
    read choix

        case $choix in
        1) 
            Log "SysConsultBios"
            ssh_exec "powershell -Command \"Get-CimInstance Win32_BIOS | Select-Object Manufacturer, Name, SerialNumber, Version | Format-List\"" 
            ;; 
        2) 
            Log "SysConsultIP"
            ssh_exec "ipconfig | findstr \"IPv4 Masque\"" 
            ;;
        3) 
            Log "SysConsultOSVersion"
            ssh_exec "systeminfo | findstr /B /C:\"Nom du syst\" /C:\"Version du syst\" /C:\"OS Name\" /C:\"OS Version\"" 
            ;;
        4) 
            Log "SysConsultGPU"
            ssh_exec "powershell -Command \"Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion | Format-Table\"" 
            ;;
        5) 
            Log "SysConsultUptime"
            ssh_exec "powershell -Command \"(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | Select-Object Days, Hours, Minutes\"" 
            ;;
        6) 
            Log "SysConsultALL"
            ssh_exec "echo --- BIOS --- && wmic bios get name, serialnumber && echo. && echo --- OS --- && systeminfo | findstr /B /C:\"OS Name\" /C:\"OS Version\" && echo. && echo --- GPU --- && wmic path win32_videocontroller get name && echo. && echo --- IP --- && ipconfig" 
            ;;
        7) break 
            ;;
        *) echo "Choix invalide." 
            ;;
        esac
    done
}

# ---C. Evenements log (Event Viewer Windows)
function menu_logs(){
        while true;do
        clear
        echo   ================================
        echo "====Information Logs (Win10)===="
        echo   ================================
        echo "1. 10 dernières erreurs Système"
        echo "2. Logs Sécurité (Auth)"
        echo "3. Logs Application"
        echo "4. Toutes les informations"
        echo "5. Retour au Menu principal"
        echo -n "Votre choix : "
        read choix

        case $choix in
        1) 
            Log "LogsConsultCritiques"
            ssh_exec "powershell -Command \"Get-EventLog -LogName System -EntryType Error,Warning -Newest 10 | Format-Table TimeGenerated, Source, Message -AutoSize -Wrap\"" 
            ;; 
        2) 
            Log "LogsConsultAuth"
            ssh_exec "powershell -Command \"Get-EventLog -LogName Security -Newest 10 | Format-Table TimeGenerated, EventID, Message -AutoSize\"" 
            ;;
        3) 
            Log "LogsConsultApp"
            ssh_exec "powershell -Command \"Get-EventLog -LogName Application -Newest 10 | Format-Table TimeGenerated, Source, Message -AutoSize\"" 
            ;;
        4) 
            Log "LogsConsultALL"
            ssh_exec "powershell -Command \"Write-Host '--- ERREURS SYS ---'; Get-EventLog -LogName System -EntryType Error -Newest 5; Write-Host '--- SECURITE ---'; Get-EventLog -LogName Security -Newest 5\"" 
            ;;
        5) break 
        ;;
        *) echo "Choix invalide." 
        ;;
        esac
    done 
}

# ---D. Enregistrement
function menu_save(){
    clear
    Log "GenerationRapportAudit"
    
    echo "======================================="
    echo "   ENREGISTREMENT DES INFORMATIONS     "
    echo "======================================="
    
    if [ ! -d "./info" ]; then
        mkdir -p "./info"
    fi

    echo ">>> Récupération du hostname Windows..."
    REMOTE_HOSTNAME=$(ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "hostname")
    
    REMOTE_HOSTNAME=$(echo "$REMOTE_HOSTNAME" | tr -d '\r' | xargs)

    if [ -z "$REMOTE_HOSTNAME" ]; then
        CIBLE="Win10_$REMOTE_IP"
    else
        CIBLE="$REMOTE_HOSTNAME"
    fi

    DATE_FORMAT=$(date +%Y%m%d)
    FICHIER="./info/info_${CIBLE}_${DATE_FORMAT}.txt"

    echo ">>> Génération du rapport dans : $FICHIER"
    
    {
        echo "================================================================"
        echo " RAPPORT D'AUDIT WINDOWS : $CIBLE"
        echo " Date : $(date)"
        echo " IP Cible : $REMOTE_IP"
        echo " Utilisateur : $REMOTE_USER"
        echo "================================================================"
        echo ""
        echo "[OS Info]"
        ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "systeminfo | findstr /B /C:\"OS\""
        echo ""
        echo "[IP Config]"
        ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "ipconfig /all"
        echo ""
        echo "[Dernières Erreurs Système]"
        ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "powershell -Command \"Get-EventLog -LogName System -EntryType Error -Newest 5 | Format-List\""
    } > "$FICHIER"

    echo ">>> Succès."
    echo ""
    read -p "Appuyez sur Entrée pour revenir au menu..."
}

# ==============================================================================
# 3. Boucle Principale 
# ==============================================================================

Log "StartScript"

while true; do
    clear
    echo  "======================================="
    echo  "   AUDIT WINDOWS DEPUIS DEBIAN         "
    echo  "======================================="
    echo "1. Information réseau"
    echo "2. Informations sys et matériel"
    echo "3. Recherche logs (Event Viewer)"
    echo "4. Enregistrement - Les informations"
    echo "5. Retour menu général"  
    echo "6. Quitter"             
    echo ""
    echo -n "Votre choix : "
    read main_choice

    case $main_choice in
        1) menu_reseau 
        ;;
        2) menu_sys 
        ;;
        3) menu_logs 
        ;;
        4) menu_save 
        ;;
        5) echo "Retour au menu principal..."
            exit 0 
        ;;
        6) echo "Au revoir !"
            exit 0 
        ;;
        *) echo "Option invalide." 
        ;;
    esac
done
