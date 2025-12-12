#!/bin/bash

# ==============================================================================
# 0. CONFIGURATION & LOGGING
# ==============================================================================

# Ajout d'une fonction log pour créer un suivis des utilistations du script

function Log() {

    local evenement="$1"
    local fichier_log="/var/log/log_evt.log"
    local date_actuelle=$(date +"%Y%m%d")
    local heure_actuelle=$(date +"%H%M%S")
    local utilisateur=$(whoami)

    # Format demandé <Date>_<Heure>_<Utilisateur>_<Evenement>
    local ligne_log="${date_actuelle}_${heure_actuelle}_${utilisateur}_${evenement}"

    # Ecriture dans le fichier
    echo "$ligne_log" | sudo tee -a "$fichier_log" > /dev/null 2>&1

}

# --- C. Initialisation des Variables ---

# 1. Récupération des variables du parent (menu_linux.sh)
if [ -n "$IpMachine" ]; then
    REMOTE_IP="$IpMachine"
fi
# Idem pour l'utilisateur
if [ -n "$NomMachine" ]; then
    REMOTE_USER="$NomMachine"
fi

# 2. Si les variables sont toujours vides (ex: lancement manuel du script), on demande.
if [ -z "$REMOTE_IP" ] || [ -z "$REMOTE_USER" ]; then
    clear
    echo "======================================="
    echo "      CONFIGURATION DE LA CIBLE        "
    echo "======================================="
    # Si l'une manque, on demande tout pour être sûr
    [ -z "$REMOTE_IP" ] && read -p "Adresse IP de la cible : " REMOTE_IP
    [ -z "$REMOTE_USER" ] && read -p "Utilisateur distant (ex: wilder) : " REMOTE_USER
fi

# Définition du chemin du Socket (le fichier qui maintient la connexion ouverte)
SSH_SOCKET="/tmp/ssh_mux_${REMOTE_IP}_${REMOTE_USER}"

# --- D. Nettoyage et Fin de Script ---
function cleanup {
    if [ "$CONNEXION_CREEE_ICI" == "oui" ]; then
        echo ""
        echo ">>> Fermeture de la connexion maître..."
        ssh -S "$SSH_SOCKET" -O exit "$REMOTE_USER@$REMOTE_IP" 2>/dev/null
    else
        echo ""
        echo ">>> Retour au menu principal (connexion maintenue)..."
    fi
    
    # JOURNALISATION : Fin du script
    Log "EndScript"
}

# N'active le nettoyage automatique que si ce script est le script principal
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    trap cleanup EXIT
fi


# --- E. Gestion de la Connexion SSH ---

# On vérifie si une connexion est DÉJÀ active (créée par menu_linux.sh)
if [ -S "$SSH_SOCKET" ]; then
    ssh -S "$SSH_SOCKET" -O check "$REMOTE_USER@$REMOTE_IP" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo ">>> Connexion existante détectée. Utilisation du canal sécurisé..."
        CONNEXION_HERITEE="oui"
    else
        echo ">>> Socket obsolète détecté. Nettoyage..."
        rm -f "$SSH_SOCKET"
    fi
fi

# Si pas de connexion héritée, on l'ouvre 
if [ "$CONNEXION_HERITEE" != "oui" ]; then
    echo ""
    echo ">>> Établissement de la connexion sécurisée..."
    echo ">>> (Si vous n'avez pas de clé SSH, entrez le mot de passe)"
    
    ssh -M -S "$SSH_SOCKET" -fN "$REMOTE_USER@$REMOTE_IP"
    
    if [ $? -ne 0 ]; then
        echo "!!! Erreur : Impossible de se connecter."
        exit 1
    fi
    # On marque qu'on a ouvert la connexion nous-mêmes 
    CONNEXION_CREEE_ICI="oui"
fi

# JOURNALISATION : Démarrage du script réussi
Log "StartScript"

# ==============================================================================
# 1. Fonction d'Exécution SSH
# ==============================================================================

function ssh_exec(){
    echo ">>> Exécution sur $REMOTE_IP..."
    ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "$1"
    echo ">>> Fin de la commande.."
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
}

# ==============================================================================
# 2. Fonctions des Sous-Menus
# ==============================================================================

# ---A. Information Réseau
function menu_reseau(){
    while true;do
    clear
    echo    ======================
    echo "====Information réseau===="
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
            ssh_exec "resolvectl status" 
            ;;
        2) 
            Log "ReseauConsultInterfaces"
            ssh_exec "ip -br a" 
            ;; 
        3) 
            Log "ReseauConsultARP"
            ssh_exec "ip neigh show" 
            ;; 
        4) 
            Log "ReseauConsultRoutes"
            ssh_exec "ip route show" 
            ;;
        5) 
            Log "ReseauConsultALL"
            ssh_exec "echo '--- DNS ---'; cat /etc/resolv.conf; 
                    echo '--- Interfaces ---'; ip -br a; 
                    echo '--- ARP ---'; ip neigh show; 
                    echo '--- Routage ---'; ip route show" 
            ;;
        6) break ;;
        *) echo "choix invalide." ;;
        esac
    done
}

# ---B. Information sys et matériel
function menu_sys(){
    while true;do
    clear
    echo    ===================================
    echo "====Information Système et matériel===="
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
            ssh_exec "cat /sys/class/dmi/id/bios_version" 
            ;; 
        2) 
            Log "SysConsultIP"
            ssh_exec "ip -o -f inet addr show | awk '/scope global/ {print \$2, \$4}'" 
            ;;
        3) 
            Log "SysConsultOSVersion"
            ssh_exec "cat /etc/os-release | grep PRETTY_NAME" 
            ;;
        4) 
            Log "SysConsultGPU"
            ssh_exec "lspci | grep -i 'vga\|3d\|display'" 
            ;;
        5) 
            Log "SysConsultUptime"
            ssh_exec "uptime -p" 
            ;;
        6) 
            Log "SysConsultALL"
            ssh_exec "echo '--- BIOS ---'; cat /sys/class/dmi/id/bios_version;
                    echo '--- IP ---'; ip -o -f inet addr show;
                    echo '--- OS ---'; cat /etc/os-release | grep PRETTY_NAME;
                    echo '--- GPU ---'; lspci | grep -i 'vga\|3d\|display';
                    echo '--- Uptime ---'; uptime -p" 
            ;;
        7) break ;;
        *) echo "Choix invalide." ;;
        esac
    done
}

# ---C. Evenements log
function menu_logs(){
        while true;do
        clear
        echo   ================================
        echo "====Information evenement logs===="
        echo   ================================
        echo "1. 10 derniers events critiques"
        echo "2. Evenements log-evt.log utilisateur"
        echo "3. Evenements log-evt.log ordinateur"
        echo "4. Evenements .evt"
        echo "5. Toutes les informations"
        echo "6. Retour au Menu principal"
        echo -n "Votre choix : "
        read choix

        case $choix in
        1) 
            Log "LogsConsultCritiques"
            ssh_exec "journalctl -p 0..3 -n 10 --no-pager" 
            ;; 
        2) 
            Log "LogsConsultAuth"
            ssh_exec "tail -n 20 /var/log/auth.log 2>/dev/null || journalctl _COMM=sshd -n 20" 
            ;;
        3) 
            Log "LogsConsultSyslog"
            ssh_exec "tail -n 20 /var/log/syslog 2>/dev/null || journalctl -n 20" 
            ;;
        4) 
            Log "LogsConsultEvtFiles"
            ssh_exec "find /var/log -name '*.evt' -o -name '*.log' | head -n 10" 
            ;; 
        5) 
            Log "LogsConsultALL"
            ssh_exec "echo '--- CRITIQUE ---'; journalctl -p 0..3 -n 5 --no-pager;
                     echo '--- AUTH ---'; tail -n 5 /var/log/auth.log 2>/dev/null;
                     echo '--- SYSLOG ---'; tail -n 5 /var/log/syslog 2>/dev/null" 
            ;;
        6) break ;;
        *) echo "Choix invalide." ;;
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

    echo ">>> Récupération du nom de la machine cible..."
    REMOTE_HOSTNAME=$(ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "hostname")
    
    if [ -z "$REMOTE_HOSTNAME" ]; then
        CIBLE="Inconnue_$REMOTE_IP"
    else
        CIBLE=$(echo "$REMOTE_HOSTNAME" | xargs)
    fi

    DATE_FORMAT=$(date +%Y%m%d)
    FICHIER="./info/info_${CIBLE}_${DATE_FORMAT}.txt"

    echo ">>> Génération du rapport dans : $FICHIER"
    
    {
        echo "================================================================"
        echo " RAPPORT D'AUDIT : $CIBLE"
        echo " Date : $(date)"
        echo " IP Cible : $REMOTE_IP"
        echo " Utilisateur : $REMOTE_USER"
        echo "================================================================"
        echo ""
        echo "[OS Version]"
        ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "cat /etc/os-release | grep PRETTY_NAME"
        echo ""
        echo "[IP Info]"
        ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "ip -br a"
        echo ""
        echo "[Events Critiques]"
        ssh -S "$SSH_SOCKET" "$REMOTE_USER@$REMOTE_IP" "journalctl -p 0..3 -n 5 --no-pager"
    } > "$FICHIER"

    echo ">>> Succès."
    echo ""
    read -p "Appuyez sur Entrée pour revenir au menu..."
}

# ==============================================================================
# 3. Boucle Principale 
# ==============================================================================

# Début du log

Log "StartScript"

while true; do
    clear
    echo  "======================================="
    echo  "   PRISE D'INFO SUR LES MACHINES       "
    echo  "======================================="
    echo "1. Information réseau"
    echo "2. Informations sys et matériel"
    echo "3. Recherche d'événement logs"
    echo "4. Enregistrement - Les informations"
    echo "5. Retour menu général"  
    echo "6. Quitter"             
    echo ""
    echo -n "Votre choix : "
    read main_choice

    case $main_choice in
        1) menu_reseau ;;
        2) menu_sys ;;
        3) menu_logs ;;
        4) menu_save ;;
        5) echo "Retour au menu principal..."
            exit 0 
            ;;
        6) echo "Au revoir !"
            exit 0 
            ;;
        *) echo "Option invalide." ;;
    esac
done
