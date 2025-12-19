#####################################################################################################################################################################
# Partie Gestion des Répertoires
#####################################################################################################################################################################


#Affichage de la machine distante et de son adresse IP
param (
    [string]$NomMachine,
    [string]$IpMachine
)


#Fonction retour
function end_rep_return {
    while ($true) {
        Start-Sleep 3
        Clear-Host
        Write-Host "Voulez-vous retourner au Menu Gestion des Répertoires ou sortir du script ?`n"
        Write-Host "1 - Retour au Menu Gestion des Répertoires.`nX - Sortir.`n"
        $choice_return_end = Read-Host "Votre choix"
        switch ($choice_return_end) {
            "1" {
                Write-Host "`nRetour au Menu Gestion des Répertoires..."
                Log "ReturnDirectoryManagementMenu"
                return
            }
                                
            { $_ -match '^[xX]$' } {
                Write-Host "`nA bientôt !`n"
                Log "EndScript"
                throw
            }
                                
            Default {
                Clear-Host
                Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
                Log "InputError"
                continue
            }
        }
    }
}


#Fonction création de répertoire
function dir_creation {
    while ($true) {
        Start-Sleep 2
        Clear-Host
        Write-Host ""
        $rep_name = Read-Host "Entrez le chemin complet du répertoire à créer (Exemple : /home/user/monRépertoire)"
        
        #Vérification si le répertoire saisi est correcte et non vide
        if ([string]::IsNullOrEmpty($rep_name) -or $rep_name -notlike '/*') {
            Clear-Host
            Write-Host "`nAttention !`nVous n'avez rien saisi ou la saisie est incorrecte !`n`nVeuillez recommencer SVP."
            Log "InputError"
            continue
        }
        #Vérification si le répertoire saisi existe déjà
        ssh -t "wilder@172.16.40.30" "[ -d '$rep_name' ]"
        $exit_code = $LASTEXITCODE

        if ($exit_code -eq 0) {
            Clear-Host
            Write-Host "`nAttention ! Le répertoire $rep_name existe déjà !"
            Log "DirectoryEntryAlreadyExists"
            end_rep_return
            return
        }
        else {
            #Création du répertoire saisi
            ssh -t "wilder@172.16.40.30" "mkdir -p '$rep_name'"
            Write-Host "`nRépertoire $rep_name créé avec succès !`n"
            Log "DirectoryCreated"
            end_rep_return
            return
        }
    }
}


#Fonction modification répertoire
function dir_renaming {
    while ($true) {
        Start-Sleep 2
        Clear-Host
        Write-Host ""
        $rep_rename = Read-Host "Entrez le chemin complet du répertoire à renommer/modifier (Exemple : /home/user/monRépertoire)" 
        Write-Host ""

        #Vérification si le répertoire saisi est correcte et non vide
        if ([string]::IsNullOrEmpty($rep_rename) -or $rep_rename -notlike '/*') {
            Clear-Host
            Write-Host "`nAttention !`nVous n'avez rien saisi ou la saisie est incorrecte !`n`nVeuillez recommencer SVP."
            Log "InputError"
            continue
        }
        #Vérification si le répertoire saisi existe
        ssh -t "wilder@172.16.40.30" "[ -d '$rep_rename' ]"
        $exit_code = $LASTEXITCODE

        if ($exit_code -eq 0) {
            $new_rep_name = Read-Host "Entrez le nouveau chemin complet du répertoire à renommer (Exemple : /home/user/monRépertoire)"

            #Vérification si le nouveau répertoire saisi est correcte et non vide
            if ([string]::IsNullOrEmpty($new_rep_name) -or $new_rep_name -notlike '/*') {
                Clear-Host
                Write-Host "`nAttention !`nVous n'avez rien saisi ou la saisie est incorrecte !`n`nVeuillez recommencer SVP."
                Log "InputError"
                continue
            }
            else {
                #Modification du répertoire
                ssh -t "wilder@172.16.40.30" "mv '$rep_rename' '$new_rep_name'"
                Write-Host "`nLe répertoire $rep_rename a été déplacé et/ou renommé en $new_rep_name !`n"
                Log "DirectoryRenamed"
                end_rep_return
                return
            } 
        }
        else {
            Clear-Host
            Write-Host "`nAttention ! Le répertoire $rep_rename n'existe pas !`n"
            Log "DirectoryEntryDoesntExist"
            end_rep_return
            return
        }
    }
}


#Fonction suppression de répertoire
function dir_deletion {
    while ($true) {  
        Start-Sleep 2
        Clear-Host          
        Write-Host ""
        $rep_del = Read-Host "Entrez le chemin complet du répertoire à supprimer (Exemple : /home/user/monRépertoire)"
        
        #Vérification si le répertoire saisi est correcte et non vide
        if ([string]::IsNullOrEmpty($rep_del) -or $rep_del -notlike '/*') {
            Clear-Host
            Write-Host "`nAttention !`nVous n'avez rien saisi ou la saisie est incorrecte !`n`nVeuillez recommencer SVP."
            Log "InputError"
            continue
        }
        #Vérification si le répertoire saisi existe
        ssh -t "wilder@172.16.40.30" "[ -d '$rep_del' ]"
        $exit_code = $LASTEXITCODE

        if ($exit_code -eq 0) {
            confirm_dir_deletion $rep_del
            return
        }
        else {
            Clear-Host
            Write-Host "`nAttention ! Le répertoire $rep_del n'existe pas !`n"
            Log "DirectoryEntryDoesntExist"
            end_rep_return
            return
        }
    }
}


#Fonction confirmation de suppression de répertoire
function confirm_dir_deletion {
    param(
        [string]$rep_del
    )
    while ($true) {
        Write-Host ""

        #Confirmation de suppression du répertoire saisi
        $confirm_rep_del = Read-Host "Confirmez-vous la supression du répertoire $rep_del ? (O/n)" 
        if ($confirm_rep_del -match '^[Oo]$') {

            #Suppression du répertoire saisi et ce qu'il contient
            ssh -t "wilder@172.16.40.30" "rm -r '$rep_del'"
            Write-Host "`nLe répertoire $rep_del a bien été supprimé !"
            Log "DirectoryDeleted"
            end_rep_return
            return
        }
        elseif ($confirm_rep_del -match '^[Nn]$') {
            Write-Host "`nLe répertoire $rep_del n'a pas été supprimé."
            Log "DirectoryNotDeleted"
            end_rep_return
            return
        }
        else {
            Clear-Host
            Write-Host "`nSaisie incorrecte.`nVeuillez recommencer SVP."
            Log "InputError"
            continue
        }
    }
}


#Fonction Log
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


#######################################################################################################
#Bloc principal
#######################################################################################################

Log "NewScript"

while ($true) {
    Start-Sleep 2
    Clear-Host
    Write-Host ""
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host "####                                       ####"
    Write-Host "####                                       ####"
    Write-Host "####     Menu Gestion des Répertoires      ####"
    Write-Host ("####  {0,-35}  ####" -f "$NomMachine")
    Write-Host ("####  {0,-35}  ####" -f "$IpMachine")
    Write-Host "####                                       ####"
    Write-Host "###############################################"
    Write-Host "###############################################"
    Write-Host "`nBienvenue dans le Menu Gestion des Répertoires.`n"
    Log "WelcomeToDirectoryManagementMenu"
    Write-Host "Que souhaitez-vous faire ?`n"
    Write-Host "1 - Créer un répertoire.`n2 - Renommer un répertoire.`n3 - Supprimer un répertoire.`n4 - Retourner au Menu Action Machine.`nX - Sortir.`n"
    $choice_menu_gestion_rep = Read-Host "Votre choix"
    switch ($choice_menu_gestion_rep) {
        "1" {
            dir_creation
            continue
        }

        "2" {            
            dir_renaming
            continue
        }

        "3" {
            dir_deletion
            continue
        }

        "4" {
            Write-Host "`nRetour au Menu Action Machine...`n"
            Log "ReturnMachineActionMenu"
            return
        }

        { $_ -match '^[xX]$' } {
            Write-Host "`nA bientôt !`n"
            Log "EndScript"
            throw 
        }

        Default {
            Clear-Host
            Write-Host "`nErreur de saisie.`nVeuillez faire votre choix selon ce qui est proposé."
            Log "InputError"
            continue
        }
    }
}