#!/bin/bash


# ==============================================================================
# 1. Fonction SSH
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
    echo "1.DNS actuels"
    echo "2.listing interfaces"
    echo "3.Table ARP"
    echo "4.Table de routage"
    echo "5.Toutes les informations"
    echo "6.Retour menu principal"
    echo -n "Votre choix : "
    read choix

        case $choix in
        1) ssh_exec "cat /etc/resolv.conf" 
        ;;
        2) ssh_exec "ip -br a" 
        ;; 
        3) ssh_exec "ip neigh show" 
        ;; 
        4) ssh_exec "ip route show" 
        ;;
        5) ssh_exec "echo '--- DNS ---'; cat /etc/resolv.conf; 
                    echo '--- Interfaces ---'; ip -br a; 
                    echo '--- ARP ---'; ip neigh show; 
                    echo '--- Routage ---'; ip route show" 
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
    echo "====Information Système et matériel===="
    echo    ===================================
    echo "1.BIOS/UEFI"
    echo "2.Adresse IP, masque"
    echo "3.Version de l'OS"
    echo "4.Carte graphique"
    echo "5.Uptime"
    echo "6.Toutes les informations"
    echo "7.Retour au Menu principal"
    echo -n "Votre choix : "
    read choix

        case $choix in
        1) ssh_exec "cat /sys/class/dmi/id/bios_version" 
        ;; 
        2) ssh_exec "ip -o -f inet addr show | awk '/scope global/ {print \$2, \$4}'" 
        ;;
        3) ssh_exec "cat /etc/os-release | grep PRETTY_NAME" 
        ;;
        4) ssh_exec "lspci | grep -i 'vga\|3d\|display'" 
        ;;
        5) ssh_exec "uptime -p" 
        ;;
        6)ssh_exec "echo '--- BIOS ---'; cat /sys/class/dmi/id/bios_version;
                    echo '--- IP ---'; ip -o -f inet addr show;
                    echo '--- OS ---'; cat /etc/os-release | grep PRETTY_NAME;
                    echo '--- GPU ---'; lspci | grep -i 'vga\|3d\|display';
                    echo '--- Uptime ---'; uptime -p"
        ;;
        7) break 
        ;;
        *) echo "Choix invalide." 
        ;;
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
        echo "1.10 derniers events critiques"
        echo "2.Evenements log-evt.log utilisateur"
        echo "3.Evenements log-evt.log ordinateur"
        echo "4.Evenements .evt"
        echo "5.Toutes les informations"
        echo "6.Retour au Menu principal"
        echo -n "Votre choix : "
        read choix

        case $choix in
        1) ssh_exec "journalctl -p 0..3 -n 10 --no-pager" 
        ;; 
        2) ssh_exec "tail -n 20 /var/log/auth.log 2>/dev/null || journalctl _COMM=sshd -n 20" 
        ;;
        3) ssh_exec "tail -n 20 /var/log/syslog 2>/dev/null || journalctl -n 20" 
        ;;
        4) ssh_exec "find /var/log -name '*.evt' -o -name '*.log' | head -n 10" 
        ;; 
        5) ssh_exec "echo '--- CRITIQUE ---'; journalctl -p 0..3 -n 5 --no-pager;
                     echo '--- AUTH ---'; tail -n 5 /var/log/auth.log 2>/dev/null;
                     echo '--- SYSLOG ---'; tail -n 5 /var/log/syslog 2>/dev/null"
        ;;
        6) break 
        ;;
        *) echo "Choix invalide." 
        ;;
        esac
    done 
}

# ==============================================================================
# 3. Boucle Principale 
# ==============================================================================
while true; do
    clear
    clear
    echo  "======================================="
    echo  "   PRISE D'INFO SUR LES MACHINES       "
    echo  "======================================="
    echo "1. Information réseau"
    echo "2. Informations sys et matériel"
    echo "3. Recherche d'événement logs"
    echo "4. Quitter"
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
        4) echo "Au revoir !"; exit 0 
        ;;
        *) echo "Option invalide." 
        ;;
    esac
done







