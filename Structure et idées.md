# ZELL — Structure & Idées

## Le jeu
Metroidvania onirique. Le joueur explore l'intérieur du cerveau d'une adolescente dans le coma. Style dessin animé flou, féerique, effets de lumière et particules, narration environnementale. Moteur : **Godot**.

---

## Le personnage principal
- Vrai prénom : **Veilae** — révélé uniquement à la toute fin
- Surnom possibilities : **Zel / Zell / Zèle / Zele / Zelle** — à trancher
- Une ado dont on reconstruit l'identité au fil du jeu
- Phase 1 : boule d'énergie née du choc
- Phase 2 : forme humanoïde féminine faite d'énergie

---

## L'accident
Un accident. Veilae est dans le coma.

---

## Système de progression du personnage

Zell commence comme une **boule d'énergie pure**. Elle ne trouve pas des membres physiques — elle absorbe des **fragments de souvenirs** qui *prennent la forme* de membres d'énergie lumineuse. Mécaniquement identique à trouver des powerups, visuellement cohérent avec l'univers onirique.

| Fragment trouvé | Ce que ça devient | Capacité débloquée |
|---|---|---|
| Souvenir de marche | Jambes d'énergie | Dash / sprint |
| Souvenir d'atteindre | Bras gauche | Interaction / grimper |
| Souvenir de frapper | Bras droit | Épée d'énergie |
| Souvenir de tomber | Jambe renforcée | Double saut |

La zone tutorielle **Les Yeux** contient ces 4 premiers fragments, structurée en mini-zones distinctes autour de chaque souvenir.

---

## Structure narrative — 3 phases

**Phase 1 — Qui elle était**
Boule d'énergie. Zones liées à l'identité et aux souvenirs de Veilae. Chaque boss principal déverrouille un souvenir cinématique important et un spell. À la fin elle se souvient d'elle-même complètement → flash blanc → elle change de forme.

**Phase 2 — Ce qu'elle traverse**
Forme humanoïde. Zones plus sombres liées au deuil et à la survie. Elle affronte sa volonté de vivre ou mourir.

**Phase 3 — Le Cœur**
Une seule zone. Course finale intense. Boss final = le Cœur lui-même. Le rallumer = choisir de vivre = réveil.

---

## La fin
Ses yeux s'ouvrent. Une voix dit *"Veilae..."* pour la première fois. Le joueur recolle tout. Fondu au blanc.

*Des indices sur son vrai nom sont semés pendant tout le jeu — voix distordues, initiale "V.", fragments dans la zone Oubli.*

---

## Les zones

*Chaque zone possède un boss. Les boss principaux droppent un souvenir important + un spell. Les boss secondaires droppent des récompenses annexes (à définir).*

### Phase 1

- **Les Yeux** — zone tutorielle. Endroit sombre décoré de Rosas — formes circulaires géométriques — violettes, dorées, roses et bordeaux. Musique douce au piano ou à la flûte. C'est ici qu'on récupère l'épée d'énergie et les 4 premiers fragments de souvenirs.

- **Oreille gauche** — accessible en phase 1. Tapissée d'herbe noire représentant les cils auditifs. On entend des bribes de l'extérieur — des gens qui parlent, flou, comme derrière une porte. On ne comprend pas vraiment ce qui se dit.

- **Zone de rêve** — très haut sur la map. Licornes et éléments féeriques.

- **La Mémoire** — zone avec des chaînes. Contient une pièce bloquée par des chaînes qui sert à stocker les souvenirs récupérés et à les revoir. Une mécanique est à trouver pour forcer le joueur à y revenir régulièrement. Le boss principal droppe un souvenir + le spell de fusion du métal. En phase 2, ce même endroit accueille le double de Zell.

- **Zone de tri** — archives du cerveau. *(boss secondaire)*

- **Zone avec des câbles** *(boss secondaire)*

- **Zone paisible / sagesse** *(boss secondaire)*

### Phase 2

- **Les Émotions** — tristesse, colère et joie se mélangent.

- **Oreille droite** — accessible uniquement en phase 2. Tapissée d'herbe noire représentant les cils auditifs. Contient des révélations importantes.

- **La Bouche** — paradis de sucrerie avec des bactéries à combattre.

- **L'Oubli** — zone instable, clé pour les indices sur le vrai nom de Veilae.

### Phase 3

- **Le Cœur** — boss final.

---

## Système de déplacement

Le joueur se déplace normalement à pied, en sautant etc. Pour voyager rapidement entre les zones, il peut utiliser le réseau électrique des neurones du cerveau — uniquement après avoir trouvé le spell dédié. Ce spell est indépendant et à découvrir dans le jeu.

En attendant, les neurones font office de simples checkpoints/points de sauvegarde, comme les grâces d'Elden Ring ou les bancs de Hollow Knight.

La bouche, les oreilles et les zones de chair ne sont pas desservies par ce réseau neuronal — mais elles possèdent quand même des checkpoints.

---

## Skills & Spells

**L'épée d'énergie** — récupérée dans Les Yeux, plantée dans un rocher de chair. Sert uniquement au combat. Améliorable 5 fois :
- Amélioration Range ×2 (2 niveaux)
- Amélioration Dégâts ×2 (2 niveaux)
- Le joueur choisit l'ordre des 4 premières améliorations librement
- 5ème amélioration (dernière) : stun/paralysie des ennemis — durée très courte, consommation d'énergie énorme

**Spell de fusion du métal** *(nom à définir)* — fait fondre le métal : chaînes, cadenas, obstacles métalliques. Droppé par le boss de la Mémoire. Débloque des zones et passages inaccessibles jusque-là.

**Spell du réseau neuronal** *(à trouver)* — permet d'utiliser le réseau électrique des neurones comme moyen de transport rapide entre les zones desservies.

**Coup de jus** — fait tomber l'arme d'un ennemi. Zell ne peut pas la ramasser. L'ennemi tente de la récupérer pour reprendre le combat — crée des moments de tension : l'achever pendant qu'il est vulnérable ou fuir ? Sur les boss : ne désarme pas mais inflige des dégâts électriques.

---

## Boss notables

- **Boss de la Mémoire** (phase 1) — droppe souvenir important + spell de fusion du métal.
- **Le double de Zell** (phase 2, zone Mémoire) — a brouillé les souvenirs stockés dans la salle : ils apparaissent en mode "Error" rouge. La vaincre reboot la salle, souvenirs restaurés *(ou pas — à voir)*.
- **Boss à pattern électrique** — l'un de ses patterns envoie un choc qui inverse les commandes du joueur pendant quelques secondes (gauche devient droite, etc.).

---

## PNJ
À définir — noms, raisons d'être là, quêtes potentielles, amitiés. L'idée de "peuples" s'occupant des fonctions du cerveau est sur la table. Système de map à définir, différent de Hollow Knight.

---

## Cinématique d'ouverture

### Concept
Écran noir total. La conscience de Veilae (Zell) naît progressivement dans le silence de son esprit. Aucun texte, aucune explication — juste les sons et la lumière.

### Séquence
```
Sirène de ambulance        → fade out progressif
Bip respiratoire hôpital   → fade out progressif  
Silence total              → 3 secondes 30
Zell s'allume              → apparition douce, comme une flamme dans le noir
Fondu musique              → la musique de Les Yeux monte doucement
```

### Sons à trouver
- Sirène d'ambulance (lointaine, étouffée)
- Bip régulier d'appareil respiratoire (très doux, presque imperceptible)
- Source : **freesound.org** (sons libres de droits)

### Structure technique (Godot)
- Scène dédiée : `scenes/world/Intro.tscn`
- Enchaîne vers `scenes/world/LesYeux.tscn` à la fin
- `AnimationPlayer` orchestre toute la séquence
- 2 `AudioStreamPlayer` (sirène + bip)
- 1 `AudioStreamPlayer` pour la musique de zone (fade in en fin de cinématique)

---

## Zone tutorielle — Les Yeux

### Concept visuel
Les yeux de Veilae sont fermés. On est dans l'obscurité de ses paupières. Les **Rosas** — formes circulaires géométriques violettes, dorées, roses et bordeaux — font référence aux **phosphènes** : ces formes lumineuses qu'on perçoit naturellement les yeux fermés.

### Structure de la map
Labyrinthique — le joueur peut explorer librement mais ne peut pas progresser sans les bons fragments. Chaque fragment débloque une capacité qui ouvre de nouveaux passages.

### Ordre des fragments et déblocages
| Ordre | Fragment | Capacité | Ce que ça débloque |
|---|---|---|---|
| 1 | Souvenir de frapper | Épée d'énergie | Ennemis bloquant des passages |
| 2 | Souvenir de marche | Dash / sprint | Fossés et gaps |
| 3 | Souvenir de tomber | Double saut | Zones en hauteur |
| 4 | Souvenir d'atteindre | Grimper | Salle finale / sortie |

### Taille
Moyenne — assez grande pour que les 4 fragments + le mini-boss prennent du temps à trouver, assez resserrée pour pouvoir remplir la zone de pièges et d'ennemis de façon cohérente. Objectif : 1h-2h de jeu pour un joueur qui explore.

### Point de départ — L'Iris
Zell apparaît au centre de la zone après la cinématique, dans une grande salle circulaire appelée **l'Iris**. C'est le hub central. 4 couloirs partent dans 4 directions, rapidement bloqués. La caméra recule doucement pour révéler l'environnement.

### Architecture en 5 zones
```
         [Zone 4 — Le Cristallin]
         ★ Fragment Grimper + Épée d'énergie
              ↑ (double saut requis)
         [Zone 3 — La Paupière]
         ★ Fragment Double Saut
              ↑ (dash requis)
    ←─────────────────────────────→
[Zone 2]   [IRIS — HUB CENTRAL]   [Zone 1]
★ Dash     ● Zell apparaît ici    ★ Mini-boss → Épée
 (gaps)    4 chemins partent ici   (après épée : accès Zone 2)
```

### Mini-boss
Présent à la fin de la Zone 1. Le joueur le trouve avant l'épée d'énergie — ou juste après, à définir. C'est le dernier obstacle de la zone tutorielle.

### Les Rosas comme repères
Dans les couloirs sombres, les Rosas (grandes formes circulaires géométriques lumineuses) servent de repères visuels. Le joueur retient naturellement "la grande Rosa violette = bas-gauche".

### Zone de transition (post-Les Yeux)
Entre Les Yeux et le reste du monde (Oreilles, Cerveau...) existe une **zone sobre de transition**, style Dirtmouth dans Hollow Knight — calme, neutre, point de passage entre les zones principales. Son identité visuelle et son nom sont à définir.
