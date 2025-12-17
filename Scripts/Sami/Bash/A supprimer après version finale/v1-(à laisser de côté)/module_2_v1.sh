#!/bin/bash

# -------------------------------------------------------------------------------------
# Module 2
# -------------------------------------------------------------------------------------
echo "Bienvenue dans le Menu Gestion des Utilisateurs."
read -p "Entrez un Nom d'Utilisateur : " user_name

if id "$user_name" &>/dev/null
then
    source menu_user_exist.sh
else
    echo -e "L'utilisateur n'existe pas.\nRedirection vers l'espace Création d'Utilisateur."
    source create_user.sh
fi