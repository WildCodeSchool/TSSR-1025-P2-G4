# TSSR-1025-P2-G4

## Sommaire
- [👥 Membres de l'équipe :](#-membres-de-léquipe-)
- [💻 Matériel :](#-matériel-)
- [🎯 Présentation du projet :](#-présentation-du-projet-)
	- [🥇 Tâche principale :](#-tâche-principale-)
	- [🥈 Tâches secondaire :](#-tâches-secondaire-)

## 👥 Membres de l'équipe :
<span id=equipe></span>

| Prenom  | S1   | S2   | S3   | S4  |
| ------- | ---- | ---  | ---- | --- |
| Renaud  | SM   | Tech | PO   |     |
| Georges | PO   | Tech | SM   |     |
| Sami    | Tech | PO   | Tech |     |
| Romain  | Tech | SM   | Tech |     |

## 💻 Matériel :
<span id=materiel></span>

* Sur Proxmox :
	* Client  **Windows-10-Pro** (CLIWIN01)
	* Client  **Ubuntu-24.04-LTS** (CLILIN01)
	* Serveur  **Windows-2022** (SRVWIN01)
	* Serveur **Debian-12.9** (SRVLX01)

## 🎯 Présentation du projet :
<span id=projet></span>

### 🥇 Tâche principale :
<span id=principale></span>

* Communiquer depuis un serveur **Debian** ou un serveur **Windows**, sur des machines clients Linux et Windows.

* Nous devons Développer **2 scripts fonctionnels** :
	- Script **Bash** → s’exécute sur **Debian**
    - Script **PowerShell** → s’exécute sur **Windows Server**

* Les 2 scripts doivent pouvoir, à distance :
	- Gérer des utilisateurs (création, suppression, changement MDP, etc.)
    - Administrer les postes clients (redémarrage, arrêt, etc.)
    - Récupérer des informations système/utilisateur
    - Enregistrer les infos dans des fichiers
	* Journaliser toutes les actions

* Les scripts doivent avoir :
	- Un **menu ergonomique** avec sous-menus
	- Possibilité de cibler un utilisateur ou une machine (nom ou IP)
	- Retour arrière et sortie propre

### 🥈 Tâches secondaire :
<span id=secondaire></span>

* Déploiement automatique de toutes les dépendances/configurations (WinRM, SSH, paquets, etc.) par script  
* Version GUI des 2 scripts
