# Bike Management

## Table des matières

- [Description](#description)
- [Installation](#installation)
    - [La base de données](#la-base-de-données)
    - [L'application web](#lapplication-web)
- [Utilisation](#utilisation)
    - [Contenu](#contenu)
    - [Bugs connus](#bugs-connus)

## Description

Ce projet de SGDB effectué à l'ENSEIRB-MATMECA et propose
de modéliser un système d'emprunt de vélos dans des stations par des adhérents.

Ce projet contient :

- Les fichiers necessaires à la crétation et population de la base de
donnée ainsi que des requêtes de consultation, mise à jour ou statistiques utiles.

- Une application web permettant de manipuler la base de donnée
dans une interface de type administrateur.

La base de donnée utilisée est **MariaDB** et l'application web utilise
un serveur HTTP **Node.js**.

## Installation

Si besoin, une version hébergée de notre application est disponnible
[ici](http://bikes-management.ddns.net/).

#### La base de donnée

Le projet utilise une base de donnée [MariaDB](https://mariadb.org/).

Pour fonctionner, il faut tout d'abord créer une base de donnée (ex: `velo`)
et disposer d'un utilisateur avec tous les droits dessus.

Une fois la base sélectionnée, il faut créer les tables représentant notre modèle relationnel :

```sql
> source SQL/creation.sql
```

Ensuite, il faut peupler la base avec des données de départ :

```sql
> source SQL/population.sql
```

Le fichier `SQL/all.sql` effectue les deux actions précédentes et peut être directement `source`.

La base est maintenant prête. Elle peut être utilisée avec l'application
ou alors on nous pouvons directement l'interroger avec des requêtes SQL.
Des listes de requêtes utiles et/ou utilisées dans notre application se trouvent
dans `SQL/consultation.sql`, `SQL/statistiques.sql`, `SQL/maj.sql`.

> Pour supprimer les données de la base, il suffit de sourcer le fichier de supression :
> ```
> > source SQL/supression.sql
> ```
> La base se retrouvera alors vide.

#### L'application web

L'application web est basé sur [Node.js](https://nodejs.org/).

Pour lancer l'application, il faut d'abord installer les dépendances avec `npm` :

```bash
$ cd app
$ npm install
```

Certains paramètres peuvent être configurés dans `app/config.js`.
Notamment pour les identifiants et l'adresse et le port de connexion
à la base ainsi que le port d'écoute pour le serveur HTTP.

Ensuite, le serveur peut être lancé :

```bash
$ node server.js
```

Si tout se passe bien le seveur est accessible par défaut à l'adresse
[http://localhost:8888](http://localhost:8888).

## Utilisation

### Contenu

L'application est censé être intuitive et concerne plutôt le côté administrateur.
Voici une liste des fonctionnalitées disponnibles ainsi que leut emplacement :

- **List des stations** sur la page d'acceuil sous forme de carte.

- **Consultation** de la station et de ses vélos en cliquant sur le marker et ensuite sur l'adresse

- Consultation, ajout, modification et supression des adhérents dans l'onglet *Adhérents* du menu

- Liste des vélos avec filtre en cours d'emprunt / rendus dans l'onglet *Vélos*

- Gestion des emprunts, filtre en cours / terminés, rendu des emprunts terminés, emprunt d'un vélo dans l'onglet *Emprunts*

- Lites de statistiques sur les vélos / adhérents dans l'onglet *Statistiques*

### Bugs connus

- La supression d'un adhérent en train d'emprunter un vélo est interdite côté base
avec un trigger et une vérification dans la procédure de supression.
Cependant, l'erreur n'est pas capturé coté serveur ce qui produit une non réponse du serveur au client.
La supression reste tout de même impossible mais aucune erreur est indiquée côté client.

- ...

## Autheurs

- [MOREL Pierre-Jean](https://github.com/pjdevs)
- [MARAIS Lucas](https://github.com/luks-m)
- [MEDINA Enzo](https://github.com/Zaksley) 