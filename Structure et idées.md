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

---

## SESSION DE RÉFLEXION AUTONOME — Idées & développements

*Ce qui suit a été généré en session autonome, en cohérence avec tout ce qui précède. À valider, modifier, rejeter selon ta vision.*

---

### Monnaie — Les Synapses

La monnaie du jeu s'appelle les **Synapses** — les connexions biologiques entre neurones. C'est cohérent avec l'univers et immédiatement compréhensible.

**Comment on en gagne :**
- Ennemis vaincus (drop aléatoire, quantité variable selon difficulté)
- Zones cachées et coffres lumineux
- Récompenses de certains PNJ

**Comment on les dépense :**
- Achats chez les marchands PNJ (items, infos, fragments de carte)
- Réparer des neurones endommagés avant de les activer
- Débloquer certains passages scellés (portes "neurales")

**Système de mort :**
- À la mort : Zell éclate en particules au point de mort, ses Synapses restent sur place sous forme de petit amas lumineux
- Elle se reforme au dernier neurone activé
- Retourner sur le point de mort = récupérer les Synapses
- Mourir à nouveau avant de les récupérer = perte définitive
- **Filet de sécurité** : 10% des Synapses actuelles sont automatiquement sauvegardées à chaque neurone activé — le joueur a toujours un plancher

---

### PNJ

#### Solin — Le Gardien des Neurones
Petit être fait de lumière blanche-bleue, discret, ancien. Il vit près des checkpoints neurones et les entretient depuis toujours. Il vend des objets basiques (fragments de soin, morceaux de carte). Parle en phrases courtes et fragmentées, comme de vieilles pensées.
> *"Tu n'es pas la première lumière à passer par ici."*

#### Mémo — L'Archiviste *(La Mémoire)*
Être frénétique et enthousiaste, obsédé par le catalogage. Aide Zell à comprendre les fragments de souvenir collectés. Il permet de rejouer les souvenirs déjà trouvés. Légèrement chaotique — ses propres archives sont en désordre.
> *"Ce souvenir-là — je l'avais classé sous 'M' pour... pour... je ne sais plus."*

#### Écho — L'Errant
NPC fragmenté qui apparaît aléatoirement dans différentes zones. Fait de particules de lumière éparpillées, jamais tout à fait cohérent. Donne des indices cryptiques sur l'identité de Veilae. Se contredit parfois — c'est une pensée oubliée qui essaie de se souvenir. Personnage le plus émouvant du jeu.
> *"V... elle aimait... le jaune ? Non. Le bleu ? Non..."*

#### Filin — Le Réparateur *(Zone Câbles)*
Être pragmatique et brusque mais fondamentalement bienveillant. Répare et améliore l'épée d'énergie en échange de Synapses + matériaux rares. Le seul PNJ vraiment "commercial" du jeu.
> *"J'peux la réparer. Mais ça va coûter."*

#### Les Gardiens Silencieux *(Zone Paisible)*
Petits êtres qui n'ont pas de nom, ne parlent jamais. Observent Zell. Si elle s'arrête près d'eux assez longtemps, ils lui offrent un don (soin, Synapses). Représentent l'instinct de survie, le soin inconscient de soi.

#### Veille — La Conscience Fragmentée *(L'Oubli, très tard)*
Miroir de Zell mais sous une forme plus ancienne. La manifestation la plus proche de la vraie conscience de Veilae. Parle peu, sait des choses que le joueur ne comprend pas encore. Personnage révélation.
> *"J'ai attendu longtemps. Je savais que tu reviendrais."*

---

### Ennemis — par zone

#### Les Yeux

**Les Aveugles**
Créatures phosphènes translucides sans yeux — juste des anneaux blancs. Naviguent uniquement par vibration. Standing still = invisibles pour eux. Courir vite = ils agressent. Leur présence encourage le joueur à se déplacer prudemment dès le début.

**Les Formes**
Rosas corrompues — asymétriques, glitchantes. Flottent lentement. Au contact : légère distorsion visuelle de l'écran. Fragiles (2 coups d'épée). Visuellement : cercles géométriques fissurés, violet avec craquelures dorées.

**Les Filaments**
S'étirent en travers des couloirs comme des fils de lumière. Ralentissent Zell si elle les touche sans les couper. Peuvent être tranchés à l'épée ou traversés en dash.

#### Les Émotions *(Phase 2)*

**Les Larmes** *(Tristesse)*
Lentes, mélancoliques, passives jusqu'à être acculées. En mourant elles laissent une flaque qui ralentit brièvement — le chagrin s'attarde.

**Les Braises** *(Colère)*
Rapides, agressives, foncent sur Zell. Quand touchées à l'épée : se divisent en 2. Seul le Coup de Jus les détruit complètement.

**Les Éclats de Joie** *(Joie)*
Rebondissants, chaotiques, presque adorables. Peuvent accidentellement booster le saut de Zell. Quand acculés : explosion en zone.

#### La Bouche *(Phase 2)*

**Les Bactéries**
Se divisent en deux au coup d'épée (max 3 générations). Le Coup de Jus les détruit sans division. Visuellement rondes, colorées, presque mignonnes.

**Les Caries**
Version grande et sombre des Bactéries. Mi-boss récurrents, commandent les petites bactéries autour d'eux.

#### La Mémoire

**Les Engrammés**
Souvenirs cristallisés — une main, une silhouette figée. Invulnérables, juste repoussables. Servent de plateformes mobiles dans certaines zones.

**Les Effacés**
Quasi-invisibles, détectables uniquement à leur contour. Au contact : une portion de la carte de Zell est temporairement effacée. Psychologiquement déstabilisants.

#### L'Oubli

**Les Glitches**
Ennemis qui semblent mal chargés — ils stuttent, se téléportent sur de courtes distances, ont des hitbox imprévisibles. Visuellement : corruption pixelisée, texture manquante.

#### Ennemi spécial — Phase 2 en général

**L'Ombre**
Silhouette humanoïde de Zell (sa forme Phase 2) qui apparaît parfois dans le fond des couloirs — juste pour observer. Pas hostile. Disparaît si Zell s'approche. Elle seule peut voir cette ombre. Devient boss dans La Mémoire en Phase 2.

---

### Mécaniques nouvelles

#### L'Impulsion *(disponible dès le début)*
Zell peut émettre une brève onde d'énergie concentrée. Usages :
- Révèle les passages secrets (les murs réagissent s'il y a quelque chose derrière)
- Stun bref sur les ennemis proches
- Active certains mécanismes dans l'environnement
- **3 charges** rechargées à chaque neurone activé
- Visuellement : un anneau de lumière dorée qui s'expand depuis Zell

#### Traces de Conscience
Zell laisse de très légères empreintes lumineuses qui durent 60 secondes. Aide à ne pas se perdre dans le labyrinthe des Yeux. Discret mais présent pour qui regarde.

#### L'Écho de Mort
À l'endroit de sa mort, une silhouette fantôme rejoue brièvement les derniers instants de Zell. Aide le joueur à comprendre comment il est mort. S'efface quand Zell récupère ses Synapses.

#### La Résonance des Fragments
Quand Zell est proche d'un fragment/collectible caché, son corps vibre légèrement et émet un son doux. Plus forte à mesure qu'elle se rapproche. Boussole incarnée — pas d'indicateur sur la carte, juste une sensation physique.

#### Surcharge Émotionnelle *(Phase 2 uniquement)*
Prendre 5+ coups consécutifs sans repos déclenche un état de "surcharge" : les bords de l'écran pulsent de la couleur émotionnelle de la zone, Zell est ralentie, l'image vibre légèrement. Se dissipe en restant quelques secondes sans prendre de dégâts près d'un espace sûr. Représente l'écrasement émotionnel.

---

### Zones — développement détaillé

#### Zone de Tri *(archives du cerveau)*
Rayonnages infinis de dossiers lumineux, très clinique, blanc/gris froid. Tout est étiqueté dans un code que seul le cerveau comprend. Atmosphère : bureaucratie de l'inconscient.
- **Mécanique** : puzzles de classement — ranger les bons dossiers dans les bons conteneurs pour ouvrir des passages
- **Ennemi** : Les Classeurs — automates de classement qui deviennent hostiles quand on perturbe l'ordre
- **Boss secondaire** : Le Réviseur — entité obsessionnelle qui considère Zell comme un élément non autorisé à effacer
- **Musique** : drone minimal, hum électrique presque silencieux

#### Zone avec des Câbles *(nom à définir)*
Faisceaux massifs de câbles lumineux enchevêtrés, couleurs chaudes (orange, jaune, blanc). Représente le système nerveux moteur et sensoriel. Certains câbles sont "live" — les toucher = dégâts électriques.
- **Mécanique** : rediriger les courants électriques pour alimenter des mécanismes et ouvrir des portes
- **NPC** : Filin vit ici
- **Ennemi** : Les Courts-Circuits — éclats d'énergie explosive qui voyagent le long des câbles
- **Boss secondaire** : La Surcharge — être d'énergie surchargé, attaques en rafale imprévisibles

#### Zone Paisible / Sagesse *(nom à définir)*
Espace vaste et ouvert, lumière ambrée douce venue de nulle part, plateformes qui flottent comme des nénuphars. Presque aucun ennemi.
- **Mécanique** : spots de méditation — rester immobile quelques secondes restaure les charges d'Impulsion + soin léger. Inscriptions environnementales qui donnent des Synapses si lues.
- **Boss secondaire** : Le Gardien Paisible — ne veut pas se battre mais teste Zell avec une série d'épreuves avant de la laisser passer
- **Musique** : vent, cordes douces, respiration

#### Zone de Rêve *(très haut sur la map)*
Au-dessus des nuages. Géométrie impossible, îles flottantes, ciel rose et or, trop parfait pour être réel. Quelque chose cloche — une beauté légèrement wronge.
- **Mécanique** : la gravité s'inverse par endroits. Les plateformes obéissent à une logique de rêve (une plateforme "solide" peut s'effondrer si on y croit trop fort). Un souvenir de Veilae qui rêvait de voler est caché ici.
- **Musique** : harpe, célesta, aucun rythme fixe

#### Les Émotions *(Phase 2)*
Trois sous-zones qui saignent les unes dans les autres. Les couloirs changent de ton en plein milieu.
- *Tristesse* : corridors inondés, plateformes à ras de l'eau, tout en bleu-gris atténué
- *Colère* : terrain qui s'effrite, murs qui craquent, rouge intense avec particules de feu
- *Joie* : aveuglément lumineux jaune-blanc, cache le plus grand danger
- **Boss** : Le Nœud Émotionnel — boss 3 phases, cycling entre les trois émotions

#### Oreille Gauche *(Phase 1)*
Herbe noire de cils auditifs partout. Presque aucune lumière. Design sonore central : voix lointaines filtrées, TV dans une autre pièce, klaxon, pluie. On n'entend jamais ce qui est dit — délibérément traité et distordu. Plus on avance, plus les sons se précisent — sans jamais être intelligibles.
- **Boss** : Le Filtre — entité qui traite et bloque les sons, doit être perturbée pour révéler les sons sous-jacents

#### Oreille Droite *(Phase 2)*
Même esthétique que l'Oreille Gauche mais plus intense. Les sons sont presque clairs. On croit entendre un prénom. Une révélation narrative majeure se produit ici — quelque chose qui recontextualise ce qu'on croyait savoir.

#### La Bouche *(Phase 2)*
Couleurs de bonbons — roses, bleus, vert menthe — avec une sous-couche de pourriture. Plateformes en sucre qui se dissolvent (il faut bouger). Terrain collant par endroits (chewing-gum — ralentit).
- **Boss** : Le Festin — colonie de bactéries ayant développé une intelligence rudimentaire, boss massif et chaotique

#### L'Oubli *(Phase 2)*
Zone littéralement incomplète — certaines tuiles manquent, des salles s'arrêtent net. Le terrain disparaît derrière Zell (impossible de revenir en arrière dans certaines sections). La carte ne se sauvegarde pas correctement ici — par design.
- **Boss** : Le Vide — on ne peut pas le voir. On combat quelque chose qui n'est pas tout à fait là.
- Contient les indices "V." disséminés sur les murs

#### Le Cœur *(Phase 3)*
Zone unique, aucune exploration — élan pur vers l'avant. Le battement de cœur devient la musique, de plus en plus irrégulier. Tout pulse à chaque battement, rouge et noir. Boss en 3 phases :
- *Arythmie* : attaques irrégulières, patterns imprévisibles
- *Arrêt* : silence total, tout gèle, puis explosion soudaine
- *Renaissance* : le cœur bat régulièrement pour la première fois, devient beau — Veilae choisit de vivre

---

### Puzzles

**Connexion Neuronale** — Relier des nœuds neuronaux flottants en traçant un chemin d'énergie entre eux. Complète un circuit, ouvre un passage.

**Séquence de Mémoire** — Des Rosas s'allument dans un ordre. Reproduire la séquence en les touchant. Rater 3 fois = le fragment s'enfonce plus profond (chemin alternatif requis).

**Écho Sonore** *(Oreille zones)* — Écouter un pattern sonore puis activer les bonnes sources dans l'environnement dans le même ordre. Aucun indice visuel.

**La Patience** *(Zone Paisible)* — Rester complètement immobile 10 secondes près d'un passage bloqué. Aucun ennemi, aucun danger. Pure épreuve de calme.

**L'Illusion** *(Zone de Rêve)* — Le "bon" chemin ressemble à un mur. Il faut marcher dedans. La logique de rêve : faire confiance à l'impossible.

**Le Classement** *(Zone de Tri)* — Glisser des dossiers lumineux dans les bons conteneurs selon couleur et forme. Mauvais placement = légère décharge électrique.

---

### Collectibles

**Souvenirs** *(déjà documentés)* — Scènes mémoire rejouables.

**Portrait de Veilae** — Puzzle collectible dispersé sur tout le jeu. Chaque fragment ajoute un élément au portrait visuel de Veilae (visage, cheveux, expression). Le portrait complet est révélé dans la cinématique finale — le joueur voit enfin qui il était.

**Pensées Fugaces** — Textes ou images qui clignotent 1-2 secondes quand Zell passe à certains endroits. Trop rapides pour tout lire d'un coup — il faut revenir et s'arrêter.

**Lettres Déchirées** — Fragments de messages, pages de carnet. Reconstituent les relations de Veilae : amis, famille, moments du quotidien.

**Nœuds Neuronaux Cachés** — Neurones secrets qui, activés, étendent le réseau de fast travel au-delà du chemin standard.

---

### Musique — tableau par zone

| Zone | Instruments | Ambiance |
|---|---|---|
| Les Yeux | Piano + flûte, doux | Éveil, curiosité fragile |
| Oreille Gauche | Ambient pur, voix filtrées | Mystère, distance |
| Zone de Rêve | Harpe, célesta, arythmique | Irréel, trop parfait |
| La Mémoire | Piano seul, dissonances rares | Mélancolie, poids |
| Zone de Tri | Drone minimal, hum électrique | Froid, clinique |
| Zone Câbles | Électronique chaud, groove | Énergie, tension |
| Zone Paisible | Vent, cordes douces | Paix, respiration |
| Les Émotions | Change par sous-zone | Tristesse / Colère / Joie |
| Oreille Droite | Comme gauche, plus intense | Révélation, urgence |
| La Bouche | Jazz léger, légèrement faux | Faux-joyeux, uncanny |
| L'Oubli | Musique qui glitche et s'efface | Instabilité, angoisse |
| Le Cœur | Battement de cœur = musique | Intensité pure |

---

### Questions à te poser avant de continuer

1. **L'accident** — c'est quoi exactement ? Voiture ? Vélo ? Quelque chose de plus ambigu (tentative) ? Ça change beaucoup la lecture émotionnelle du jeu.
2. **La zone de transition** (style Dirtmouth) — le Nez ? Autre chose ? Il faut un nom et une identité visuelle.
3. **Les PNJ parlent comment à Zell ?** Elle est une boule d'énergie. Est-ce qu'ils la voient comme une conscience ? Comme une anomalie ? Est-ce qu'il y a des dialogues texte ou juste des expressions visuelles ?
4. **Le Coup de Jus** — c'est une énergie à gérer (jauge) ou un cooldown simple ?
5. **La Zone de Rêve** — plutôt légère et féérique ou plus psychédélique et perturbante ?
6. **Les boss secondaires** droppent quoi exactement ? Des améliorations d'épée ? Des Synapses en masse ? Des fragments de lore ?
7. **Peut-on rater des choses définitivement ?** (true ending vs ending normal selon les collectibles trouvés ?)
8. **L'Ombre** (silhouette humanoïde de Zell en Phase 2) — est-ce que le joueur comprend ce que c'est quand il la voit pour la première fois, ou c'est délibérément mystérieux ?
9. **Noms à trouver** : Zone Câbles, Zone de Tri, Zone Paisible, Zone de transition. Tu as des pistes ?
10. **Le mini-boss des Yeux** — tu imagines quoi visuellement ? Une Rosa corrompue ? Une forme aveugle massive ?
