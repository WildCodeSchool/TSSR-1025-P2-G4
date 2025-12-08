#!/bin/bash

# ==============================================================================
# 0. CONFIGURATION & LOGGING
# ==============================================================================

# --- A. Configuration du Fichier de LOG ---
# Consigne : Le fichier doit être dans /var/log/log_evt.log
# Note : Écrire dans /var/log nécessite les droits ROOT (sudo).
if [ -w "/var/log" ]; then
    LOG_FILE="/var/log/log_evt.log"
else
    # Fallback : Si on n'est pas root, on écrit dans le dossier courant pour ne pas planter
    LOG_FILE="./log_evt.log"
fi

# --- B. Fonction de Journalisation (Logging) ---
# Format : <Date>_<Heure>_<Utilisateur>_<Evenement>
function write_log(){
    local EVENT=$1
    local DATE_STR=$(date +%Y%m%d)
    local TIME_STR=$(date +%H%M%S)
    local CURRENT_USER=$USER
    
    # Construction de la ligne de log
    local LOG_LINE="${DATE_STR}_${TIME_STR}_${CURRENT_USER}_${EVENT}"
    
    # Écriture dans le fichier
    echo "$LOG_LINE" >> "$LOG_FILE"
}

# --- C. Initialisation Connexion SSH ---

# Si les variables ne sont pas définies, on les demande
if [ -z "$REMOTE_IP" ]; then
    clear
    echo "======================================="
    echo "      CONFIGURATION DE LA CIBLE        "
    echo "======================================="
    read -p "Adresse IP de la cible : " REMOTE_IP
    read -p "Utilisateur distant (ex: wilder) : " REMOTE_USER
fi

SSH_SOCKET="/tmp/ssh_mux_${REMOTE_IP}_${REMOTE_USER}"

# --- D. Nettoyage et Fin de Script ---
function cleanup {
    echo ""
    echo ">>> Fermeture de la connexion maître..."
    ssh -S "$SSH_SOCKET" -O exit "$REMOTE_USER@$REMOTE_IP" 2>/dev/null
    
    # JOURNALISATION : Fin du script
    write_log "EndScript"
}
trap cleanup EXIT

# --- E. Lancement Connexion Maître ---
echo ""
echo ">>> Établissement de la connexion sécurisée..."
echo ">>> Veuillez entrer votre mot de passe SSH (une seule fois) :"

rm -f "$SSH_SOCKET"
ssh -M -S "$SSH_SOCKET" -fN "$REMOTE_USER@$REMOTE_IP"

if [ $? -ne 0 ]; then
    echo "!!! Erreur : Impossible de se connecter."
    exit 1
fi

# JOURNALISATION : Démarrage du script réussi
write_log "StartScript"

echo ">>> Connexion établie avec succès !"
if [ "$LOG_FILE" == "./log_evt.log" ]; then
    echo ">>> NOTE : Logs enregistrés localement (pas de droits root pour /var/log)."
fi
sleep 1

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
            write_log "Reseau_Consult_DNS"
            ssh_exec "cat /etc/resolv.conf" 
            ;;
        2) 
            write_log "Reseau_Consult_Interfaces"
            ssh_exec "ip -br a" 
            ;; 
        3) 
            write_log "Reseau_Consult_ARP"
            ssh_exec "ip neigh show" 
            ;; 
        4) 
            write_log "Reseau_Consult_Routes"
            ssh_exec "ip route show" 
            ;;
        5) 
            write_log "Reseau_Consult_ALL"
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
            write_log "Sys_Consult_Bios"
            ssh_exec "cat /sys/class/dmi/id/bios_version" 
            ;; 
        2) 
            write_log "Sys_Consult_IP"
            ssh_exec "ip -o -f inet addr show | awk '/scope global/ {print \$2, \$4}'" 
            ;;
        3) 
            write_log "Sys_Consult_OS_Version"
            ssh_exec "cat /etc/os-release | grep PRETTY_NAME" 
            ;;
        4) 
            write_log "Sys_Consult_GPU"
            ssh_exec "lspci | grep -i 'vga\|3d\|display'" 
            ;;
        5) 
            write_log "Sys_Consult_Uptime"
            ssh_exec "uptime -p" 
            ;;
        6) 
            write_log "Sys_Consult_ALL"
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
            write_log "Logs_Consult_Critiques"
            ssh_exec "journalctl -p 0..3 -n 10 --no-pager" 
            ;; 
        2) 
            write_log "Logs_Consult_Auth"
            ssh_exec "tail -n 20 /var/log/auth.log 2>/dev/null || journalctl _COMM=sshd -n 20" 
            ;;
        3) 
            write_log "Logs_Consult_Syslog"
            ssh_exec "tail -n 20 /var/log/syslog 2>/dev/null || journalctl -n 20" 
            ;;
        4) 
            write_log "Logs_Consult_EvtFiles"
            ssh_exec "find /var/log -name '*.evt' -o -name '*.log' | head -n 10" 
            ;; 
        5) 
            write_log "Logs_Consult_ALL"
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
    write_log "Generation_Rapport_Audit" # Log de l'action
    
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
while true; do
    clear
    echo  "======================================="
    echo  "   PRISE D'INFO SUR LES MACHINES       "
    echo  "======================================="
    echo "1. Information réseau"
    echo "2. Informations sys et matériel"
    echo "3. Recherche d'événement logs"
    echo "4. Enregistrement - Les informations"
    echo "5. Quitter"
    echo ""
    echo -n "Votre choix : "
    read main_choice

    case $main_choice in
        1) menu_reseau ;;
        2) menu_sys ;;
        3) menu_logs ;;
        4) menu_save ;;
        5) echo "Au revoir !"; exit 0 ;;
        *) echo "Option invalide." ;;
    esac
done
