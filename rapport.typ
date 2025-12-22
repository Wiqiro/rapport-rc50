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

Parler des différentes solutions qu'on a évaluées sur les outils à utiliser
- Topologie
- Sécurité
- Services
- Déploiment ?

= Solution retenue

Quelle solution on a retenu (ce qu'il y a dans la vidéo), avantages et inconvénients


= Résultats de l'implémentation
// Faire une partie à part pour l'organisation et répartition des tâches ?

Présenter comment on a implémenté pour collaborer (avec Nasdak), et ce que ça donne pour nous

= Retour d'expérience

S'inspirer en partie du retex de LP25

= Conclusion