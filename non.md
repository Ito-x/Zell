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

---

## SESSION DE RÉFLEXION 2 — Approfondissement

*Deuxième session autonome. Focus sur la profondeur narrative, la cohérence du monde, les boss, les mécaniques et les visuels. Tout est à valider.*

---

### La question centrale du jeu — L'ambiguïté de l'accident

Ce choix est le plus important de tout le design narratif. Trois options :

**Option A — Accident involontaire** : Veilae est victime d'un événement extérieur (voiture, chute). Le jeu parle de survie pure et de l'instinct de vie.

**Option B — Acte volontaire** : Veilae a fait un choix. Le jeu devient alors l'histoire d'une conscience qui combat contre elle-même pour revenir. Le Double de Phase 2 prend une signification radicalement plus forte. La fin "choisir de vivre" n'est plus une victoire sur la mort accidentelle — c'est une décision consciente, active, gagnée.

**Option C — Ambiguïté totale et délibérée** *(recommandée)* : Le jeu ne confirme jamais. Les fragments peuvent être lus dans les deux sens. La silhouette sur le vélo dans le souvenir — est-ce un souvenir heureux ou le moment précédant l'accident ? La Lettre #3 qu'on entend dans l'Oreille Droite — c'est une famille qui attend, ou quelqu'un qui supplie ? Le joueur projette ce qu'il veut, ou ce qu'il craint. Certains joueurs ne comprennent jamais. D'autres relient tout. Les deux expériences sont valides.

L'option C est la plus courageuse et la plus originale. Elle distingue ZELL de n'importe quel autre jeu.

---

### Les règles internes du monde

Le cerveau de ZELL n'est pas anatomique — c'est **émotionnel**. Les zones ne sont pas là où elles "devraient" être biologiquement. Elles sont là où Veilae les *ressent*.

- **Les Yeux** ne sont pas derrière les yeux — ils sont l'expérience des yeux fermés.
- **La Bouche** n'est pas dans la mâchoire — c'est la mémoire du goût, de la parole, du plaisir.
- **Le Cœur** est au centre parce qu'il *est* le centre de tout.

Règles qui gouvernent ce monde :

**1. La Cohérence comme santé**
Zell est pure conscience. Sa "santé" n'est pas physique — c'est sa cohérence. Prendre des dégâts = se fragmenter. Visuellement : à pleine santé, son sprite est net, solide. En perdant de la vie, elle se disperse — de plus en plus particules, de moins en moins forme. Près de la mort : à peine maintenue ensemble. Cela se voit directement sur le sprite, sans UI.

**2. Le temps diverge**
Dans le monde réel, Veilae est peut-être dans le coma depuis quelques heures. À l'intérieur, Zell explore des semaines. Chaque moment dans le coma est compté dehors. À l'intérieur, le temps est sans limite — et c'est précisément ce qui donne sa valeur à chaque souvenir retrouvé.

**3. Les Rosas comme baromètre**
Les Rosas pulsent en rythme avec l'état neurologique de Veilae. Au début du jeu : vives, lumineuses. Si le joueur revient dans Les Yeux en Phase 2 : les Rosas sont plus ternes. Elles clignotent parfois. Le coma s'approfondit. Ce n'est jamais dit — ça se voit.

**4. Les ennemis ne sont pas des ennemis**
Aucun habitant de ce cerveau n'est fondamentalement mauvais. Les Aveugles ne cherchent pas à tuer — ils réagissent par peur. Les Formes étaient belles avant d'être corrompues. Les Braises *sont* la colère de Veilae — une émotion légitime. Ce n'est jamais expliqué en jeu. Mais si le joueur y pense, il réalise que combattre dans ZELL, c'est toujours combattre une partie de soi.

---

### L'état visuel de Zell — Progression des dégâts

Le sprite de Zell change selon sa santé. Pas de barre de vie visible dans l'espace de jeu — l'information est dans le sprite lui-même.

| Santé | Apparence |
|---|---|
| 100% | Sphère nette, gradient blanc-or-ambré, glow stable |
| 75% | Bords légèrement plus dispersés, quelques particules flottantes |
| 50% | Forme moins définie, plus ambré que blanc, particules dérivent |
| 25% | À peine cohérente, centre blanc minuscule, quasi-entièrement particules |
| Critique | Tremblante, presque invisible, tenue par un fil |

Même logique pour les fragments acquis :
- Chaque Souvenir absorbé = une partie du corps apparaît sur Zell
- L'acquisition est une micro-cinématique de 3-4 secondes
- Souvenir de frapper → un bras doré se matérialise, saisit la mémoire, s'intègre
- Souvenir de marche → des jambes de lumière apparaissent, Zell "atterrit" différemment
- Souvenir de tomber → les jambes se consolident, posture plus ancrée
- Souvenir d'atteindre → le bras gauche, Zell tend les deux bras pour la première fois
- Fin de Phase 1 → la transformation complète en humanoïde est progressive, pas soudaine

---

### Bosses — Design complet

#### Mini-boss des Yeux — La Forme Impure

Une Rosa corrompue. Ce qui était beau est devenu une menace.

**Arène** : Grande salle circulaire. Les Rosas sur les murs pulsent en sync avec le boss.

**Phase 1** : Tourne lentement en émettant des éclats géométriques en spirale. Patterns de dodge lisibles. Peut être frappée entre les volées.

**Phase 2 (60% PV)** : Se scinde en 3 Formes plus petites qui bougent en formation géométrique coordonnée. Doivent être détruites dans un certain ordre — la première déstabilise les deux autres.

**Phase 3 (30% PV)** : Les 3 fusionnent à nouveau. Le boss est maintenant erratique, brisé, désespéré. Ses attaques sont imprévisibles mais il est plus fragile.

**Défaite** : La géométrie brisée se reconstruit lentement. 3 secondes d'une Rosa parfaite, lumineuse, immobile. Puis elle se dissout en laissant le Souvenir de frapper suspendu en son centre. La musique revient à la version douce le temps d'un instant.

---

#### Boss de La Mémoire — L'Oubli Voulu

Une manifestation du désir de Veilae d'oublier ce qui fait mal.

**Apparence** : Silhouette faite de chaînes entrelacées. Lent. Presque doux dans ses mouvements. Il ne ressemble pas à un monstre — il ressemble à quelqu'un d'épuisé.

**Phase 1** : Ses chaînes s'étendent vers Zell, pas pour frapper — pour retenir. Si elles l'atteignent, elles ralentissent ses déplacements (la mémoire musculaire s'efface brièvement). Les chaînes peuvent être coupées à l'épée.

**Phase 2 (50% PV)** : Il projette sur les murs de l'arène des fragments de souvenirs de Veilae. Si Zell s'approche trop des projections, elle est brièvement paralysée — la mémoire la submerge. Il faut combattre en ignorant les images.

**Phase 3 (20% PV)** : Le boss commence à se dissoudre lui-même. Ses attaques deviennent plus lentes, plus tristes. On peut sentir qu'il ne veut pas vraiment faire de mal — il veut juste que ça s'arrête.

**Défaite** : Les chaînes tombent. Des fragments de mémoire pleuvent comme de la neige lumineuse. Mémo apparaît, submergé. Le boss devient une lumière paisible avant de disparaître. Drop : Spell de Fusion du Métal + fragment de souvenir majeur.

---

#### Boss des Émotions — Le Nœud Émotionnel

Un boss à 3 phases, une par émotion. L'arène change de couleur à chaque phase.

**Phase Tristesse** : Lourd, lent. Attaques en larges zones — faciles à voir venir, difficiles à éviter par leur amplitude. La musique est déchirante. Le boss se déplace comme quelqu'un qui porte un poids énorme.

**Phase Colère** : Rapide, chaotique. Il charge à travers l'arène. Des particules de feu remplissent l'espace. L'écran tremble à chaque impact. La musique est percussions pures.

**Phase Joie** : Le boss semble se calmer. Il rebondit presque joyeusement. La musique devient légère. Puis : explosion massive sans prévenir. Répétition. La joie est la phase la plus dangereuse parce qu'elle est imprévisible dans son intensité.

**Entre les phases** : Un moment d'immobilité. Le boss semble perdu. Comme s'il ne savait plus ce qu'il ressent. Fenêtre courte pour soigner ou attaquer.

---

#### Boss de l'Oreille Gauche — Le Filtre

L'entité qui filtre et bloque les sons du monde extérieur.

**Arène** : Couloir acoustique. Les ondes sonores sont visibles ici — des pulses de lumière qui traversent l'espace.

**Mécanique unique** : Le Filtre peut couper certains sons du jeu. Mécaniquement : il supprime les cues audio d'attaque. Le joueur doit lire les animations visuellement. Génère une tension différente des autres boss.

**Phase 2** : Le Filtre commence à défaillir. Des éclats de sons extérieurs percent — une voix, un bip d'hôpital, quelque chose d'incompréhensible mais présent. Le Filtre panique. Ses attaques deviennent plus désespérées.

**Défaite** : Le Filtre éclate. Un flot de sons filtrés remplit l'espace — toujours étouffés, toujours incompréhensibles, mais plus présents que jamais. Narrativement : quelque chose se dit dehors, sur Veilae. On ne comprend pas encore.

---

#### Le Double — La Mémoire, Phase 2

Le boss le plus chargé émotionnellement du jeu.

**Apparence** : La forme humanoïde de Zell (Phase 2) en version plus sombre, plus translucide, plus lente. Ses contours sont moins nets. Elle semble fatiguée.

**Mécanique** : Elle n'attaque pas au sens traditionnel. Elle essaie de RETENIR Zell. Ses "attaques" sont des étreintes qui deviennent des prises. Elle ralentit, elle immobilise, elle tire en arrière. Combattre le Double, c'est combattre quelque chose qui veut que tu t'arrêtes.

**Ce qu'elle communique** (texte en fragments) :
> *"Tu es fatiguée."*
> *"Laisse-moi."*
> *"C'est fini."*
> *"Reste."*

**Défaite** : Elle ne meurt pas. Elle se dissout lentement. Sa dernière ligne :
> *"...peut-être."*

Ce "peut-être" est la réponse la plus honnête qu'elle puisse donner. Elle ne capitule pas — elle doute. C'est suffisant.

---

#### Le Vide — L'Oubli

**L'arène semble vide.** Le joueur prend des dégâts de rien. Il ne voit rien.

**Mécanique** : L'Impulsion révèle le Vide pendant une fraction de seconde. Le joueur doit Impulser, voir où il est, frapper dans la fenêtre de visibilité, puis le Vide disparaît à nouveau.

Il ne fait jamais de son. Il ne parle jamais. Il existe dans l'espace des choses oubliées — il a oublié ce qu'il était.

**Défaite** : Rien ne se passe visuellement. Les dégâts s'arrêtent. Un silence. Puis sur le mur, une seule lettre apparaît et reste :
> *"V."*

---

#### Le Cœur — Boss final, Phase 3

**L'arène EST le cœur.** Les murs pulsent. Le sol bat. Tout est biologique-architectural.

**Phase 1 — Arythmie** : Le sol se hérisse sur les battements irréguliers du cœur. Le plafond descend. Rien n'est sur un rythme prévisible. Il faut survivre au chaos. Le boss n'est pas visible — il EST l'arène.

**Phase 2 — Arrêt** : Tout s'arrête. Silence complet. Le battement s'est tu. Zell flotte dans le noir immobile. Puis : un seul battement massif — BOOM — l'arène entière se contracte. Un seul impact qui fait d'énormes dégâts. Il faut l'anticiper dans le silence.

**Phase 3 — Renaissance** : Le cœur recommence à battre, régulièrement, pour la première fois. L'arène devient belle — rouge et or. Le cœur se matérialise comme une forme physique visible, qui bat. Chaque battement émet un pulse de lumière dorée. Cette phase demande à Zell de synchroniser ses attaques sur le rythme — frapper dans le battement, esquiver hors du battement.

**Le coup final** : Zell ne frappe pas. Elle se place au centre. Le cœur bat une dernière fois autour d'elle. Fondu au blanc.

Puis : des yeux qui s'ouvrent.

---

### Zone secrète — La Peau

Une zone que personne ne t'a dite d'aller chercher. Elle n'est pas sur la carte. Elle existe à la frontière du monde.

**Accès** : Passages cachés dans plusieurs zones. Zell traverse un mur qui semble plein et trouve... le vide blanc.

**Visual** : Quasi-blanc. Minimaliste à l'extrême. Les Rosas ici sont à peine visibles — des contours à peine perceptibles. Pas d'ennemis. Pas de collectibles. Juste l'espace.

**Ce qui se passe** : Par moments, les murs de La Peau craquent et laissent passer un éclat de lumière blanche — le monde réel, juste de l'autre côté. Ces cracks apparaissent quand des événements narratifs se produisent dehors (quelqu'un parle à Veilae, une décision médicale est prise).

**Évolution par phase** :
- Phase 1 : Quelques cracks rares. Curiosité.
- Phase 2 : Les cracks sont plus nombreux, parfois accompagnés de sons étouffés.
- Phase 3 : La Peau se désintègre. On voit presque à travers. Le dehors est très proche.

La Peau n'a pas de boss. Pas de récompense directe. Elle existe pour les joueurs qui cherchent. Pour leur rappeler que derrière tout ça, il y a une chambre d'hôpital.

---

### Matériaux rares pour l'épée

Chaque upgrade de l'épée nécessite des Synapses + un matériau spécifique, forçant l'exploration :

| Upgrade | Coût Synapses | Matériau | Où trouver |
|---|---|---|---|
| 1 — Range | 100 | Cristal de Mémoire | La Mémoire (salles cachées) |
| 2 — Dégâts | 200 | Filament d'Énergie | Zone Câbles (caches le long des câbles) |
| 3 — Range ×2 | 350 | Fragment de Rêve | Zone de Rêve (collectibles éthérés) |
| 4 — Dégâts ×2 | 500 | Éclat d'Émotion | Les Émotions (ennemis forts) |
| 5 — Paralysie | 750 | Les 4 matériaux ×1 chacun | Avoir tout exploré |

L'upgrade 5 exige de prouver qu'on a été partout. Narrativement cohérent : la paralysie complète n'est possible que quand Veilae a tout traversé.

---

### L'épée d'énergie — Évolution visuelle

| État | Apparence |
|---|---|
| Base | Lame courte, blanc-or, propre |
| Upgrade 1 | Lame visiblement plus longue |
| Upgrade 2 | Plus lumineuse, bordure ambré-orange |
| Upgrade 3 | Très longue, laisse un sillage bref à chaque swing |
| Upgrade 4 | Intense, crépitante, s'entend avant d'être vue |
| Upgrade 5 | Une pointe bleu électrique apparaît — la lame a trois couleurs |

Chaque swing du niveau 5 laisse un flash blanc-bleu. L'animation doit sembler libérer quelque chose d'énorme.

---

### Spell du Réseau Neuronal — Où le trouver

*(Le spell de fast-travel n'a pas encore de localisation définie.)*

**Proposition** : Pas droppé par un boss. À la place — il se débloque automatiquement quand le joueur a activé TOUS les neurones standards. La logique : Zell a exploré assez pour comprendre le réseau. Elle peut maintenant l'utiliser.

C'est une récompense d'exploration totale, pas de combat. Différent de tous les autres unlocks. Et narrativement fort : comprendre le réseau prend du temps. Ça ne se donne pas.

---

### La carte — Système différent de Hollow Knight

La carte de ZELL est un **diagramme de réseau neuronal**, pas une grille.

- Les salles sont des **nœuds** reliés par des **lignes** (couloirs)
- Ressemble visuellement à un scan cérébral ou une carte synaptique
- Zones découvertes : lumineuses, colorées de la couleur de la zone
- Zones non découvertes : contours à peine visibles dans le noir
- Neurones checkpoints : nœuds lumineux qui pulsent sur la carte
- Passages secrets découverts : lignes pointillées
- L'Oubli : sa section de carte est volontairement corrompue/incomplète

Fragments de carte achetables chez Solin (révèle une zone voisine non explorée).

---

### Lore — Exemples de textes in-game

*Ces fragments sont des pistes pour écrire les vrais textes plus tard.*

**Lettre #1** *(Les Yeux, bien cachée)* :
> "...tu reviendras pour l'anniversaire ? Maman a fait le gâteau au..."
*(déchirée — on ne saura jamais quel parfum)*

**Lettre #2** *(La Mémoire)* :
> "...je t'ai cherchée partout après les cours. V., réponds-moi quand tu..."
*(l'expéditeur ne finit pas — ni nom ni genre identifiable)*

**Lettre #3** *(Oreille Droite, Phase 2 — la plus importante)* :
> "Veilae. Les médecins disent que tu peux peut-être entendre. Alors je..."
*(quelqu'un lui parle dans la chambre d'hôpital. On l'entend enfin.)*

**Pensée Fugace** *(Zone de Rêve)* :
> "Le jaune du soleil sur la route ce matin-là."

**Pensée Fugace** *(L'Oubli)* :
> "V..."

**Inscription** *(Zone Paisible)* :
> "Ce qui est calme n'est pas perdu."

**Fragment de mémoire rejouable** *(La Mémoire)* :
Une silhouette sur un vélo. Lumière du soleil. Un sourire. La scène commence à se rembobiner, de plus en plus vite, jusqu'à ne plus être que du blanc.
*(Est-ce un souvenir heureux ? Est-ce le moment juste avant ? Les deux lectures coexistent.)*

---

### Mécaniques supplémentaires

**La Réminiscence** — Dans certains lieux, Zell peut activer un souvenir du lieu. Elle voit brièvement ce que cet endroit était avant d'être corrompu. Usages : lire des inscriptions détruites, révéler des passages qui existaient, comprendre l'origine d'un ennemi.

**La Conductivité** — Dans la Zone Câbles, Zell peut servir de pont électrique. Tenir la position entre deux contacts pendant que l'épée est chargée crée un circuit. Alimente des mécanismes, ouvre des portes.

**Sillage de Conscience** — Quand Zell dash, elle laisse un afterimage pendant une demi-seconde. Cet afterimage peut activer certains switchs qui "voient" Zell passer. Permet des puzzles de timing précis.

**La Fragmentation Volontaire** *(Phase 2, tard)* — Zell peut se disperser brièvement en particules pour traverser des passages étroits ou certaines barrières. Court délai, risquée — si touchée pendant la fragmentation, elle se recoagule en état endommagé.

---

### Design sonore — Philosophie

Le cerveau filtre tout. Cette idée structure tout l'audio du jeu.

**Sons du monde extérieur** : toujours étouffés, filtrés, comme entendus depuis le fond d'un bain. Jamais intelligibles en Phase 1. Presque clairs en Phase 2. Clairs en Phase 3.

**Le battement de cœur meta** : un battement très lent et très discret court sous toute la musique du jeu, trop bas pour être conscient. En Phase 3, quand il devient explicite, les joueurs ressentent une reconnaissance viscérale sans savoir pourquoi.

**Les PNJ parlent comment** : pas de voix humaines. Chaque PNJ a un son abstrait qui correspond à son registre émotionnel :
- Solin : bourdonnement grave et calme
- Mémo : cliquetis staccato, frénétique
- Écho : réverbération longue, presque un écho justement
- Le Double : le son exact de Zell, mais légèrement plus lent, plus grave

**La musique réactive** : la même mélodie de zone joue différemment selon l'état de Zell :
- Pleine santé : version propre, mélodique
- Endommagée : dissonances qui s'introduisent
- En combat : le rythme s'intensifie
- Critique : la mélodie se fragmente

---

### Accessibilité

**Mode Narration** : Combat allégé, checkpoints plus fréquents, Synapses moins perdues à la mort. Pour ceux qui veulent l'histoire.

**Mode Standard** : L'expérience conçue.

**Mode Épreuve** : Ennemis plus durs, checkpoints plus rares, perte de Synapses accrue, aucune aide à la carte.

Options supplémentaires :
- Daltonisme : alternatives visuelles pour les codes couleur émotionnels
- Réduction du screen shake
- Vitesse de texte ajustable

---

### Nouvelles questions — Session 2

*Questions narratives :*

1. L'accident est-il volontaire, involontaire ou délibérément ambigu ? C'est le choix le plus lourd de conséquences pour tout le reste.
2. Quel âge a Veilae exactement ? (13 ? 16 ? 17 ?)
3. Depuis combien de temps est-elle dans le coma au début du jeu ?
4. La voix qui dit "Veilae..." à la fin — c'est qui ? Un parent ? Un ami ? Le médecin ? Cette réponse change tout le sens de la fin.
5. Qui est dans la chambre d'hôpital ? Ses deux parents ? Un seul ? Un ami proche ? Personne ?
6. Veilae a-t-elle des frères et sœurs ? Ça change les lettres.
7. Est-ce qu'on voit le monde réel à un moment, ou uniquement à travers sons et La Peau ?
8. Le prénom Veilae — qu'est-ce qu'il signifie pour toi ? D'où vient-il ?
9. Y a-t-il un leitmotiv — une mélodie que Veilae aimait et qu'on retrouve sous différentes formes dans le jeu ?
10. Les souvenirs collectés montrent-ils des moments heureux, douloureux, ou délibérément les deux ?

*Questions sur les zones :*

11. Les zones sont-elles disposées géographiquement de façon cohérente (oreilles sur les côtés, cœur au centre) ou la géographie est-elle purement émotionnelle ?
12. Y a-t-il une zone que tu veux ajouter qui n'est pas encore documentée ?
13. La Zone de Rêve — c'est un rêve récurrent de Veilae ou un espace générique ?
14. L'Oubli — il existait avant le coma ou s'est formé à cause de lui ?
15. La Mémoire a-t-elle des sous-zones (bons souvenirs d'un côté, mauvais de l'autre) ?
16. Le Cœur est-il géographiquement au centre de tout ou complètement séparé, accessible uniquement en Phase 3 ?
17. Qu'est-ce qui se passe si le joueur retourne dans Les Yeux en Phase 2 — les Rosas sont-elles plus ternes ?
18. La Peau (zone secrète de frontière) — c'est une idée qui t'intéresse ?
19. La zone "sobre de transition" (Dirtmouth-like) — tu veux qu'elle ait des PNJ ou qu'elle soit vide et mélancolique ?

*Questions sur les noms :*

20. Zone avec des Câbles → "Les Axones" ?
21. Zone de Tri → "Les Archives" ou "Le Cortex" ?
22. Zone Paisible → "Le Sanctuaire" ou "La Sagesse" ?
23. Zone de transition → "Le Vestibule", "Le Seuil", "Le Nez", autre ?
24. Le mini-boss des Yeux → "La Forme Impure" — ça te parle ?
25. Boss de La Mémoire → "L'Oubli Voulu" ?
26. Boss des Émotions → "Le Nœud Émotionnel" ?
27. Boss de l'Oreille → "Le Filtre" ?
28. Boss de L'Oubli → "Le Vide" ?

*Questions sur les ennemis :*

29. Les ennemis ont-ils une origine narrative explicite (ce qu'ils "représentent") ou c'est purement esthétique/implicite ?
30. Peut-on pacifier certains ennemis (ne pas les tuer) pour une récompense différente ?
31. Y a-t-il des ennemis exclusifs à chaque zone ou certains types se retrouvent partout (avec évolution) ?
32. Les Effacés (quasi-invisibles) — l'Impulsion les révèle-t-elle ?
33. Y a-t-il un ennemi qui drop un matériau rare systématiquement (farming possible) ou uniquement en exploration ?

*Questions sur les PNJ :*

34. Les PNJ peuvent-ils mourir ou être tués accidentellement ?
35. Y a-t-il des quêtes données par des PNJ ?
36. Écho apparaît combien de fois et dans quelles zones ?
37. Solin est-il un individu unique (il se téléporte) ou une espèce (plusieurs Solin identiques) ?
38. Les PNJ réagissent différemment selon la Phase (Phase 1 vs 2) ?
39. Y a-t-il un PNJ antagoniste — quelqu'un qui s'oppose verbalement à Zell ?
40. Mémo peut-il évoluer ses services au fil du jeu ?

*Questions sur le gameplay :*

41. La mort fait-elle respawner les ennemis de la zone ?
42. Y a-t-il une limite au nombre de morts avec conséquence (perte permanente de quelque chose après X morts) ?
43. L'Impulsion peut-elle être améliorée (plus de charges, plus grande portée) ?
44. Y a-t-il des objets consommables (one-use) ?
45. Le dash est-il directionnel (8 directions) ou uniquement horizontal ?
46. Y a-t-il une mécanique de nage pour les zones inondées (sous-zone Tristesse) ?
47. La carte — le joueur la dessine en explorant ou elle se révèle progressivement autrement ?
48. Y a-t-il un journal/codex accessible depuis le menu (souvenirs, lettres, pensées fugaces) ?
49. Les charges d'Impulsion se rechargent-elles uniquement aux neurones ou aussi avec le temps ?
50. La Résonance des Fragments — c'est une mécanique dès le départ ou débloquée ?

*Questions sur la progression :*

51. La 5e amélioration d'épée (paralysie) est-elle visiblement "la dernière" dès le début ou révélée progressivement ?
52. Y a-t-il d'autres upgrades que l'épée (Impulsion améliorée, santé max) ?
53. Y a-t-il un nombre fixe de "HP max" augmentables achetables ?
54. La progression est-elle completable à 100% en une run ou certains passages sont manquables ?
55. Le spell de fast-travel se débloque sur exploration totale des neurones — ça te convient ?

*Questions visuelles :*

56. Style résolution — pixel art ou haute résolution lisse ? Le "dessin animé flou" oriente vers quoi concrètement ?
57. Les Rosas sont-elles statiques ou elles pulsent/bougent ?
58. Les PNJ — humanoïdes, abstraits, géométriques ? Y a-t-il une cohérence visuelle par type ?
59. L'interface (HUD) — tu imagines ça comment ? Minimal, discret, pratiquement invisible ?
60. La couleur verte est-elle absente de tout l'univers de ZELL sauf dans les zones glitchées/corrompues ?

*Questions audio :*

61. La musique est-elle composée spécifiquement ou on part sur du libre de droits pour commencer ?
62. Y a-t-il un leitmotiv de Veilae qu'on entend transformé à travers les zones ?
63. Les ennemis ont-ils des sons distinctifs ou c'est ambiance pure ?
64. Les menus — silence pesant ou musique d'ambiance ?
65. Le battement de cœur sous-jacent à toute la musique — tu valides l'idée ?

*Questions méta/design :*

66. Durée de jeu visée pour une run complète 100% ?
67. Y a-t-il du contenu post-game (boss secret, new game+) ?
68. Le jeu est prévu pour PC uniquement ou console aussi ?
69. Y a-t-il plusieurs fins ou une seule (avec variantes selon collectibles) ?
70. Est-ce que le joueur peut comprendre l'histoire sans chercher les collectibles ou les collectibles sont essentiels ?
71. Y a-t-il un titre pour chacune des 3 phases (affiché à l'écran lors de la transition) ?
72. La narration est-elle entièrement environnementale/implicite ou y a-t-il quelques lignes de narration externe (voix off) ?
73. Le Portrait de Veilae (collectible puzzle) — il se révèle dans le menu ou dans le jeu à un endroit précis ?
74. Y a-t-il un espace "galerie" dans le menu pour voir les souvenirs, lettres et portrait collectés ?
75. L'ambiguïté du jeu — tu es à l'aise avec l'idée que certains joueurs ne "comprennent" pas tout, ou tu veux qu'une lecture soit clairement favorisée ?
