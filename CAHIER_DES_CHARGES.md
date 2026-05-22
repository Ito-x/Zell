# ZELL — Cahier des Charges

*Document de consignes par système. Pas de planning, pas de code. Chaque **Objectif** décrit un système à mettre en place : ce que le joueur doit ressentir, les contrôles, les graphismes, le son, les comportements attendus. Le détail narratif (zones, lore, boss spécifiques) vit dans `Structure_et_idées.md`.*

---

## Vision générale

Metroidvania 2D onirique sur Godot 4. Le joueur incarne **Zell**, une conscience née dans l'esprit de **Veilae**, une jeune femme (~18 ans) plongée dans le coma après un accident de voiture involontaire. Le jeu se passe à l'intérieur de son cerveau. Tout est ressenti, jamais expliqué. Ambiance onirique, lumière, particules, mystère. Plateformes visées : PC et console. Graphismes faits à la main, avec aide IA.

---

# OBJECTIF 1 — Système de mouvement de Zell

> **État : ✅ implémenté** (manque uniquement le bourdonnement continu en mouvement, à brancher quand l'asset sera trouvé)

## Ressenti joueur
Léger, flottant, mais réactif. Zell n'est pas une masse — elle est une boule d'énergie. Le déplacement doit donner l'impression d'une bougie animée par sa propre volonté, pas d'un sac à patate qui tombe. Le saut doit être *satisfaisant à répéter* : on doit avoir envie de sauter pour rien.

## Contrôles
- Déplacement horizontal (clavier flèches ou ZQSD / stick gauche manette)
- Saut (touche dédiée)
- Saut maintenu = saut plus haut
- **Pas de double saut** (idée abandonnée). La verticalité supplémentaire passe par le **dash vertical** débloqué en Phase 1 (cf. Objectif 7).
- Le déplacement reste **toujours** disponible, même en combat, même en chargeant une attaque

## Comportement physique
- Accélération douce au sol (pas de démarrage instantané, mais pas de patinage exagéré)
- Friction nette quand on relâche
- En l'air : contrôle horizontal légèrement réduit (entre Mario et Hollow Knight)
- **Coyote time** : 0.1-0.15s après avoir quitté une plateforme, le saut reste possible
- **Jump buffering** : si la touche saut est pressée 0.1-0.15s avant de toucher le sol, le saut s'enchaîne au contact
- Gravité asymétrique : tombe légèrement plus vite qu'elle ne monte (sensation de poids)

## Graphismes
- Sprite stable, pas de vibration / palpitation d'idle (décision prise — l'effet n'est pas voulu)
- Trainée de particules très discrète à la marche / sprint
- À l'atterrissage : petit éclat de particules au point de contact
- Au dash : signature visuelle dédiée (cf. Objectif 7)

## Son
- Pas de bruit de pas — Zell n'a pas de pieds
- Bourdonnement très doux et continu en mouvement
- Saut : souffle court
- Atterrissage : pulse grave très bref

---

# OBJECTIF 2 — Caméra

> **État : ✅ implémenté** côté logique (suivi lissé, look-ahead horizontal, zone morte verticale, méthode `shake()` prête). La parallaxe attend les assets de zone.

## Ressenti joueur
La caméra doit se faire oublier. Elle anticipe légèrement les intentions du joueur sans jamais le surprendre. Elle donne de l'espace en plateforme, et resserre en combat / cinématique.

## Comportement
- Suivi avec un léger délai (lerp doux, pas de snap dur)
- **Look-ahead** horizontal : la caméra se décale dans le sens du déplacement quand Zell court
- Zone morte verticale : la caméra ne suit pas les petits sauts, seulement les gros changements d'altitude
- Limites de zone définies scène par scène
- **Camera shake** très mesurée : impacts forts uniquement (mort d'un ennemi gros, dégâts boss, atterrissage de haut)
- Option d'accessibilité : réduction / désactivation du shake

## Graphismes
- Parallaxe sur les arrière-plans : 2 à 4 couches selon la zone
- Effet de profondeur via blur léger sur le fond le plus lointain (cohérent avec le "dessin animé flou")

---

# OBJECTIF 3 — Système de vie et de cohérence

> **État : ✅ implémenté** (5 flammèches orbitales, iframes 0.7s avec clignotement, debug F1/F2). Les sons attendent les assets audio. La dégradation détaillée du sprite (table ci-dessous) est représentée pour l'instant uniquement par la perte de flammèches — les états visuels du Core viendront avec les sprites finaux faits main.

## Ressenti joueur
Zell est pure conscience. Sa santé est sa **cohérence**. Plus elle est blessée, plus elle se désintègre visuellement. Pas de barre de vie criarde — l'information vit dans le sprite.

## Comportement
- **5 PV de base** (5 paliers visibles)
- À chaque coup pris : iframes courtes (0.7s) avec clignotement du sprite
- HP de base augmentables via upgrades dans le jeu : chaque upgrade ajoute **un satellite supplémentaire** (1 satellite = 1 PV, lecture toujours nette)

## Graphismes — l'état du sprite EST l'UI
| Santé | Apparence de Zell |
|---|---|
| 100% | Sphère nette, gradient blanc-or-ambré, glow stable |
| 75% | Bords plus dispersés, particules flottantes autour |
| 50% | Forme moins définie, plus ambrée que blanche, particules qui dérivent |
| 25% | Centre minuscule, presque entièrement particules |
| Critique | Tremblante, à peine maintenue ensemble, glow vacille |

## Son
- Coup pris : son sourd et étouffé, comme un cœur qui rate un battement
- État critique : un souffle bas et continu se superpose à la musique
- Soin / récupération : tintement cristallin doux

## Indicateur — Satellites en orbite (décision tranchée)
- 5 petites **flammèches ambrées** gravitent autour de Zell, à courte distance (hors de son aura)
- Chaque flammèche = 1 PV. À chaque coup pris, la dernière s'éteint et se dissipe
- Lecture immédiate et non-criarde, cohérente avec "Zell = conscience tenue ensemble par son énergie"
- Quand une flammèche passe DEVANT Zell (sens du déplacement), sa traînée se réduit pour ne pas empiéter sur le chara design ; elle reprend sa traînée normale dès qu'elle revient derrière
- En Phase 2 (Zell humanoïde) : les flammèches continuent d'orbiter autour de sa nouvelle forme — pas de refonte visuelle

---

# OBJECTIF 4 — Système de combat à l'épée

## Ressenti joueur
Chaque coup d'épée doit "claquer". Pas un balayage mou. C'est une décharge d'énergie qui sort de Zell, brève et nette. Le rythme du combat est lent au début (1-2 coups, repli), s'intensifie avec les upgrades.

## Contrôles
- Touche d'attaque dédiée
- Attaque possible à l'arrêt, en marche, en saut, en chute
- Direction de l'attaque : par défaut dans le sens du regard ; possibilité de frapper en haut ou en bas avec une combinaison touche directionnelle + attaque
- **Pas de combo enchaîné préfabriqué** : chaque attaque est indépendante, avec un petit cooldown anti-spam (~0.25s)
- Le mouvement reste libre pendant l'attaque (pas de root)

## Comportement
- L'épée est une hitbox active pendant ~0.15s
- Knockback léger sur les petits ennemis touchés
- **Pogo** : knockback de Zell vers le haut quand elle frappe vers le bas en l'air (rebond sur ennemi) — à valider lors du prototypage
- PV ennemi visible par leur état visuel (cf. Objectif 12), pas via barre de vie

## Graphismes
- Lame courte au début, blanc-or, légèrement translucide
- Sillage de lumière qui se dissipe en 0.2s après le swing
- À chaque upgrade, l'épée évolue visuellement (cf. Objectif 14)
- Impact : flash blanc bref sur l'ennemi touché + particules dorées
- Le swing change de direction proprement (haut, bas, côté)

## Son
- Swing : sifflement aérien, court
- Impact : son cristallin + petit grésillement électrique
- Coup raté (dans le vide) : son plus mat, plus court — récompense la précision

---

# OBJECTIF 5 — Coup de Jus (mécanique signature)

## Ressenti joueur
Le Coup de Jus est l'arme de contournement. Quand un ennemi devient trop dangereux, on accumule de la pression en le frappant, et au bon moment on lâche un coup qui le **désarme**. L'ennemi désarmé devient pitoyable : il court chercher son arme, vulnérable. Ce moment de tension — "je l'achève ou je fuis ?" — est l'identité du combat.

## Contrôles
- Touche dédiée pour déclencher le Coup de Jus (différente de l'attaque normale)
- Ne se déclenche que si la **jauge de Jus** est pleine

## La jauge de Jus
- Se remplit en frappant les ennemis (chaque coup normal = +X% de jauge)
- Visible discrètement à côté de Zell ou intégrée à son sprite (à valider visuellement)
- Une fois pleine : Zell pulse différemment, signal clair que c'est disponible
- Se vide entièrement à l'utilisation

## Comportement contre ennemis ordinaires
- Désarme : l'arme tombe au sol, l'ennemi cesse d'attaquer et tente de la récupérer
- Pendant qu'il court : il est vulnérable, ses attaques sont neutralisées
- L'ennemi désarmé peut redevenir dangereux si on le laisse récupérer son arme
- Zell ne peut **pas** ramasser l'arme tombée

## Comportement contre les boss
- Pas de désarmement (les boss n'ont pas "d'arme")
- Inflige des **dégâts électriques importants**
- Utilisation tactique : à garder pour les bonnes phases

## Cas spéciaux
- **Les Braises** (Émotions, Colère) et **Les Bactéries** (Bouche) se divisent en deux au coup d'épée normal. Seul le Coup de Jus les détruit sans division. Logique gameplay forte qui force à choisir entre éliminer vite ou conserver la jauge.

## Graphismes
- Au déclenchement : flash électrique bleu-blanc autour de Zell, arc d'énergie qui rejoint l'ennemi
- L'arme désarmée scintille au sol jusqu'à être reprise
- L'ennemi désarmé a un visuel altéré (postérieur penaud, particules de désorientation)

## Son
- Charge de jauge : bourdonnement qui monte d'intensité à mesure qu'elle se remplit
- Pleine : bip cristallin de validation
- Utilisation : crack électrique sec, court mais marquant

---

# OBJECTIF 5 bis — Refroidissement (capacité innée)

## Ressenti joueur
Zell n'a pas besoin de chercher cette capacité — elle naît avec. **Baisser son émission**, devenir froide et discrète. Le joueur doit sentir que c'est un **compromis** : on disparaît à la vue, mais on consomme une ressource limitée. Pas une furtivité gratuite.

## Déblocage
- **Innée.** Disponible dès l'éveil de Zell, avant même le premier fragment.

## Contrôles
- Touche dédiée (toggle ou maintien — à trancher pendant le prototypage)
- Tant que le Refroidissement est actif, une **jauge** se vide progressivement
- À l'arrêt complet, la jauge se recharge

## Comportement
- Zell baisse son glow chaud (ambre / blanc) → transparence bleu-violet froide
- **Les créatures qui pistent à la vue la perdent.** (Ex. : la Grosse Boule, voir Objectif 12.)
- **Inutile contre les créatures qui pistent au son** (ex. les Aveugles) : la furtivité visuelle n'a aucun effet sur elles.
- Pas d'usage offensif, pas d'interaction avec l'environnement (purement défensif / d'évasion)
- Le déplacement reste disponible pendant l'invisibilité (mais consomme la jauge)

## Graphismes
- Transition fluide du glow chaud (ambre/or/blanc) vers une transparence bleu-violet froide
- Le sprite reste visible pour le joueur (semi-transparent) — c'est juste les ennemis qui ne le voient plus
- Légère vibration / pulsation froide autour de Zell

## Son
- Activation : souffle froid, descendant
- Boucle d'ambiance discrète tant qu'actif (drone froid très doux)
- Désactivation / vidage de jauge : remontée du son chaud habituel

---

# OBJECTIF 6 — Impulsion (1er fragment du tuto)

## Ressenti joueur
Une expiration de lumière. Zell se concentre, émet une impulsion électrique, et une onde radiale **révèle** ce qu'on ne voyait pas. **Perception pure, zéro dégât.** Le joueur l'utilise comme un sonar — par réflexe d'exploration, jamais comme attaque. Un usage offensif reste envisageable plus tard, mais n'est pas prévu.

## Déblocage
- **1er fragment de souvenir** récupéré dans Les Yeux (zone tuto). Pas innée.

## Contrôles
- Touche dédiée
- **3 charges** disponibles, visibles très discrètement
- Les charges se rechargent :
  - En touchant un neurone-checkpoint
  - En **méditant** (rester immobile quelques secondes, notamment en Zone Paisible — cf. Objectif 23 / mécanique de méditation)

## Comportement
- Onde circulaire qui s'expand sur ~1.5s puis se dissipe
- **Aucun dégât, aucun stun.** Effets exclusivement de révélation :
  - Ennemis cachés ou invisibles (Effacés de La Mémoire, Vide de L'Oubli, etc.)
  - Fausses parois, salles secrètes
  - Pièges
  - Collectibles cachés
  - Vrai chemin dans les zones d'illusion (Zone de Rêve)
- Peut activer certains mécanismes contextuels (interrupteurs lumineux qui réagissent à l'onde, à confirmer au cas par cas)
- Pas d'amélioration prévue dans la progression : capacité stable de bout en bout

## Implication design tuto
- Le tuto (Les Yeux) doit **semer pièges, fausses parois et salles cachées** pour donner une utilité immédiate à l'Impulsion. Sans contenu à révéler, elle n'a aucun usage.

## Graphismes
- Anneau bleu-doré qui s'élargit en perdant en opacité
- Effet de léger ralenti visuel autour de Zell pendant la fraction de seconde du tir
- Sur les murs cachés / pièges / passages : la matière réagit par un scintillement subtil le temps de l'onde

## Son
- Pulse profond, comme un gong étouffé
- Ralenti dans le son ambiant pendant 0.3s après l'utilisation
- Validation cristalline si quelque chose a été révélé

---

# OBJECTIF 7 — Dash (2e fragment, en deux parties)

## Ressenti joueur
À retravailler côté ressenti — dash classique ou mini-téléportation ? À trancher au prototypage. Dans tous les cas : sensation d'instantané, pas de glissé.

**Le Dash remplace définitivement l'ancienne idée du double saut.** Il se déverrouille en **deux parties** :
- **Partie horizontale** : 2e fragment du tuto (Les Yeux)
- **Partie verticale** : déblocage en **Phase 1**, ouvre la verticalité du monde

Conséquence : tant que le joueur n'a pas la verticale, **certaines zones du tuto restent inaccessibles**. Le backtracking est optionnel et ne bloque jamais la progression.

## Contrôles
- Touche dédiée
- Direction : sens du déplacement horizontal par défaut, ajout de la direction verticale une fois l'upgrade obtenue
- Cooldown court

## Comportement
- Trajet quasi-instantané sur une distance fixe
- iframes pendant le dash (à valider)
- Ne permet pas de traverser les murs solides — uniquement les hitbox d'ennemis ou de projectiles
- Sert aussi à **traverser les Filaments** (ennemi-obstacle des Yeux)

## Graphismes
- Au départ : Zell se désagrège en particules sur ~0.05s
- Sillage en pointillés lumineux entre point de départ et point d'arrivée
- À l'arrivée : recomposition en flash bref
- L'afterimage (silhouette résiduelle) reste 0.3s au point de départ — utilisable pour des puzzles (cf. Objectif 23, Sillage de Conscience)

## Son
- Bzzt court et net au départ
- Retour de l'air à l'arrivée, plus subtil

---

# OBJECTIF 8 — Système de mort et de respawn

## Ressenti joueur
La mort n'est pas punitive — elle est narrative. Zell se disperse, se laisse aller, se reforme. Le joueur perd des Synapses au point de mort, peut les récupérer. Pas de Game Over écran rouge, pas d'humiliation. Juste un moment de pause et un nouveau départ.

## Comportement
- À la mort : Zell éclate en particules au point de mort
- Ses Synapses restent en un petit amas lumineux au sol
- Elle se reforme au dernier neurone activé
- Retourner au point de mort = récupérer les Synapses
- Mourir à nouveau avant de les récupérer = pertes définitives
- **Filet de sécurité** : 10% des Synapses sont automatiquement épargnées à chaque neurone activé — plancher garanti
- Pas de limite de morts, aucune pénalité permanente
- Les ennemis respawnent à la mort de Zell **ou** uniquement après un repos au neurone (à trancher pendant les tests)

## Écho de Mort
- À l'endroit de la mort, une silhouette fantôme rejoue brièvement les derniers instants (3-5s en boucle, semi-transparent)
- Aide le joueur à comprendre ce qui l'a tué
- S'efface dès que Zell récupère ses Synapses

## Graphismes
- Désintégration en particules dorées qui montent lentement vers le haut
- Petit halo permanent au point de mort jusqu'à récupération
- Recomposition au neurone : particules qui convergent au centre, prennent forme

## Son
- Mort : grande inspiration suspendue, puis silence
- Recomposition au neurone : pulse de cœur, doux

---

# OBJECTIF 9 — Synapses (monnaie)

## Ressenti joueur
Les Synapses sont les connexions du cerveau. Les ramasser est satisfaisant — chaque petit cristal qu'on absorbe pulse une fois, comme un mini cœur. Elles ne sont JAMAIS rares au point d'être stressantes ; elles tombent souvent, mais leur valeur croît avec les achats importants.

## Comportement
- Drop sur ennemi (quantité variable selon difficulté de l'ennemi)
- Drop dans zones cachées et coffres
- Récompenses ponctuelles de certains PNJ
- Dépensables chez :
  - Marchands (cartes, objets, fragments)
  - Forgeron Filin (upgrades épée)
  - Certains passages "neuraux" scellés
  - Réparation de neurones endommagés (avant activation)
- Compteur visible discrètement (coin d'écran, désactivable)

## Graphismes
- Petits cristaux bleu-blanc qui flottent et tournent doucement
- Magnétisme : à courte distance, elles convergent vers Zell d'elles-mêmes
- À la collecte : petit flash + son court

## Son
- Collecte : tintement cristallin, plus aigu pour les petites, plus grave pour les grosses

---

# OBJECTIF 10 — Neurones (checkpoints et sauvegarde)

## Ressenti joueur
Un point de calme. Un endroit où Zell peut respirer. S'asseoir près d'un neurone, c'est s'ancrer dans un lieu — comme une grâce dans Elden Ring, un banc dans Hollow Knight. La musique change légèrement à proximité, l'écran s'éclaire un peu plus.

## Comportement
- Activable une fois trouvé : Zell s'approche et appuie sur la touche d'interaction
- Sauvegarde automatique du jeu à chaque activation
- Recharge les PV au complet
- Recharge les 3 charges d'Impulsion
- Définit le point de respawn
- Verrouille les 10% de Synapses (filet de sécurité)

## Action "se reposer"
- Le joueur peut choisir de se reposer (touche dédiée)
- Le repos respawn tous les ennemis vaincus de la zone
- Le repos rouvre l'accès aux marchands et services
- Le repos est nécessaire pour utiliser certains services (forge, archives)

## Neurones endommagés
- Certains neurones ne sont pas activables immédiatement — il faut d'abord payer en Synapses pour les "réparer"
- Force le joueur à prioriser et à explorer

## Graphismes
- Petit nœud lumineux, blanc-bleu, qui pulse au rythme d'un battement de cœur lent
- Quand activé pour la première fois : le neurone s'allume définitivement, son halo s'étend
- Filaments d'énergie qui s'étendent vers les neurones connectés (visibles uniquement de près)

## Son
- Pulse lent et grave, audible uniquement à proximité
- À l'activation : grand pulse cristallin, puis le pulse de fond s'ancre dans la musique de zone

---

# OBJECTIF 11 — Transitions entre zones

## Ressenti joueur
Passer d'une zone à l'autre doit être un seuil franchi, pas un loading screen. Le joueur doit sentir qu'il a quitté un endroit ET qu'il entre dans un autre. Pas de coupure brutale.

## Comportement
- Trigger zone à un point précis de la carte (porte, passage, faille)
- À l'entrée du trigger : fondu doux vers une couleur (généralement noir ou la couleur dominante de la zone d'arrivée)
- Chargement de la nouvelle scène en arrière-plan
- Apparition de Zell dans la zone d'arrivée à un point équivalent (sortie symétrique)
- Fondu de sortie progressif
- La musique de la zone d'origine se fond dans la musique de la zone d'arrivée (crossfade ~2s)

## Persistance
- État du joueur (PV, jauge de Jus, Synapses, capacités) : conservé
- Ennemis vaincus : conservés morts dans la zone qu'on quitte jusqu'à un repos au neurone
- Objets collectés : permanents
- Position du joueur dans la zone qu'on quitte : non sauvegardée (on n'y revient pas à la même position, on revient par la porte)

## Cas spécial : Les Sinus
- Zone de transition centrale (rôle de Dirtmouth)
- Permet d'accéder à toutes les zones principales
- Contient au moins un marchand (cartes, objets de base — un Solin)
- Ambiance sobre, calme, ni triste ni gaie — un sas

## Graphismes
- Fondu visuel doux, jamais de noir total instantané
- Légère vibration de l'écran pendant la transition (sensation de seuil)

## Son
- Aspiration brève, comme un passage de pression
- Le son ambiant de la zone d'origine se voile, celui de la zone d'arrivée s'ouvre

---

# OBJECTIF 12 — Système d'ennemis génériques

## Ressenti joueur
Chaque ennemi a un comportement lisible. Le joueur doit pouvoir le comprendre en 1-2 rencontres. Aucun ennemi n'est gratuitement frustrant. Tous ont une logique cohérente avec leur design — ils ne sont jamais fondamentalement "mauvais", chacun a une origine narrative implicite.

## Architecture demandée (sans code, juste consigne)
- Un seul "type d'ennemi" comme template, qui lit ses données depuis une **ressource** (PV, vitesse, dégâts, sprite, comportement, drop)
- Ajouter un nouvel ennemi = créer une nouvelle ressource, pas écrire de nouveau script
- Comportements en machine à états : patrouille, détection, attaque, fuite (Coup de Jus), retour

## Comportements de base à supporter
- **Patrouille** : va-et-vient simple sur une plateforme
- **Détection** : trigger de vue / proximité / vibration (selon ennemi)
- **Charge** : fonce sur Zell quand détectée
- **Ranged** : projectiles à distance
- **Division au coup** : se divise en deux (Bactéries, Braises) — neutralisable au Coup de Jus
- **Désarmé** : court chercher son arme (pour les ennemis armés)
- **Invisible** : ne s'affiche qu'à l'Impulsion ou par contour (Effacés, Vide)
- **Mort** : animation + drop de Synapses

## Visualisation des PV
- Pas de barre de vie au-dessus
- État visuel altéré quand l'ennemi est blessé (fissures, particules qui s'échappent, lumière interne qui faiblit)
- À 1 coup de la mort : tremblement subtil

## Ennemis exclusifs à leur zone (par défaut)
- Pas de réutilisation entre zones sauf cas justifié
- Chaque ennemi a une origine narrative implicite (cohérente avec sa zone)

## Pacification / amitié
- Pas pacifiables par défaut
- Si une amitié avec un ennemi est prévue dans le lore, elle est scriptée à l'avance pour cet ennemi en particulier

## Effets de contact spécifiques
- Certains ennemis ne font pas que des dégâts directs : ils ralentissent (Filaments, Larmes), distordent l'écran (Formes), effacent temporairement la carte (Effacés)

## Ennemis du tuto — pédagogie par opposition
Les deux archétypes principaux de la zone tuto (Les Yeux) sont conçus en **contraste de sens** : ils enseignent au joueur à lire la détection avant de réagir.

- **La Grosse Boule** — gros mob lent, énormes yeux, bouche béante, **sourd**. Détecte exclusivement à la **vue**. Le bruit ne l'alerte jamais.
  → **Contrée par le Refroidissement** (cf. Objectif 5 bis) : Zell devient invisible à la vue, peut traverser librement.
- **Les Aveugles** — petits, ailés, métissage chauve-souris (façon Zubat) / fantôme. Yeux troués, **oreilles exagérément grandes**. Pistent au **son et à la vibration**. **Arrivent en meute.**
  → **Contrés par l'immobilité ou le déplacement lent.** Le Refroidissement est sans effet sur eux.

Implication design : les deux demandent des **réponses opposées** (devant l'un on se cache, devant l'autre on se fige). Toute salle qui mélange les deux devient un puzzle de gestion de présence.

**Les Filaments** (toujours dans Les Yeux) restent un simple obstacle de traversée — fils de lumière à couper à l'épée ou à franchir au dash.

---

# OBJECTIF 13 — Système de boss

## Ressenti joueur
Chaque boss est un moment. Un boss n'est jamais un sac à PV — il a des phases, une présence visuelle, une intention narrative. Le joueur doit sortir du combat avec une **émotion**, pas avec un sentiment de checklist accomplie.

## Architecture
- Boss = scène dédiée avec son propre script
- Phases scénarisées (généralement 3 phases pour les principaux)
- Transitions de phases marquées : pause visuelle, changement de musique, modification d'arène possible
- État du boss visible dans son apparence (cf. Objectif 12 mais amplifié)

## Patterns
- Chaque boss a 3-5 patterns distincts, lisibles à l'œil
- Les patterns deviennent plus complexes / superposés au fil des phases
- Toujours une fenêtre d'attaque claire entre les patterns
- Certains boss ont des **mécaniques uniques** qui ne réapparaissent nulle part ailleurs (le Filtre coupe des sons, le Vide est invisible, le Double retient au lieu de frapper, le Cœur EST l'arène)

## Drops
- **Boss principal** : un souvenir important (lore + parfois capacité) + spell éventuel
- **Boss secondaire** : Synapses, fragments mineurs, parfois matériau rare pour l'épée
- Le drop apparaît au centre de l'arène en lévitation, à collecter en s'approchant

## Coup de Jus sur boss
- Pas de désarmement
- Inflige des dégâts électriques importants
- Utilisation tactique : à garder pour les bonnes phases

## Mini-boss = unlock du fast travel
- Un mini-boss spécifique (à définir narrativement) débloque la capacité d'utiliser le réseau neuronal (cf. Objectif 17)

## Graphismes
- Chaque boss a son propre langage visuel (cf. Structure_et_idées pour les détails par boss)
- Arène thématisée à la zone
- Transitions de phase = moment cinématique court (1-2s, pas un cutscene complet)
- Certains boss peuvent **modifier leur arène** entre les phases (couleurs, géométrie, gravité)

## Son
- Musique dédiée par boss (ou par phase)
- Sons d'attaque distincts pour chaque pattern
- Silence absolu sur certains moments-clés (Phase 2 du Cœur — l'Arrêt)

## Boss du tuto — Le Chevalier Cristallin
*Nom à confirmer. Premier vrai combat du jeu et tuto de maniement de l'épée (attaques + esquive au dash).*

**Ce n'est pas un combat qu'on gagne désarmé.** C'est une **épreuve de valeur** qui arme Zell, puis un duel loyal. Détails narratifs et mise en scène dans `Structure_et_idées.md`.

**Spécification système** :
- L'arène contient au centre une **Excalibur** plantée dans un rocher de chair (objet interactif), et à droite un **Chevalier sur un trône** (NPC inactif au démarrage).
- À l'entrée du joueur : déclenche un dialogue / mise en scène où le Chevalier invite Zell à tenter de retirer l'épée.
- Quand le joueur interagit avec l'épée : animation d'extraction, l'épée devient disponible dans l'inventaire d'arme.
- Cela déclenche la transition du Chevalier de NPC à boss : il se lève, la musique change, le combat commence.
- Trois patterns minimum pour entraîner aux fondamentaux : attaques que le joueur doit **bloquer ou esquiver au dash**, et fenêtres claires pour contre-attaquer.
- **Pas de talk-no-jutsu sur ce boss** (cette mécanique est reportée à un boss de Phase 1).

**Drop / récompense** :
- L'épée d'énergie est déjà obtenue avant le combat. La récompense est le combat lui-même + une **aura propre** ajoutée à l'épée après la victoire (signature visuelle distinctive).
- Animation d'obtention finale : le Chevalier s'incline ou se dissout.

**Clé du tuto** : l'épée du Chevalier sert ensuite de **clé** pour la porte scellée du spawn. Pas de clé séparée — l'arme et la clé sont une seule et même chose. L'ouverture de cette porte donne accès à la Phase 1.

---

# OBJECTIF 14 — Système d'upgrades de l'épée

## Ressenti joueur
L'épée doit grandir avec le joueur. Chaque upgrade est visible, audible, **sentie**. Le joueur doit pouvoir dire "ma lame est plus longue maintenant" sans regarder une fiche.

## Comportement
- 5 niveaux d'upgrade au total
- Les 4 premiers : améliorations libres (portée ×2, dégâts ×2, dans l'ordre choisi par le joueur)
- 5ᵉ niveau : **paralysie** — débloque uniquement à la fin, quand toutes les autres upgrades sont prises
- Chaque upgrade coûte des Synapses + un matériau rare propre à une zone (force l'exploration, cf. Objectif 15)
- L'upgrade 5 demande **les 4 matériaux des zones** (preuve d'exploration complète)

## Évolution visuelle de la lame
| Niveau | Apparence |
|---|---|
| Base | Lame courte, blanc-or, propre |
| Upgrade 1 | Visiblement plus longue |
| Upgrade 2 | Plus lumineuse, bordure ambré-orange |
| Upgrade 3 | Très longue, sillage bref à chaque swing |
| Upgrade 4 | Intense, crépitante, audible avant d'être vue |
| Upgrade 5 | Pointe bleu électrique, trois couleurs, flash blanc-bleu à chaque swing |

## La paralysie (niveau 5)
- Très courte durée (~1.5s)
- Énorme consommation d'énergie / cooldown long
- Visuellement spectaculaire : l'ennemi est figé dans un cristal d'énergie bleu

## Lieu de l'upgrade
- **Filin**, le forgeron PNJ, dans la Zone des Câbles
- Interaction simple : interface qui montre les niveaux, le coût, le matériau requis
- L'upgrade nécessite un repos au neurone le plus proche

---

# OBJECTIF 15 — Matériaux rares

## Ressenti joueur
Chaque matériau rare est lié à une zone précise. Le joueur ne peut pas tout upgrade en restant dans le même biome — il doit explorer. Trouver un matériau rare est un moment "ah, c'est pour ça". On comprend rétroactivement la valeur d'un détour.

## Comportement
- 4 matériaux rares, un par zone majeure de Phase 1
- Chaque matériau correspond à un upgrade épée spécifique (cf. Objectif 14)
- L'upgrade 5 (paralysie) demande les 4 matériaux à la fois
- Drop par : ennemis forts spécifiques d'une zone, coffres cachés, récompenses de boss secondaires

## Matériaux prévus
| Upgrade | Coût Synapses | Matériau | Provenance |
|---|---|---|---|
| 1 — Range | 100 | Cristal de Mémoire | La Mémoire (salles cachées) |
| 2 — Dégâts | 200 | Filament d'Énergie | Zone des Câbles (le long des câbles) |
| 3 — Range ×2 | 350 | Fragment de Rêve | Zone de Rêve (collectibles éthérés) |
| 4 — Dégâts ×2 | 500 | Éclat d'Émotion | Les Émotions (ennemis forts) |
| 5 — Paralysie | 750 | Les 4 matériaux ×1 chacun | Avoir tout exploré |

## Graphismes
- Chaque matériau a sa signature visuelle (couleur, forme, glow)
- Visibles dans l'inventaire (cf. Objectif 25)
- Au ramassage : animation d'absorption plus marquée qu'une Synapse simple

---

# OBJECTIF 16 — Système de spells

## Ressenti joueur
Chaque spell change la façon dont le joueur **lit la map**. Un spell n'est jamais "juste une attaque" — c'est une nouvelle façon de comprendre le monde. Trouver un spell, c'est trouver une nouvelle paire d'yeux.

## Architecture
- Chaque spell est un module autonome (scène + ressource de données)
- Le moveset de Zell les déclenche via un système de slots, pas via du code spécifique par spell
- Ajouter un spell = créer un nouveau module, sans toucher au reste

## Spells prévus

**Tuto (Les Yeux)** — Zell sort de la zone tuto avec **3 capacités max** :
- **Refroidissement** (inné, cf. Objectif 5 bis) — invisibilité à la vue, jauge qui se vide / se recharge à l'arrêt.
- **Impulsion** (1er fragment, cf. Objectif 6) — perception pure, zéro dégât.
- **Dash** (2e fragment, cf. Objectif 7) — partie horizontale au tuto, partie verticale en Phase 1.

**Phase 1 et au-delà** — d'autres capacités viennent enrichir le moveset :
- **Fusion du Métal** : détruit chaînes, cadenas, obstacles métalliques. Droppé par le boss de La Mémoire. Donne accès à la Salle des Souvenirs.
- **Réseau Neuronal** : fast travel entre neurones (cf. Objectif 17).
- **Coup de Jus** (cf. Objectif 5) — disponible quand l'épée est obtenue, monté en jauge par les coups portés.
- Autres spells à ajouter au fil du développement si des idées émergent.

**Capacités abandonnées** : double saut, saut mural, plané, 3e spell un temps envisagé (le dash vertical reprend ce rôle de verticalité supplémentaire).

## Contrôles
- Touche de spell dédiée (ou roue de sélection si plusieurs spells, à voir)
- Cast instantané ou tenu selon le spell

## Graphismes
- Chaque spell a sa signature visuelle propre
- Animation de cast brève (~0.3s)
- Effet visuel sur la cible / l'environnement net et lisible

---

# OBJECTIF 17 — Fast travel (Réseau Neuronal)

## Ressenti joueur
Le réseau neuronal est l'autoroute du cerveau. Une fois compris, il transforme l'exploration. Mais il ne se donne pas : il se mérite.

## Déblocage en deux temps
1. **Premier déblocage** : battre un mini-boss spécifique (à définir narrativement) — débloque la capacité d'utiliser le réseau
2. **Extension** : chaque neurone activé devient un point d'entrée/sortie du réseau

## Comportement
- Depuis n'importe quel neurone activé, accès à une carte du réseau
- Sélection d'un autre neurone activé = téléportation
- Le voyage prend ~2-3 secondes (animation visuelle, pas un cut sec)
- Zell apparaît au neurone de destination, ses PV et charges sont rechargés

## Zones non desservies
- La Bouche, les Oreilles, les zones de chair pures : pas dans le réseau
- Ces zones ont quand même des neurones-checkpoints, mais pas le fast travel

## Nœuds Neuronaux Cachés
- Neurones secrets disséminés dans le jeu
- Activés, ils étendent le réseau au-delà du chemin standard
- Récompense d'exploration approfondie

## Graphismes
- Pendant le voyage : Zell devient un éclair qui voyage le long de filaments lumineux
- Vue stylisée du réseau (carte semi-abstraite)
- Arrivée : pulse de lumière, recomposition

## Son
- Au départ : grand vrombissement électrique
- Pendant : sifflement continu en hauteur
- Arrivée : décélération, silence, ambiance de la nouvelle zone

---

# OBJECTIF 18 — PNJ et dialogues

## Ressenti joueur
Les PNJ savent qui est Veilae. Mais ils ne le lui disent jamais. Ils parlent par énigmes, sous-entendus, fragments. Certains agissent comme s'ils la connaissaient depuis toujours. Le joueur sent qu'il manque des pièces — c'est normal, c'est le sujet du jeu.

## Comportement général
- Tous les PNJ sont stationnaires (sauf Écho qui erre aléatoirement)
- Interaction par touche dédiée à proximité
- Dialogue en boîte de texte simple, **pas de voix humaine**
- Chaque PNJ a un son de voix abstrait (bourdonnement, cliquetis, réverbération...)
- **Non tuables** sauf si leur mort est scriptée dans le lore

## PNJ récurrents (à étendre au fil du développement)
| PNJ | Rôle | Lieu | Signature sonore |
|---|---|---|---|
| Solin | Gardien des neurones, marchand | Plusieurs zones, dont Les Sinus | Bourdonnement grave et calme |
| Mémo | Archiviste, accès aux souvenirs | La Mémoire | Cliquetis staccato, frénétique |
| Écho | Errant fragmenté, indices cryptiques | Aléatoire | Réverbération longue |
| Filin | Forgeron, upgrades épée | Zone des Câbles | Grondement mécanique |
| Gardiens silencieux | Dons de soin/Synapses si Zell s'arrête | Zone Paisible | Silence — ils ne parlent pas |
| Veille | Révélation tardive sur Veilae | L'Oubli | Voix lente, similaire à Zell |

## Dialogues
- Externalisés dans des fichiers (JSON ou ressources Godot) — réécriture sans toucher au code
- Branches simples possibles (réponse A / réponse B), pas un système RPG complexe
- Préparer le système pour la traduction multi-langues

## Graphismes
- Chaque PNJ a une identité visuelle forte et distincte
- Animations idle douces (respiration, oscillation)
- Pendant le dialogue : un léger zoom de caméra, le reste du décor s'assombrit légèrement

## Réactions par phase
- Certains PNJ changent leurs dialogues entre Phase 1 et Phase 2
- L'évolution de Veilae (boule → humanoïde) modifie subtilement leur ton, parfois leur attitude

---

# OBJECTIF 19 — Marchands

## Ressenti joueur
Acheter quelque chose à un marchand de ce monde doit ressembler à un troc avec un esprit étrange. Pas un supermarché. Le marchand est un PNJ avant d'être une boutique.

## Comportement
- Interface d'achat sobre : liste d'objets disponibles, prix en Synapses, description courte
- Un objet acheté disparaît du stock (sauf consommables qui peuvent revenir après un repos au neurone)
- Possibilité d'avoir des objets "débloqués par progression" qui apparaissent au fil du jeu

## Marchand minimum requis
- **Au moins un Solin dans Les Sinus** : vend des fragments de carte (révèle des zones voisines) et des objets de soin basiques

## Graphismes
- Pas d'écran de boutique style RPG classique
- Interface intégrée à l'environnement (un comptoir, des cristaux flottants, le marchand qui montre l'objet)
- Hover sur un objet = il s'illumine, son nom apparaît

## Son
- Cliquetis cristallin à chaque sélection d'objet
- Validation d'achat : pulse satisfait
- Annulation / pas assez de Synapses : son mat, court

---

# OBJECTIF 20 — Souvenirs et progression de Zell

## Ressenti joueur
Chaque souvenir trouvé est un petit moment de vertige. Zell touche quelque chose qui appartient à Veilae, l'absorbe, et **devient un peu plus**. Visuellement, son corps change : un bras apparaît, des jambes se forment. Mécaniquement, une nouvelle capacité s'ouvre.

## Structure des souvenirs
- Chaque souvenir est une **ressource** contenant : texte, image / scène mémoire jouable, son, qui le drop, ce qu'il débloque
- 4 souvenirs structurants dans Les Yeux (cf. ci-dessous)
- D'autres souvenirs disséminés dans toutes les zones, **importance variable selon les boss qui les drop**

## Les 4 souvenirs des Yeux (tutoriel)
| Souvenir | Manifestation | Capacité |
|---|---|---|
| Souvenir de frapper | Bras droit doré | Épée d'énergie |
| Souvenir de marche | Jambes de lumière | Dash / mini-téléportation |
| Souvenir de tomber | Jambes renforcées | Double saut |
| Souvenir d'atteindre | Bras gauche | Grimper / interagir |

## Micro-cinématique d'absorption
- Zell s'approche du souvenir suspendu
- Le souvenir l'entoure, des particules convergent
- La partie du corps correspondante se matérialise sur Zell (3-4 secondes)
- Petit flash blanc, retour au gameplay

## Souvenirs des autres zones
- Souvenirs **majeurs** (boss principaux) : lore important + parfois capacité
- Souvenirs **mineurs** (boss secondaires, exploration) : lore uniquement
- Tous consultables depuis la Salle des Souvenirs (cf. Objectif 21)
- Contenu narratif : moments de la vie de Veilae — pas forcément liés à l'accident. Heureux, douloureux, simples, complexes. Mystérieux par accumulation.

## Évolution vers Phase 2
- Quand tous les souvenirs majeurs de Phase 1 sont collectés : grand flash blanc, transition cinématique courte
- Zell prend sa forme humanoïde — progression visuelle progressive, pas un changement instantané

---

# OBJECTIF 21 — Salle des Souvenirs (Mémoire)

## Ressenti joueur
Un sanctuaire. Un endroit calme, presque muséal, où Zell peut revoir tout ce qu'elle a retrouvé. Le joueur s'y arrête comme on s'arrête dans une bibliothèque. Pas obligatoire, mais profondément satisfaisant.

## Comportement
- Pièce située dans la zone La Mémoire
- Accessible une fois le spell de Fusion du Métal débloqué (chaînes à briser)
- À l'intérieur : des cristaux flottants représentent chaque souvenir collecté
- Interaction sur un cristal = rejoue le souvenir (texte, scène, son)

## Une mécanique pour y revenir
- À définir : une raison gameplay régulière de revisiter cette salle
- Piste possible : certains souvenirs ne révèlent leur lore complet qu'avec d'autres (combos de souvenirs adjacents qui dévoilent une histoire commune)

## Phase 2 — Le Double
- En Phase 2, les souvenirs apparaissent en mode "Error" rouge, brouillés
- Le combat contre le Double restaure (ou pas — à voir) les souvenirs
- Le Double habite cette salle en Phase 2

## Graphismes
- Salle baignée d'une lumière dorée douce
- Cristaux qui flottent et tournent lentement
- Sélectionné, un cristal grandit, projette son contenu autour de la salle

## Son
- Silence presque total, juste un hum très bas
- Pendant la lecture : la musique du souvenir (différente par souvenir)

---

# OBJECTIF 22 — Puzzles environnementaux

## Ressenti joueur
Les puzzles ne sont jamais des "puzzles de jeu" — ce sont des **moments d'interaction avec le monde**. Chaque type de puzzle est lié à une zone et à son ambiance. Le joueur n'a pas l'impression de résoudre quelque chose : il a l'impression d'écouter, de comprendre, de s'aligner.

## Types de puzzles prévus

**Connexion Neuronale**
Relier des nœuds neuronaux flottants en traçant un chemin d'énergie. Compléter un circuit ouvre un passage. Présent dans plusieurs zones.

**Séquence de Mémoire**
Des Rosas s'allument dans un ordre. Le joueur doit les toucher dans le même ordre. Rater 3 fois enfonce le fragment plus profond, ouvrant un chemin alternatif. Présent dans Les Yeux et La Mémoire.

**Écho Sonore** *(Oreilles)*
Écouter un pattern sonore puis activer les bonnes sources dans l'environnement dans le même ordre. **Aucun indice visuel** — pure mémoire auditive.

**La Patience** *(Zone Paisible)*
Rester complètement immobile pendant 10 secondes près d'un passage bloqué. Aucun ennemi, aucun danger. Pure épreuve de calme. Le joueur doit poser la manette.

**L'Illusion** *(Zone de Rêve)*
Le "bon" chemin ressemble à un mur. Il faut marcher dedans. Logique de rêve : faire confiance à l'impossible. Récompense la curiosité.

**Le Classement** *(Zone de Tri)*
Glisser des dossiers lumineux dans les bons conteneurs selon couleur et forme. Mauvais placement = légère décharge électrique.

**Redirection de Courant** *(Zone des Câbles)*
Tourner des nœuds-disjoncteurs pour rediriger l'électricité vers les bons mécanismes. Combinable avec la mécanique de Conductivité (cf. Objectif 23).

## Comportement général
- Pas de timer agressif (sauf cas explicite)
- Pas d'échec brutal : un raté ouvre généralement un chemin alternatif ou réinitialise doucement
- Signaux visuels clairs quand un puzzle est en cours de résolution

## Graphismes
- Chaque type de puzzle a son langage visuel
- Les éléments interactifs pulsent légèrement pour signaler qu'ils sont activables

---

# OBJECTIF 23 — Mécaniques contextuelles

*Capacités qui ne sont pas des "spells" mais des interactions situées dans le monde. Discrètes, à découvrir, parfois optionnelles.*

## Traces de Conscience
- Zell laisse des empreintes lumineuses très discrètes pendant 60 secondes
- Aide à ne pas se perdre dans les labyrinthes (notamment Les Yeux)
- Discret, présent pour qui regarde
- Toujours actif, pas de touche dédiée

## Résonance des Fragments
- Quand Zell est proche d'un collectible caché (souvenir, lettre, portrait), son corps vibre
- Émet un son doux qui s'intensifie avec la proximité
- Boussole incarnée — pas d'indicateur sur la carte
- Toujours active

## Sillage de Conscience
- Quand Zell dash (ou se mini-téléporte), elle laisse un afterimage 0.3-0.5s
- Cet afterimage peut activer certains switchs qui "voient" Zell passer
- Permet des puzzles de timing (deux switchs à activer simultanément)

## Réminiscence
- Dans certains lieux marqués, Zell peut activer un souvenir du lieu
- Touche d'interaction dédiée à proximité d'un point de Réminiscence
- Elle voit brièvement (5-10s) ce que cet endroit était avant d'être corrompu
- Usages : lire des inscriptions détruites, révéler des passages disparus, comprendre l'origine d'un ennemi

## Conductivité *(Zone des Câbles)*
- Zell peut servir de pont électrique
- Tenir une position entre deux contacts pendant que l'épée est chargée (Coup de Jus prêt ?) crée un circuit
- Alimente des mécanismes, ouvre des portes
- Mécanique exclusive à la Zone des Câbles

## Fragmentation Volontaire *(Phase 2, tard dans le jeu)*
- Zell peut se disperser brièvement en particules
- Permet de traverser des passages étroits ou certaines barrières spécifiques
- Court délai (~1s)
- Risqué : si touchée pendant la fragmentation, elle se recoagule en état endommagé
- Touche dédiée, débloquée par un souvenir tardif

---

# OBJECTIF 24 — Surcharge Émotionnelle (Phase 2)

## Ressenti joueur
En Phase 2, le monde est plus lourd. Si le joueur enchaîne trop de coups pris sans repos, Zell est submergée — émotionnellement, pas physiquement. L'écran réagit. Le joueur ressent la fatigue de Veilae.

## Comportement
- Trigger : 5 coups consécutifs pris dans une fenêtre courte (~20s) sans repos
- Effet :
  - Bords de l'écran pulsent avec la couleur émotionnelle dominante de la zone
  - Zell est ralentie de ~20%
  - L'image vibre subtilement
  - La musique devient plus dissonante
- Se dissipe : rester quelques secondes (5-10s) sans prendre de dégâts dans un espace sûr
- Disponible uniquement en Phase 2 et au-delà (pas en Phase 1)

## Graphismes
- Pulse périphérique de couleur (bleu pour Tristesse, rouge pour Colère, jaune pour Joie selon la zone)
- Petit tremblement de l'image, comme une larme au coin de l'œil

## Son
- Souffle profond qui se superpose à la musique
- Acouphène léger
- Disparition : grande inspiration, retour au calme

---

# OBJECTIF 25 — Carte du monde

## Ressenti joueur
La carte de Zell n'est pas une grille. C'est un **scan cérébral**. Le joueur lit son propre cerveau pendant qu'il l'explore. Magnifique, immédiatement reconnaissable.

## Comportement
- Carte représentée comme un **diagramme de réseau neuronal** (nœuds + lignes)
- Chaque salle = un nœud
- Chaque couloir = une ligne
- Zones découvertes : illuminées, colorées de la couleur de leur zone
- Zones non découvertes : à peine visibles, contours fantômes
- Neurones-checkpoints : nœuds qui pulsent
- Passages secrets découverts : lignes pointillées
- L'Oubli : section volontairement corrompue, parties manquantes — par design

## Géographie logique
- Oreilles → sur les côtés gauche / droit de la carte
- Nez → en bas (zone optionnelle)
- Cerveau / Mémoire → en haut
- Cœur → centre, accessible uniquement en Phase 3
- Les Sinus → centre-bas, hub de transition
- Zone de Rêve → très haut

## Fragments de carte
- Achetables chez Solin et certains marchands
- Chaque fragment révèle une partie de carte non encore explorée (une zone voisine)
- Pas obligatoires : on peut aussi tout dévoiler par exploration

## Contrôles
- Touche dédiée pour ouvrir / fermer la carte
- Zoom et pan possibles
- Marqueurs ajoutables par le joueur (au moins 2-3 types : "à revenir", "pas encore exploré", libre) — à valider

## Graphismes
- Style "imagerie médicale poétique" : lignes lumineuses, fond très sombre, légers reflets
- Animation discrète : les nœuds pulsent, les lignes "respirent"

---

# OBJECTIF 26 — Audio et musique

## Ressenti joueur
La musique de Zell est un personnage. Elle accompagne, elle parle, elle change avec l'état de Zell. Le joueur ne doit jamais avoir envie de couper le son.

## Musique par zone
- Une mélodie unique par zone, instruments dédiés (cf. Structure_et_idées pour le tableau complet par zone)
- Crossfade doux entre zones (cf. Objectif 11)

## Musique réactive
- La même mélodie de zone joue différemment selon l'état de Zell :
  - Pleine santé : version propre, mélodique
  - Endommagée : dissonances introduites
  - En combat : rythme intensifié, percussions ajoutées
  - Critique : la mélodie se fragmente, devient minimaliste

## Battement de cœur méta
- Un battement très lent et très grave court **sous toute la musique du jeu**
- Quasi-imperceptible en Phase 1
- Plus présent en Phase 2
- Devient la musique en Phase 3 (Le Cœur)
- Le joueur ressent une reconnaissance viscérale en Phase 3 sans pouvoir l'expliquer

## Voix des PNJ
- Pas de voix humaines
- Chaque PNJ a un son abstrait personnel (cf. Objectif 18)

## Pas de leitmotiv particulier
- Aucune mélodie centrale de Veilae à transformer à travers le jeu
- Chaque zone a sa propre identité musicale, autonome
- Décision révisable plus tard si besoin

## Direction
- Composition originale envisagée à terme
- Pour les premiers protos : libre de droits acceptable, à remplacer plus tard
- Sons additionnels (sirène, bip d'hôpital) : freesound.org

---

# OBJECTIF 27 — Sons du monde extérieur

## Ressenti joueur
Le cerveau filtre tout. Le monde réel existe, juste derrière, mais Veilae ne l'entend pas vraiment. Le joueur l'entend de mieux en mieux à mesure que le jeu progresse — comme si quelque chose s'éveillait.

## Comportement
- Sons du monde extérieur **toujours étouffés**, filtrés, comme entendus du fond d'un bain
- Présents dans des zones spécifiques :
  - **Oreille Gauche** (Phase 1) : voix lointaines, TV dans une autre pièce, klaxon, pluie. Jamais intelligible.
  - **Oreille Droite** (Phase 2) : presque clair. On croit entendre un prénom.
  - **La Peau** (zone secrète) : éclats de lumière + sons par les cracks
  - **En arrière-plan général** : très bas, presque subliminal

## Évolution par phase
- **Phase 1** : sons totalement filtrés, incompréhensibles
- **Phase 2** : sons plus présents, syllabes parfois reconnaissables
- **Phase 3** : sons presque clairs, on entend des mots, des prénoms
- **Fin** : la voix qui dit "Veilae..." est complètement claire

## Sources sonores à prévoir
- Sirène d'ambulance (lointaine, étouffée) — cinématique d'ouverture
- Bip respiratoire d'hôpital — cinématique d'ouverture, puis en arrière-plan
- Voix humaines filtrées — Oreilles, Peau
- Sons d'environnement hospitalier (chariots, portes, pas) — La Peau
- Voix finale qui dit "Veilae..." — cinématique finale

## Direction
- Effets de filtre passe-bas pour étouffer
- Réverbération longue pour la distance
- Volume très bas, mais audible si le joueur tend l'oreille

---

# OBJECTIF 28 — Direction artistique générale

## Ressenti joueur
Un monde **flou et lumineux**. Tout vibre légèrement, rien n'est figé. Les contours ne sont jamais durs. Le joueur a l'impression de jouer **dans un rêve qu'il regarde à travers un voile**.

## Palette
- **Phase 1** : violet, doré, rose, bordeaux, noir profond
- **Phase 2** : palette qui s'assombrit, ajout de bleus froids et de rouges
- **Phase 3** : rouge et or dominants
- **Le vert est absent** de tout l'univers, sauf dans les zones glitchées / corrompues (L'Oubli) — règle de cohérence stricte

## Effets globaux
- **Glow / Bloom** omniprésent mais maîtrisé
- **Particules** lumineuses partout : poussière, vapeur, éclats
- **Flou directionnel** léger en mouvement
- **Vibration** subtile sur les éléments importants (Rosas, neurones, souvenirs)

## Méthode de production
- Sprites et arrière-plans faits **à la main**
- Aide IA possible pour les passes initiales (génération, exploration de directions)
- Retouche manuelle obligatoire avant import dans Godot
- Workflow à formaliser au fil du temps

## Cohérence
- Chaque zone a son sous-univers visuel (cf. Structure_et_idées pour le détail par zone)
- Les ennemis d'une zone partagent un langage visuel commun
- Les UI sont minimales, intégrées au monde quand possible

---

# OBJECTIF 29 — Rosas et éléments réactifs d'ambiance

## Ressenti joueur
Le monde est vivant. Les Rosas pulsent, les neurones battent, les Rosas répondent au boss qu'on combat. Le joueur n'a pas besoin de comprendre pourquoi — il sent que tout réagit.

## Rosas (Les Yeux, et présentes ailleurs en signature)
- Formes circulaires géométriques violettes, dorées, roses, bordeaux
- Référence aux phosphènes (formes vues les yeux fermés)
- Servent de **repères visuels** dans les couloirs sombres
- Pulsent en rythme avec un battement lent
- **Baromètre du coma de Veilae** : vives en début de jeu, ternes en Phase 2, clignotent parfois
- Pendant le mini-boss : les Rosas sur les murs pulsent en sync avec le boss

## Éléments réactifs ailleurs
- **Neurones** : pulsent en permanence (cf. Objectif 10)
- **Câbles** : vibrent, certains "live" sont visibles à l'œil
- **Murs cachés** : scintillent à l'Impulsion
- **Plateformes de Rêve** : s'effondrent ou tiennent selon la "croyance" du joueur (Illusion)

## Direction
- Les éléments d'environnement ne sont jamais 100% statiques
- Tout respire, oscille, vibre

---

# OBJECTIF 30 — UI minimale

## Ressenti joueur
L'écran de jeu doit être **vide** au maximum. Tout doit être dans le monde. Pas de barres, pas de minimap permanente, pas de notifications agressives.

## Éléments à l'écran (en permanence)
- Rien, sauf si nécessaire

## Éléments à l'écran (contextuels)
- Synapses : compteur discret, apparaît brièvement quand le total change, sinon caché
- Jauge de Coup de Jus : très petite, à proximité de Zell ou intégrée à son sprite
- Charges d'Impulsion : indicateur ultra-minimal (3 points qui s'éteignent)
- Notification d'objet ramassé : nom de l'objet en bas d'écran pendant 2s
- Boîte de dialogue PNJ : bas d'écran, sobre, fond légèrement opaque

## Menu pause
- Touche dédiée
- Sections : Carte, Inventaire, Codex, Options, Quitter
- Le jeu se fige sans flou
- Musique légèrement atténuée

## Graphismes UI
- Typographie unique au jeu, lisible mais discrète
- Cadres très fins, transparences importantes
- Animations d'apparition / disparition douces (~0.3s)

---

# OBJECTIF 31 — Codex et journal

## Ressenti joueur
Le Codex est le sanctuaire du joueur attentif. Tout ce qu'il a trouvé est conservé là, accessible, rejouable. Pas de quête forcée à le consulter — mais ceux qui y vont y restent longtemps.

## Contenu
- **Souvenirs** : liste des souvenirs collectés, rejouables individuellement (cf. Objectif 21 pour la Salle des Souvenirs in-game)
- **Lettres déchirées** : fragments de messages collectés
- **Pensées Fugaces** : textes/images vus quelques secondes en jeu, archivés ici une fois lus
- **Portrait de Veilae** : puzzle collectible — chaque fragment trouvé ajoute un élément (visage, cheveux, expression). Visible à mesure qu'il s'assemble. Complet uniquement à la fin.
- **Bestiaire** (à valider) : entrées d'ennemis vaincus

## Comportement
- Accessible depuis le menu pause
- Navigation par catégorie
- Souvenirs : sélection = relecture (texte / scène / son)
- Lettres et pensées : affichage simple, recherchables
- Portrait : zone d'affichage avec les fragments en place

## Graphismes
- Style "carnet onirique" : pages translucides, lumière douce
- Le Portrait évolue visuellement : on voit les pièces s'ajouter
- Animations discrètes au survol

---

# OBJECTIF 32 — Cinématiques (ouverture et fin)

## Ressenti joueur
Les cinématiques sont rares, courtes, précieuses. Elles ne racontent pas — elles **suggèrent**. Le joueur sort de chaque cinématique avec une question, pas une réponse.

## Cinématique d'ouverture
- Écran noir total
- Sons : sirène d'ambulance lointaine → bip respiratoire d'hôpital → silence
- 3 secondes de silence absolu
- Zell s'allume comme une flamme dans le noir
- La musique des Yeux monte doucement
- Aucun texte, aucune explication
- Enchaîne directement sur le gameplay

## Cinématique de fin
- Le Cœur bat pour la première fois régulièrement
- Fondu au blanc total
- Les yeux de Veilae s'ouvrent (vue extérieure brève — hôpital ?)
- Une voix dit "Veilae..." — voix d'un membre de la famille proche
- Fondu au blanc à nouveau
- Crédits

## Transitions de phase (mini-cinématiques)
- Phase 1 → 2 : flash blanc, transformation de Zell visible, pause d'écran ~3s
- Phase 2 → 3 : entrée dans Le Cœur, l'arène se révèle, battement de cœur devient la musique

## Direction
- Pas d'animations complexes
- Composition par tableaux fixes + transitions
- Le son fait 80% du travail émotionnel

---

# OBJECTIF 33 — Système de sauvegarde

## Ressenti joueur
Le joueur ne pense jamais à la sauvegarde. Elle se fait toute seule, partout, tout le temps. S'il ferme le jeu, il sait qu'il retrouvera tout.

## Comportement
- Sauvegarde automatique à chaque activation de neurone
- Sauvegarde automatique aux moments-clés (boss vaincu, capacité débloquée, transition de phase)
- Un seul slot de sauvegarde par profil (à valider — possible 3 slots pour multi-joueurs sur la même machine)
- Format : JSON ou ressource Godot
- Variables à persister :
  - Position du dernier neurone
  - PV max et PV courants
  - Synapses (compte total + 10% verrouillés)
  - Capacités débloquées
  - Souvenirs collectés
  - Neurones activés
  - Neurones cachés découverts
  - Ennemis morts dans la zone courante (réinitialisés à chaque repos)
  - Phase courante (1, 2, 3)
  - Progression PNJ
  - Collectibles trouvés (lettres, pensées, fragments de portrait)
  - Matériaux rares en inventaire
  - Options du joueur

## Sécurité
- Sauvegarde dans 2 fichiers en parallèle (un principal, un backup)
- En cas de corruption du principal, fallback automatique sur le backup

---

# OBJECTIF 34 — Modes d'accessibilité

## Ressenti joueur
Le jeu doit être accessible à des joueurs de niveaux et de capacités différents. Personne ne doit être exclu de l'histoire à cause d'un défi mécanique.

## Modes de difficulté
- **Mode Narration** : combat allégé, checkpoints plus fréquents, peu de Synapses perdues à la mort. Pour ceux qui veulent l'histoire.
- **Mode Standard** : l'expérience telle qu'elle est conçue.
- **Mode Épreuve** : ennemis plus durs, checkpoints plus rares, pertes accrues, aucune aide à la carte.

## Options détaillées
- Daltonisme : alternatives visuelles pour les codes couleur émotionnels
- Réduction / désactivation du screen shake
- Vitesse de texte ajustable
- Maintien automatique de touches (pour éviter le crampage)
- Sous-titres pour tous les sons importants
- Contraste élevé optionnel

## Mappage des touches
- Reconfigurable sur clavier et manette
- Présets prédéfinis (gaucher, mains réduites, etc.)

---

# OBJECTIF 35 — Mécaniques narratives diffuses

## Ressenti joueur
Le jeu raconte sans le dire. Des dizaines de petits détails environnementaux que le joueur observe ou pas, mais qui s'accumulent en lui. Le sens vient à la fin, ou jamais.

## Pensées Fugaces
- Textes ou images qui clignotent 1-2 secondes quand Zell passe à certains endroits
- Trop rapides pour tout lire d'un coup
- Le joueur doit revenir, s'arrêter, attendre
- Archivées dans le Codex une fois lues (cf. Objectif 31)

## Lettres déchirées
- Fragments de messages, pages de carnet
- Reconstituent les relations de Veilae (famille, amis, moments du quotidien)
- Stockées et lisibles depuis le Codex
- Contiennent des indices "V." pour le joueur attentif

## L'Ombre
- Silhouette humanoïde de Zell (forme Phase 2) qui apparaît parfois dans le fond des couloirs
- Juste pour observer
- Disparaît si Zell s'approche
- Elle seule peut la voir
- Devient boss dans La Mémoire en Phase 2 (Le Double)

## Indices "V."
- Lettres "V" isolées disséminées dans L'Oubli et ailleurs
- Préfiguration du vrai nom (Veilae) révélé à la fin
- Jamais souligné par le jeu, jamais expliqué

## La Peau (zone secrète, optionnelle)
- Idée gardée en réserve, scope incertain
- Quasi-blanche, minimaliste, sans ennemis, sans collectibles
- Des cracks apparaissent par moments — la chambre d'hôpital, brièvement audible / visible
- Évolution par phase : cracks rares → nombreux → omniprésents
- Pas obligatoire, pas indispensable, pour les joueurs qui cherchent

---

# OBJECTIF 36 — Système de Phases (1, 2, 3)

## Ressenti joueur
Le jeu change. Pas progressivement — d'un coup. Le joueur entre dans un nouveau monde, qui est le même que celui d'avant mais altéré. La sensation doit être celle d'un retour dans un lieu familier qu'on ne reconnaît plus.

## Architecture
- Phase 1, 2, 3 : variable globale dans le GameManager
- Chaque zone a des **variantes** ou **modifications** selon la phase courante
- Pas de duplication massive des scènes — les changements se font via swap de visuels, ennemis, sons, dialogues

## Phase 1 — Qui elle était
- Zell est une boule d'énergie
- Zones liées à l'identité et aux souvenirs
- Couleur dominante : doré, ambré, rose
- PNJ : majoritairement bienveillants, mystérieux

## Phase 2 — Ce qu'elle traverse
- Zell est une forme humanoïde
- **Toutes** les zones de Phase 1 sont modifiées (visuels plus sombres, nouveaux ennemis, dialogues qui évoluent)
- Couleur dominante : bleus froids, gris, ajouts de rouge
- Nouveaux ennemis, nouveaux boss
- Le Double apparaît
- Surcharge Émotionnelle disponible (cf. Objectif 24)

## Phase 3 — Le Cœur
- Une seule zone, accessible uniquement à ce moment
- Course finale, intensité maximale
- Boss final en 3 sous-phases (Arythmie, Arrêt, Renaissance)

## Transitions de phase
- Mini-cinématique courte (cf. Objectif 32)
- État du joueur conservé, capacités conservées
- L'aspect visuel de Zell change visiblement (boule → humanoïde, etc.)

## Conséquences globales
- La carte évolue (zones de Phase 2 et 3 deviennent visibles)
- Les Rosas s'assombrissent
- Le battement de cœur méta gagne en présence
- Les sons du monde extérieur deviennent plus clairs

---

# OBJECTIF 37 — Architecture technique générique

## Principe
- **Séparer moteur et contenu**
- Moteur : code GDScript qui fait tourner le jeu (mouvement, combat, dégâts, IA, sauvegarde, dialogues)
- Contenu : données dans des ressources `.tres` (ennemis, boss, souvenirs, dialogues, upgrades, zones)
- **Ajouter du contenu ne doit jamais nécessiter d'écrire du nouveau code**

## Organisation de dossiers à respecter
```
res://
├── scenes/
│   ├── player/
│   ├── enemies/
│   ├── bosses/
│   ├── world/         (1 sous-dossier par zone)
│   ├── ui/
│   └── vfx/
├── scripts/
│   ├── player/
│   ├── enemies/
│   ├── systems/
│   ├── spells/
│   └── autoload/
├── data/              (ressources de contenu, modifiables sans toucher au code)
│   ├── enemies/
│   ├── bosses/
│   ├── memories/
│   ├── dialogues/
│   ├── upgrades/
│   ├── materials/
│   └── zones/
├── assets/
│   ├── sprites/
│   ├── audio/
│   └── fonts/
└── localization/      (pour traduction future)
```

## Autoloads principaux
- **GameManager** : état global, phase, sauvegarde, variables persistantes
- **AudioManager** : musique, sons, transitions audio, battement de cœur méta, sons du monde extérieur
- **SceneManager** : gestion des transitions de zone
- **DialogueManager** : lecture des dialogues, branchements

## Composition par composants
- Pas d'héritage complexe
- Composants réutilisables : `HealthComponent`, `HitboxComponent`, `HurtboxComponent`, `StateMachineComponent`, `DropComponent`
- Un ennemi = un assemblage de composants + une ressource de données

## Préparer pour la traduction
- Aucun texte en dur dans le code
- Tous les textes dans des ressources / JSON / CSV référencés par clés
- Permet de réécrire et de traduire sans toucher au code

---

*Pour les détails narratifs (zones spécifiques, boss spécifiques, dialogues exemples, lore), voir `Structure_et_idées.md`.*
