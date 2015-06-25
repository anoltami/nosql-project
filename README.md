# NoSQL-project : Hello everybody
---
Projet NoSQL de 4ème année d'ingénieurie à l'EPSI. 

Ce projet est un moteur de recherche de personnes. Chaque personnes a été ajoutée depuis un crawler (ici twitter ou github). Le projet se divise donc en 3 parties :

<br>
### - Github crawler :
<br>

Il se trouve dans le dossier `/Jobs/Github Crawler`. Il a été developpé en Ruby. Le fichier `addJob.rb` permet d'ajouter des *organizations* ou *members* à traiter dans la file d'attente. Le fichier `doJobs.rb` effectue chaque **job** dans la file d'attente un par un. 

- Si c'est un *member*, le crawler va récupérer l'email, le pseudo, le nom, le prénom, la location etc... et l'ajouter à la base elastic search du **Search Engine**.

- Si c'est une *organization*, le crawler va récupérer tous les *members* et créer les jobs correspondants à chaque *member*.

<br>
### - Twitter crawler :
<br>

Il se trouve dans le dossier `/Jobs/Twitter Crawler`. Il a été developpé en Python. Le fichier `twitter_crawler.py` est un script prenant en paramètre un pseudo de d'un utilisateur sur Twitter. Il insère toutes les datas d'un user dans la bdd.

<br>
### - Search engine :
<br>

Il se trouve dans le dossier `/Search engine`. C'est le moteur de recherche de personne. Developpé en nodejs, il requete une base elastic search pour trouver ses infos.