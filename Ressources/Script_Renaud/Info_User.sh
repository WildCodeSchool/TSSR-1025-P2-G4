#/ bin bash
# sous menu info_user
 # fonction info_user


 while true
 do
 
echo "==========  "Menu: informations sur l'activité de l'utilisateur $user_name" ========"
echo "1 - date de la derniere connexion de l'utilisateur "
echo "2 - Date de dernière modification du mot de passe "
echo "3 - Liste des sessions ouvertes par l’utilisateur "
echo "4 - Retourner au menu Gestion des utilisateurs"
echo "5 - Quitter"
read -p " Choisissez une option: " choice



case $choice in
    1) 
        echo "date de la derniere connexion de l'utilisateur "
        last -n 1 $user_name
       
                while true
                do
 
                echo "==========  "Menu: desirez vous d'autres informations concernants $user_name" ========"
                echo "1 - Retourner au menu Gestion des utilisateurs"
                echo "2 - Quitter"
                read -p " Choisissez une option: " choice
                ;;
    2) 
        echo "Date de dernière modification du mot de passe "

        chage -l $user_name | grep -i "last password change"
       
                while true
                do
 
                echo "==========  "Menu: desirez vous d'autres informations concernants $user_name" ========"
                
                echo "1 - Retourner au menu Gestion des utilisateurs"
                echo "2 - Quitter"
                read -p " Choisissez une option: " choice
                ;;
          ;;

    3) 
        echo "Liste des sessions ouvertes par l’utilisateur " 

        loginctl list-sessions --no-legend --no-pager | awk '{print "user="$3, "uid="$2, "session="$1}'

                while true
                do
 
                echo "==========  "Menu: desirez vous d'autres informations concernants $user_name" ========"
                
                echo "1 - Retourner au menu Gestion des utilisateurs"
                echo "2 - Quitter"
                read -p " Choisissez une option: " choice
                ;;
       

        ;;
   
    4) 
        echo "Retourner au menu Gestion des utilisateurs "   
         ./
       

    5)
        echo "sortie"
        exit 0
       
        ;;
    *) 
        echo " choix invalide"
       
        ;;
esac  
done  