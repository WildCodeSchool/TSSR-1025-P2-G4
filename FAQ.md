## ❓ Foire Aux Questions (FAQ) - 


*Cette section regroupe les réponses aux questions courantes concernant l'utilisation et le déploiement de nos scripts d'automatisation.*

## 📋 Général

### Q : Quel est l'objectif de ce projet ?

R : *Ce projet a été réalisé dans le cadre de la formation TSSR (Technicien Supérieur Systèmes et Réseaux) à la Wild Code School. Il s'agit du Projet 2, réalisé par le Groupe 4, visant à automatiser des tâches d'administration système via des scripts (Shell/Bash).*

### Q : Quelles sont les fonctionnalités principales ? 

R : *Le script permet principalement de :*

*Automatiser la gestion des utilisateurs (ou tâches similaires selon le sujet précis).*

*Effectuer des tâches de maintenance ou de sauvegarde.*

*Générer des logs d'activité. (ex : création d'utilisateurs, monitoring... ).*


## ⚙️Installation et Utilisation

### Q : Quels sont les prérequis techniques ?

R :
*Un système d'exploitation de type Linux (Debian/Ubuntu recommandés).*

*Un accès au terminal avec des droits root ou sudo pour certaines opérations.*

*L'interpréteur Bash installé.*

### Q : Comment récupérer le projet ? 

R : *Clonez le dépôt GitHub avec la commande suivante :*

*Bash*

*git clone https://github.com/WildCodeSchool/TSSR-1025-P2-G4.git*
*cd TSSR-1025-P2-G4*

### Q : J'ai une erreur "Permission denied" en lançant le script, que faire ? 

R : *Vous devez rendre le script exécutable avant de le lancer. Utilisez la commande :*

*Bash*

*chmod +x nom_du_script.sh*
*./nom_du_script.sh*

## 🐛 Dépannage et Contribution

### Q : Le script ne s'exécute pas correctement, où regarder ? 

R : *Vérifiez les fichiers de logs générés par le script (souvent situés dans /var/log/ ou dans le dossier courant selon votre configuration). Assurez-vous également que votre environnement dispose des paquets nécessaires listés dans le fichier README.md (s'il y en a).*

### Q : Puis-je contribuer ou signaler un bug ? 

R : *Oui ! Si vous êtes un membre de la Wild Code School ou un évaluateur :*

*Ouvrez une Issue pour signaler un problème.*

*Proposez une Pull Request si vous souhaitez suggérer une correction.*

### Q : Qui sont les auteurs de ce projet ? 

R : *Ce projet est maintenu par les membres du Groupe 4 de la promotion TSSR-1025.*

