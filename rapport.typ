#import "@preview/zen-utbm-report:0.1.0": report


#show: doc => report(
  doc-title: [Rapport de projet RC50 - Implémentation d'un réseau RER],
  doc-author: ("Hugo Allainé", "Léo Angonnet", "Kaoura Fablet", "William Imbert", "Noémie Lévêque"),
  course-name: "RC50",
  doc,
  
)

= Introduction et contexte du projet

Le but de ce projet était d'implémenter un réseau Réseau d'Education et de Recherche (RER) entre 6 établissements universitaires (UTBM et UHA en France, Cambridge et Oxford en Angleterre, Zurich en suisse et Munich en Allemagne). Dans ce cadre, voici les services qu'il était nécessaire d'implémenter :
- Une base de données afin d'enregistrer les données générées par l'utilisation de l'outil documentaire
- Un service web permettant de répondre aux requetes des utilisateurs souhaitant accéder au service documentaire
- Un outil de gestion documentaire, permettant de gérer les documents dans la base de données des universités

De plus, le réseau RER doit être implémenté en prenant en compte la sécurité et la restriction des accès : les données ne doivent être accessibles que depuis le réseau RER, et les paquets entrants et sortants doivent être filtrés.


Afin de proposer une solution viable à ces exigences, nous nous sommes mis dans la peau d'une vraie équipe d'ingénieurs en procédant d'abord à une phase d'étude nous permettant d'évaluer les différentes solutions se présentant à nous. Cette phase a notamment été conclue par la réalisation d'une vidéo présentant les choix retenus ainsi que le planning de mise en oeuvre.

Ce rapport présentera donc dans un premier temps les solutions étudiées lors de la phase de conception. Nous nous concentrerons ensuite sur la solution retenue, ainsi que sur les détails de son implémentation. Enfin, nous proposerons un retour d'expérience sur ce projet et ce qu'il nous a apporté dans le cadre de notre parcours d'apprentissage.

= Phase d'étude

La première étape de la réalisation du projet a été la phase de conception. Dans un premier temps, nous avons simplement commencé par discuter oralement des solutions nous venant en tête pour chaque projet à leur annonce. Cela nous a notamment permis de mieux comprendre leurs implications et de choisir ensemble le projet qui semblait le plus correspondre à nos compétences. Ainsi, lorsque nous avons choisi le projet RER, nous avions déjà pu réfléchir aux implications de celui-ci. Durant la première semaine suivant le choix du projet, nous avons uniquement discuté oralement de la manière dont nous allions procéder avant de décider d'organiser une réunion afin de réaliser un premier tri dans nos idées.
Pour entammer la phase de conception, nous avons donc décidé de séparer le problème en plusieurs sous-problèmes et de proposer nos différentes solutions pour chacun d'entre eux.

*Quelle topologie réseau choisir ?*\
Dans un premier temps, nous avons étudié les différentes topologies réseau existantes. Nous avons proposé trois solutions afin de peser leurs avantages et inconvénients :

Premièrement, la topologie en étoile semble la plus simple. En effet, il pourrait suffire d'un seul hub central contenant tous les services à un seul et même endroit. Les différentes universités se connecteraient donc directement sur ce hub. Cependant, cela présente un problème majeur : cette topologie présente un Single Point of Failure, car une panne au niveau du hub rend le tout inutilisable.

Pour éviter ce problème, nous avons pensé à une topologie en anneau où chaque station peut jouer le role de relai pour atteindre une station suivante. Cette approche aurait permis de déployer une base de données distribués sur chaque noeud, tout en gardant une topologie relativement simple et en évitant d'introduire un Single Point of Failure. Le désavantage principal est qu'en cas de double panne sur le réseau, certaines données peuvent demeurer inaccessibles.

Enfin, la dernière approche que nous avons étudié est la topologie maillée, où chaque université serait reliée à l'intégralité des autres universités. Avec cette topologie, il est possible d'atteindre une résilience très importante où plusieurs noeuds peuvent être impactés avant que les services deviennent inaccessibles. Cette approche a cependant comme désaventage une nombre des liaisons très élevés, ce qui accroit la complexité de maintenance et les coûts.

*Quel outil de gestion documentaire utiliser ?*\
Afin de gérer les documents des universités, nous avons du réfléchir à quel outil serait adapté pour ce cas d'utilisation. Nous avions deux possibilités : 
Premièrement, nous avons pensé à développer nous-même une plateforme simple de gestion de documents car plusieurs membres de notre groupe sont issus de la branche Développement. L'avantage de cette solution aurait été de pouvoir mettre en pratique nos compétences en développement. En contrepartie, le développement d'une solution de zéro, même simple, est très chronophage et serait un "bonus" au projet.
La deuxième possibilité était de choisir une solution open source déjà existante, telle que Paperless-ngx ou Nextcloud. De cette manière, nous aurions une solution plus robuste avec un moindre effort. Ces solutions reposent souvent sur d'autres services comme Redis

*Comment stocker les données ?*\
Dans notre cas, le choix de la base de données s'est directemnet porté sur du SQL, car elles sont bien plus suceptibles d'être supportées par les outils de gestion documentaires existants. Parmis les bases SQL, PostgreSQL est le choix le plus courant et solide, notamment concernant la création de bases distribuées.
En plus du stockage des données relationnelles, il faut également penser au stockages des documents eux-mêmes, nécessitant un système de fichier distribué pour garantir la redondance. Nous avons étudié les deux options les plus populaires, à commencer par la création d'un cluster Ceph. Cette solution est performante et présente des fonctionnalités avancées adaptées aux gros volumes de données, mais son déploiment s'avère complexe.
De l'autre côté, nous avons enviseagé d'utiliser GlusterFS, qui reste solide et plus simple à déployer. En contrepartie, il s'agit d'une solution moins efficace pour supporter les grosses charges de lecture/écriture.

*Comment assurer la sécurité du réseau ?*\
Pour assurer la sécurité du réseau, nous avons listé les différentes mesures que nous connaissions :
- Accès admin sécurisé aux équipements réseau ?
- Segmentation et cloisonnement du réseau avec des VLANs
- Contrôle des flux, avec des ACL
- Sécurisation inter-site, en utilisant un VPN site à site
- Authentification des utilisateurs sur le service de gestion documentaire

*Comment assurer le déploiment multi universités ?*\
Afin de déployer nos services de manière répliquable, nous avons analysé plusieurs options. 
Dans un premier temps, la solution la plus simple consiste à simplement déployer les nouvelles configurations par scripts bash sur les serveurs. Cela a l'avantage d'être simple à mettre en place, mais une configuration complète peut être assez complexe à gérer.
Nous avons également bien évidemment pensé à Docker, couplé à Docker Compose qui simplifient grandement le processus. De plus, certains outils de gestion documentaire comme Paperless-ngx proposent déjà des images adaptées.
Ensuite, nous avons évoqué la possibilité d'orchestrer le déploiment avec Ansible, permettant de mieux gérer les changements et la réplicabilité de notre travail.

*Comment simuler le réseau d'une manière collaborative ?*\
Enfin, nous avons du réfléchir à une manière de collaborer sur ce projet de manière stable.
En effet, la solution par défaut aurait été de travailler chacun sur notre propre environnement virtuel en local et de nous envoyer les changement apportés régulièrement. Cependant, nous avons considéré ce mode de travail nous ferait perdre beaucoup de temps, et avons souhaité travailler sur un environnement partagé.........


= Solution retenue

Une fois cette première phase de réflexion passée, nous avons échangé avec notre porteur de projet pour lui faire part des différentes solutions envisagées. Cela nous a permi d'adapter certains choix (comme celui de la topologie), avant de réaliser la vidéo de mi-semestre présentant la solution retenue et le plan de mise en oeuvre.

Premièrement, nous avons choisi une topologie en anneau pour relier les universités entre elles. Il s'agissait de la solution "intermédiaire" entre la topologie en étoile ne garantissant aucune redondance et la topologie maillée, trop complexe à maintenir pour notre projet. Nous gardons toutefois à l'esprit que passer sur une topologie maillée par la suite pourrait garantir une meilleure résilience.
Pour l'outil de gestion de base de données, nous nous sommes décidés à utiliser une solution déjà existante car le développement n'est pas une compétence évaluée pour le projet. Nous avons choisi d'utiliser Paperless-ngx car la procédure de déploiment sur infrastructure distribuée nous a semblé mieux documentée. Ce choix implique le déploiment d'un broker Redis en plus des services demandés de plus, nous avons retenu PostgreSQL comme base de données car il s'agit de la référence actuelle dans l'industrie, bien que MySQL soit également compatible réputée.




Quelle solution on a retenu (ce qu'il y a dans la vidéo), avantages et inconvénients
Schéma du réseau


= Résultats de l'implémentation
// Faire une partie à part pour l'organisation et répartition des tâches ?

Présenter comment on a implémenté pour collaborer (avec Nasdak), et ce que ça donne pour nous

= Retour d'expérience

S'inspirer en partie du retex de LP25

= Conclusion