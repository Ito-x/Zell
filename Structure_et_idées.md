# ZELL — Structure & Idées

*Document de vision narrative et créative. Tout ce qui touche à l'univers, aux personnages, aux zones, aux boss, à l'ambiance. Pas de spécifications techniques (celles-ci vivent dans le CDC).*

---

## Le jeu

**Zell** est un metroidvania 2D onirique développé sur **Unity 2D URP** (Unity 6.3 LTS). Le joueur explore l'intérieur du cerveau d'une jeune femme dans le coma. Style dessin animé flou, féerique, lumière et particules omniprésentes, narration entièrement environnementale. Tout est ressenti, jamais expliqué. Prévu pour PC d'abord, console plus tard. Graphismes faits à la main (Krita), avec aide IA.

> *Document narratif. Pour les spécifications techniques (mécaniques, contrôles, architecture Unity, état du projet, roadmap), voir `CAHIER_DES_CHARGES.md`.*

---

## Le personnage principal — Veilae / Zell

- **Vrai prénom** : **Veilae** (nom provisoire, susceptible d'évoluer). Révélé uniquement à la toute fin par la voix d'un proche.
- **Surnom de jeu** : **Zell**
- **Âge** : environ **18 ans**. Jeune, mais elle a déjà eu le temps de vivre des choses — joies, douleurs, premières fois, deuils peut-être.
- **Famille** : enfant unique.
- **Phase 1** : boule d'énergie née du choc.
- **Phase 2** : forme humanoïde féminine d'énergie.
- **Phase 3** : la même, dans Le Cœur. Course finale.

Le joueur reconstruit son identité au fil du jeu. Au début, Zell ne sait rien d'elle-même. À la fin, le joueur sait — sans qu'on lui ait jamais expliqué frontalement.

---

## L'accident

Un accident de voiture. **Involontaire**. C'est tout ce qu'on sait avec certitude. Le jeu reste flou dessus volontairement — le joueur ne verra jamais le moment de l'accident, n'aura jamais de cinématique explicative. Des fragments laissent deviner : un sourire, une lumière du matin, un vélo, un rembobinage. Ou rien de tout ça. Chacun reconstruit.

Le temps que Veilae a passé dans le coma au début du jeu n'a pas d'importance narrative. On entre dans l'esprit, on n'en sort qu'à la fin.

On ne voit jamais le monde extérieur directement. Seulement des sons étouffés, des cracks de lumière dans La Peau, des voix qui filtrent par les Oreilles.

---

## Structure narrative — Trois phases

### Phase 1 — Qui elle était
Zell est une boule d'énergie. Les zones de cette phase tournent autour de l'identité, des souvenirs, des sens. Chaque boss principal déverrouille un souvenir cinématique et parfois un spell. À la fin de la phase, Zell s'est suffisamment souvenue d'elle-même pour changer de forme — flash blanc, transformation.

### Phase 2 — Ce qu'elle traverse
Forme humanoïde. **Toutes les zones de Phase 1 sont modifiées** : visuels plus sombres, ennemis altérés, nouveaux dialogues. Les Rosas pâlissent, le monde semble plus lourd. De nouvelles zones s'ouvrent — les Émotions, l'Oreille Droite, la Bouche, l'Oubli. Le Double apparaît. Veilae affronte sa propre volonté de continuer.

### Phase 3 — Le Cœur
Une seule zone, accessible uniquement à ce moment. Aucune exploration — un élan pur vers l'avant. Le boss final est Le Cœur lui-même. Le rallumer, c'est choisir de vivre. Les yeux s'ouvrent.

---

## La fin

Ses yeux s'ouvrent. Une voix dit *"Veilae..."* — la voix d'un **membre de sa famille proche** (parent ou très proche). C'est la première fois qu'on entend son vrai nom clairement. Le joueur recolle tout ce qu'il a vu. Fondu au blanc.

**Une seule fin pour tout le monde.** Pas de fin alternative selon collectibles, pas de "true ending" caché. Le mystère est partagé. Délibérément.

Des indices sur le vrai nom sont semés tout au long du jeu — voix distordues, initiale "V.", fragments dans l'Oubli. Le joueur attentif les voit venir. Le joueur qui passe à côté est surpris à la fin. Les deux expériences sont valides.

---

## Progression du personnage — Fragments de souvenirs

Zell commence comme **pure conscience**. Elle ne trouve pas des membres physiques — elle absorbe des fragments de souvenirs qui *prennent la forme* de membres d'énergie lumineuse. Mécaniquement, c'est un système de powerups. Visuellement, c'est cohérent : son corps se reconstruit à mesure que sa mémoire se reconstitue.

### Les fragments des Yeux (zone tutoriel)

Zell s'éveille avec une seule capacité innée : le **Refroidissement**. Elle ne récupère ensuite que **deux fragments** dans le tuto, plus l'épée via le boss.

| Étape | Manifestation | Capacité débloquée |
|---|---|---|
| Éveil | Glow chaud baissable en froid bleu-violet | **Refroidissement** (inné, invisibilité à la vue) |
| 1er fragment | Onde de perception | **Impulsion** (perception pure) |
| 2e fragment | Trait de lumière horizontal | **Dash horizontal** |
| Épreuve du Chevalier | Bras armé, lame d'énergie | **Épée d'énergie** |

La **partie verticale du Dash** se débloque plus tard, en Phase 1 — elle remplace définitivement l'idée du double saut et ouvre la verticalité. Tant qu'on ne l'a pas, **certaines zones du tuto restent inaccessibles** (backtracking optionnel, ne bloque jamais la progression).

**Capacités abandonnées** : double saut, saut mural, plané, 3e spell un temps envisagé.

### Souvenirs au-delà du tutoriel

Chaque boss principal des zones suivantes droppe un souvenir. Leur **importance varie** selon le poids du boss dans le récit : certains souvenirs sont des éclats de lore sans capacité, d'autres débloquent une nouvelle mécanique majeure. Les boss secondaires droppent des récompenses moindres (Synapses, fragments mineurs, matériaux rares).

Les souvenirs ne portent **pas forcément sur l'accident**. La plupart sont des moments de la vie de Veilae — un anniversaire, une dispute, une route au soleil, un mot griffonné. Mystérieux par accumulation, jamais par énigme explicite.

---

## Les règles internes du monde

Le cerveau de Zell n'est pas anatomique. Il est **émotionnel**. Les zones ne sont pas là où elles devraient être biologiquement — elles sont là où Veilae les ressent.

- **Les Yeux** ne sont pas derrière les yeux, ils sont l'expérience des yeux fermés
- **La Bouche** n'est pas dans la mâchoire, c'est la mémoire du goût, de la parole, du plaisir
- **Le Cœur** est au centre parce qu'il *est* le centre

Cela dit, une logique **anatomique simplifiée** structure la disposition de la map :
- Oreilles → sur les côtés
- Nez → en bas (zone optionnelle)
- Cerveau / Mémoire → en haut
- Cœur → au centre (Phase 3 uniquement)
- Zone de Rêve → très haut
- Les Sinus → zone de transition centrale

### Quatre principes qui gouvernent ce monde

**1. La cohérence comme santé**
Zell est pure conscience. Sa santé n'est pas physique — c'est sa cohérence. Prendre des dégâts, c'est se fragmenter. À pleine santé, son sprite est net. Près de la mort, elle est à peine maintenue ensemble. L'information vit dans le corps, pas dans une barre.

**2. Le temps diverge**
Dehors, Veilae est dans le coma depuis quelques heures peut-être. Dedans, Zell explore des semaines. Chaque moment est précieux parce que le temps intérieur est infini — et celui du dehors est compté.

**3. Les Rosas comme baromètre**
Les Rosas (formes géométriques lumineuses des Yeux) pulsent avec l'état neurologique de Veilae. Vives en début de jeu. Plus ternes en Phase 2. Elles clignotent parfois. Jamais expliqué — juste visible pour qui regarde.

**4. Les ennemis ne sont pas des ennemis**
Personne dans ce cerveau n'est fondamentalement mauvais. Les Aveugles réagissent par peur. Les Formes étaient belles avant d'être corrompues. Les Braises sont la colère légitime de Veilae. Combattre dans Zell, c'est toujours combattre une partie de soi. Jamais dit. Présent à qui veut le voir.

---

## L'état visuel de Zell

Le sprite change selon la santé. Aucune barre de vie dans l'espace de jeu.

| Santé | Apparence |
|---|---|
| 100% | Sphère nette, gradient blanc-or-ambré, glow stable |
| 75% | Bords plus dispersés, particules flottantes |
| 50% | Forme moins définie, plus ambrée que blanche, particules qui dérivent |
| 25% | Centre minuscule, presque entièrement particules |
| Critique | Tremblante, presque invisible, tenue par un fil |

**Satellites de cohérence (décision tranchée mai 2026)** : en complément de la dégradation du sprite, 5 petites **flammèches ambrées** gravitent autour de Zell, à courte distance (hors de son aura). Chaque flammèche = 1 PV ; à chaque coup pris, la dernière s'éteint. Permet une lecture instantanée du nombre de PV restants sans casser l'esthétique "pas d'UI criarde". Sens d'orbite suit le regard (horaire à droite, antihoraire à gauche). Les upgrades HP ajoutent des flammèches (6, 7, 8…), pas un palier visuel séparé. En Phase 2, elles continuent d'orbiter autour de la forme humanoïde — pas de refonte.

**L'épée d'énergie est aussi un élément constant** (décision tranchée mai 2026) : elle reste visible en permanence à côté de Zell, reliée à son centre par un **fil d'énergie ambré** (le "bras de lumière"). À l'attaque, elle s'élance vers la direction du coup et un slash arc blanc-or matérialise la zone touchée façon Hollow Knight.

Même logique pour les fragments : chaque souvenir absorbé est une micro-cinématique de 3-4 secondes où la partie du corps se matérialise. La fin de Phase 1 est une transformation progressive, pas un changement brutal.

---

## Les zones

### Phase 1

**Les Yeux** — zone tutorielle.
Endroit sombre, décoré de **Rosas** (formes circulaires géométriques violettes, dorées, roses, bordeaux). Référence aux phosphènes : ces formes lumineuses qu'on perçoit les yeux fermés. C'est ici que Zell s'éveille, récupère ses deux fragments (Impulsion puis Dash horizontal), traverse des phases de furtivité opposée, puis affronte le **Chevalier Cristallin** pour gagner l'épée. Musique douce, piano et flûte.

**Déroulé complet du tuto** :
1. Éveil de Zell avec le seul **Refroidissement** (capacité innée)
2. 1er fragment → **Impulsion** (perception pure)
3. 2e fragment → **Dash horizontal**
4. Phases de furtivité opposée : Grosse Boule au Refroidissement, Aveugles en meute à l'immobilité
5. Épreuve du **Chevalier Cristallin** : retrait d'Excalibur du rocher de chair, puis duel à l'épée
6. Retour au spawn, l'épée sert de clé pour ouvrir la porte scellée vers la Phase 1
7. **Plus tard en Phase 1** : déblocage du **dash vertical**, qui ouvre la verticalité et le retour vers les zones du tuto laissées de côté (backtracking optionnel, ne bloque jamais la progression)

Le tuto doit **semer pièges, fausses parois et salles cachées** pour donner une utilité immédiate à l'Impulsion (qui n'a pas d'usage offensif).

**Les Sinus** — zone de transition.
Rôle de Dirtmouth dans Hollow Knight. Sas calme entre Les Yeux et le reste du monde. Au moins **un marchand de base** y vit, vendant fragments de carte et objets de soin. Atmosphère sobre, ni triste ni joyeuse. Un seuil.

**Oreille gauche** — accessible en Phase 1.
Tapissée d'herbe noire représentant les cils auditifs. On entend des bribes de l'extérieur — gens qui parlent, flou, comme derrière une porte. Jamais intelligible.

**Zone de Rêve** — très haut sur la map.
Pas féerique mignon. **Psychédélique et perturbante.** Saturée comme un arc-en-ciel ivre. Géométrie impossible, gravité qui s'inverse, plateformes qui obéissent à la logique du rêve — une plateforme "solide" peut s'effondrer si on y croit trop fort. Un souvenir où Veilae rêvait de voler est caché ici. Musique : harpe, célesta, sans rythme fixe.

**La Mémoire** — phase 1, étendue en phase 2.
Zone avec des chaînes. Contient la Salle des Souvenirs : pièce bloquée par des chaînes (Spell de Fusion du Métal requis), qui stocke les souvenirs collectés et permet de les rejouer. **Sous-zones possibles** : la Mémoire peut se diviser (bons souvenirs / mauvais souvenirs / archives, à explorer). Le boss principal droppe le Spell de Fusion du Métal et un souvenir majeur. En Phase 2, cet endroit accueille le Double de Zell.

**Zone de Tri** — archives du cerveau (boss secondaire).
Rayonnages infinis de dossiers lumineux. Très clinique, blanc-gris froid. Atmosphère : bureaucratie de l'inconscient. Puzzles de classement. Ennemis : **Les Classeurs** — automates qui deviennent hostiles si on perturbe l'ordre. Boss : **Le Réviseur**, entité obsessionnelle qui considère Zell comme un élément non autorisé. Musique : drone minimal, hum électrique.

**Zone des Câbles** — boss secondaire.
Faisceaux massifs de câbles lumineux enchevêtrés. Couleurs chaudes (orange, jaune, blanc). Système nerveux moteur et sensoriel. Certains câbles sont "live" — les toucher fait des dégâts électriques. Mécanique : rediriger des courants. **Filin** (le forgeron) vit ici. Ennemis : **Les Courts-Circuits**, éclats explosifs qui voyagent le long des câbles. Boss secondaire : **La Surcharge**.

**Zone paisible** — boss secondaire.
Vaste espace ouvert, lumière ambrée douce, plateformes flottantes comme des nénuphars. Presque aucun ennemi. **Mécanique de méditation** : rester immobile quelques secondes restaure les charges d'Impulsion et soigne légèrement. Inscriptions environnementales qui donnent des Synapses si lues. Boss secondaire : **Le Gardien Paisible**, qui ne veut pas se battre mais teste Zell. Musique : vent, cordes douces, respiration.

### Phase 2

Toutes les zones de Phase 1 sont modifiées (visuels assombris, dialogues PNJ qui changent, parfois nouveaux ennemis). À cela s'ajoutent des zones inédites.

**Les Émotions** — Phase 2.
Trois sous-zones qui saignent les unes dans les autres. Les couloirs changent de ton en plein milieu.
- *Tristesse* : corridors inondés, plateformes à ras de l'eau, bleu-gris atténué
- *Colère* : terrain qui s'effrite, murs qui craquent, rouge intense, particules de feu
- *Joie* : aveuglément lumineux jaune-blanc, le plus grand danger est caché là

Boss : **Le Nœud Émotionnel** — trois phases, une par émotion.

**Oreille droite** — accessible en Phase 2 seulement.
Même esthétique que l'Oreille Gauche, plus intense. Les sons sont presque clairs. On croit entendre un prénom. **Une révélation narrative majeure se produit ici** — quelque chose qui recontextualise tout ce qu'on croyait savoir.

**La Bouche** — Phase 2.
Couleurs de bonbons (rose, bleu, vert menthe) avec une sous-couche de pourriture. Plateformes en sucre qui se dissolvent (il faut bouger). Terrain collant par endroits — chewing-gum, ralentit. Ennemis : **Les Bactéries** (qui se divisent en deux au coup d'épée, max 3 générations — seul le Coup de Jus les détruit sans division) et **Les Caries** (mi-boss récurrents). Boss : **Le Festin**, colonie de bactéries devenue intelligente.

**L'Oubli** — Phase 2.
Zone instable, littéralement incomplète. Certaines tuiles manquent, des salles s'arrêtent net. Le terrain disparaît derrière Zell dans certaines sections. La carte ne s'enregistre pas correctement ici — par design. Contient les indices "V." disséminés sur les murs. Ennemis : **Les Glitches**, ennemis mal chargés, hitbox imprévisibles, texture manquante. Boss : **Le Vide** — on ne peut pas le voir, on combat quelque chose qui n'est pas tout à fait là.

### Phase 3

**Le Cœur**.
Une seule zone, accessible uniquement en Phase 3. Élan pur vers l'avant. Le battement de cœur devient la musique, irrégulier, lent, puis régulier. Tout pulse à chaque battement. Rouge et or.

Boss final en trois sous-phases :
- *Arythmie* : attaques irrégulières, patterns imprévisibles
- *Arrêt* : silence total, tout gèle, puis un seul battement massif qui fait d'énormes dégâts
- *Renaissance* : le cœur bat régulièrement pour la première fois, devient beau, Veilae choisit de vivre

### Zone secrète — La Peau

Idée gardée en réserve, pas obligatoire dans le scope initial.

Une zone que personne n'indique. Pas sur la carte. Frontière du monde. Quasi-blanche, minimaliste. Pas d'ennemis, pas de collectibles. Juste l'espace. Par moments, les murs craquent et laissent passer un éclat de lumière blanche — le monde réel, juste derrière. Ces cracks apparaissent quand des événements se produisent dehors (quelqu'un parle à Veilae, une décision médicale est prise).

Évolution par phase :
- Phase 1 : cracks rares, curiosité
- Phase 2 : cracks plus nombreux, sons étouffés
- Phase 3 : La Peau se désintègre, on voit presque à travers

Pour les joueurs qui cherchent. Pour rappeler qu'il y a une chambre d'hôpital, derrière tout ça.

### Autres zones (à ajouter au fil du développement)

D'autres zones peuvent s'ajouter pendant la production si des idées émergent — principales ou de transition. Les noms définitifs sont reportés au polissage (sauf inspirations qui viennent en cours de route).

---

## Skills et capacités

**Côté tuto (Les Yeux), Zell sort avec trois spells max : Refroidissement (inné), Impulsion (1er fragment), Dash (2e fragment, en deux parties)** — plus l'épée du Chevalier Cristallin. D'autres capacités viendront plus tard (Coup de Jus, Fusion du Métal, Réseau Neuronal, etc.) au fil des Phases 1 et 2 — les sections plus bas couvrent l'ensemble du jeu.

### Refroidissement (inné)
Disponible dès l'éveil. Zell baisse son émission : son glow chaud (ambre/blanc) passe à une transparence bleu-violet froide. Les créatures qui la pistent **à la vue** la perdent.

Géré par une **jauge** qui se vide quand l'invisibilité est active et **se recharge à l'arrêt**. Pas une furtivité totale — un compromis : on devient invisible mais on consomme.

Contre-mesure principale contre la Grosse Boule (zone tuto). Inutile contre les Aveugles (qui pistent au son).

### Impulsion (1er fragment)
**Perception pure, zéro dégât.** Zell se concentre, émet une impulsion électrique, une onde radiale se propage et révèle pendant quelques secondes :
- Ennemis cachés ou invisibles
- Fausses parois, salles secrètes
- Pièges
- Collectibles
- Le vrai chemin dans les zones d'illusion

**3 charges**, rechargées **aux neurones** et **en méditant** (zone paisible). Un usage offensif reste envisageable plus tard mais n'est pas prévu.

Comme l'Impulsion ne sert qu'à percevoir, le tuto doit **semer des pièges, des fausses parois et des salles cachées** pour qu'elle ait une utilité immédiate.

### Dash (2e fragment, en deux parties)
- **Horizontal** : débloqué dans le tuto, 2e fragment. **Mini-téléportation électrique instantanée** sur une distance fixe (point A → point B), iframes pendant l'opération.
- **Vertical** : débloqué en **Phase 1**, ouvre la verticalité du monde et remplace définitivement l'ancienne idée du double saut. Permet le retour vers les zones du tuto laissées de côté.

**Ressenti tranché (mai 2026)** : mini-téléportation, pas un dash glissé. Signature visuelle façon **Radagon (Elden Ring)** — un rayon vertical de foudre s'abat au point de départ, Zell disparaît dedans, un second rayon frappe au point d'arrivée et elle réapparaît. Burst électrique + afterimage 0.35s au point A (utilisable pour le Sillage de Conscience). Distance courte, cooldown court, pas conçu pour traverser des grandes zones.

### L'épée d'énergie
Récupérée dans Les Yeux, plantée dans un rocher de chair, libérée lors de l'épreuve du **Chevalier Cristallin**. Sert uniquement au combat. **Améliorable 5 fois** :
- Upgrades 1-4 : portée (×2 niveaux), dégâts (×2 niveaux), ordre libre choisi par le joueur
- **Upgrade 5 — paralysie** : déblocable **uniquement à la toute fin**, quand toutes les autres upgrades sont prises. Stun/paralysie des ennemis, durée très courte, consommation d'énergie énorme.

L'upgrade 5 demande **les 4 matériaux des zones** (un de chaque), prouvant que le joueur a tout exploré.

Évolution visuelle de la lame :

| Niveau | Apparence |
|---|---|
| Base | Lame courte, blanc-or |
| 1 | Plus longue |
| 2 | Bordure ambré-orange, plus lumineuse |
| 3 | Très longue, sillage bref |
| 4 | Crépitante, intense, audible avant d'être vue |
| 5 | Pointe bleu électrique, trois couleurs, flash blanc-bleu à chaque swing |

### Le Coup de Jus
**Mécanique signature.** Fonctionne via une **jauge qui se remplit en frappant les ennemis** — comme un ultimatum qu'on construit. Une fois pleine, on la déclenche : l'ennemi est désarmé, son arme tombe au sol. Il court la chercher, vulnérable pendant ce temps. **Zell ne peut pas la ramasser.** Crée des moments de tension : achever pendant que c'est vulnérable, ou fuir ?

Sur les boss : pas de désarmement (les boss n'ont pas d'arme), mais inflige des **dégâts électriques importants**. Utilisation tactique différente.

### Spell de Fusion du Métal
Droppé par le boss de La Mémoire. Fait fondre chaînes, cadenas, obstacles métalliques. Débloque des zones et passages inaccessibles avant.

### Spell du Réseau Neuronal
Permet le fast travel entre neurones. **Déblocage en deux temps** :
1. Battre un mini-boss spécifique → débloque la capacité de base
2. Activer les autres neurones → étend le réseau

Pas une récompense d'exploration totale comme initialement imaginé — c'est un mini-boss d'abord, puis l'exploration ouvre le réseau.

---

## Boss — Design complet

### Boss des Yeux — Le Chevalier Cristallin
*Nom à confirmer, mais ça part là-dessus.* C'est le **premier vrai combat du jeu** et le **tuto de maniement de l'épée** (attaques + esquive au dash).

**Ce n'est pas un combat qu'on gagne désarmé** : c'est une **épreuve de valeur** qui arme Zell, puis un duel.

**Mise en scène** :
- Le joueur entre dans la salle. **Excalibur** est plantée dans un **rocher de chair** au centre.
- Le Chevalier est assis sur un **trône à droite**.
- Il invite Zell à tenter de retirer l'épée. Elle y parvient (seule une porteuse digne le peut).
- Il reconnaît sa valeur, se lève, et la combat **loyalement**.
- On gagne. L'épée devient pleinement sienne — petite aura propre, animation d'obtention.
- Le Chevalier s'incline ou se dissout.

**Identité visuelle** : le **cristal** le démarque nettement des autres mobs du tuto, organiques et difformes. Il pourrait être :
- un ancien porteur cristallisé,
- une sentinelle du seuil,
- ou un fragment de Zell qui se teste elle-même.

→ **Point encore à trancher.**

**L'épée comme clé du tuto** : après le combat, on rapporte l'épée au spawn et on l'insère dans la **porte scellée**, qui s'ouvre — accès à la Phase 1. **Pas de clé séparée, l'arme et la clé sont une seule et même chose.**

**Note** : le talk-no-jutsu (boss qu'on bat en lui parlant) est mis de côté pour un boss de Phase 1, pas pour le tuto.

### Boss de La Mémoire — L'Oubli Voulu
Manifestation du désir de Veilae d'oublier ce qui fait mal. Silhouette faite de chaînes entrelacées. Lent. Presque doux. Pas un monstre — quelqu'un d'épuisé.

**Phase 1** : ses chaînes s'étendent vers Zell, pas pour frapper — pour retenir. Les chaînes ralentissent Zell quand elles l'atteignent. Coupables à l'épée.

**Phase 2** : projette sur les murs de l'arène des fragments de souvenirs. S'approcher d'eux paralyse brièvement Zell — la mémoire la submerge.

**Phase 3** : le boss se dissout lui-même. Ses attaques deviennent lentes, tristes. Il ne veut pas vraiment faire de mal. Il veut juste que ça s'arrête.

**Défaite** : les chaînes tombent, fragments de mémoire pleuvent. Mémo apparaît, submergé. Drop : Spell de Fusion du Métal + souvenir majeur.

### Boss des Émotions — Le Nœud Émotionnel
Trois phases, une par émotion. L'arène change de couleur à chaque phase.

**Phase Tristesse** : lourd, lent. Attaques en larges zones — faciles à voir venir, difficiles à éviter par leur amplitude. Musique déchirante. Se déplace comme quelqu'un qui porte un poids énorme.

**Phase Colère** : rapide, chaotique. Charge à travers l'arène. Particules de feu. L'écran tremble à chaque impact. Percussions pures.

**Phase Joie** : semble se calmer. Rebondit presque joyeusement. Musique légère. Puis explosion massive sans prévenir. Répétition. La joie est la phase la plus dangereuse.

**Entre les phases** : un moment d'immobilité. Le boss semble perdu, comme s'il ne savait plus ce qu'il ressent. Fenêtre courte pour soigner ou attaquer.

### Boss de l'Oreille Gauche — Le Filtre
Entité qui filtre et bloque les sons du monde extérieur.

Arène : couloir acoustique. Les ondes sonores sont visibles — pulses de lumière qui traversent l'espace.

**Mécanique unique** : le Filtre peut couper certains sons du jeu lui-même. Il supprime les cues audio d'attaque. Le joueur doit lire les animations visuellement.

**Phase 2** : le Filtre commence à défaillir. Des éclats de sons extérieurs percent — une voix, un bip d'hôpital, quelque chose d'incompréhensible mais présent. Le Filtre panique.

**Défaite** : il éclate. Un flot de sons filtrés remplit l'espace — toujours étouffés, plus présents que jamais. Quelque chose se dit dehors. On ne comprend pas encore.

### Le Double — La Mémoire, Phase 2
Le boss le plus chargé émotionnellement du jeu.

Apparence : la forme humanoïde de Zell (Phase 2) en version plus sombre, plus translucide, plus lente. Contours moins nets. Fatiguée.

**Mécanique** : elle n'attaque pas vraiment. Elle **retient**. Ses "attaques" sont des étreintes qui deviennent des prises. Elle ralentit Zell, l'immobilise, la tire en arrière. Combattre le Double, c'est combattre quelque chose qui veut que tu t'arrêtes.

Ce qu'elle dit, en fragments :
> *"Tu es fatiguée."*
> *"Laisse-moi."*
> *"C'est fini."*
> *"Reste."*

**Défaite** : elle ne meurt pas. Elle se dissout. Sa dernière ligne :
> *"...peut-être."*

Ce "peut-être" est la réponse la plus honnête qu'elle puisse donner. Elle doute. C'est suffisant.

### Le Vide — L'Oubli
L'arène semble vide. Le joueur prend des dégâts de rien. Il ne voit rien.

**Mécanique** : l'Impulsion révèle le Vide pendant une fraction de seconde. Le joueur doit Impulser, voir où il est, frapper dans la fenêtre de visibilité, puis le Vide disparaît à nouveau.

Il ne fait jamais de son. Il ne parle jamais. Il a oublié ce qu'il était.

**Défaite** : rien ne se passe visuellement. Les dégâts s'arrêtent. Un silence. Puis sur le mur, une seule lettre apparaît et reste :
> *"V."*

### Le Cœur — Boss final, Phase 3
L'arène **est** le cœur. Les murs pulsent. Le sol bat.

**Phase 1 — Arythmie** : le sol se hérisse sur les battements irréguliers. Le plafond descend. Rien sur un rythme prévisible. Survivre au chaos. Le boss n'est pas visible — il *est* l'arène.

**Phase 2 — Arrêt** : tout s'arrête. Silence complet. Zell flotte dans le noir immobile. Puis : un seul battement massif — BOOM — l'arène entière se contracte. Un impact qui fait d'énormes dégâts. À anticiper dans le silence.

**Phase 3 — Renaissance** : le cœur recommence à battre, régulièrement, pour la première fois. L'arène devient belle — rouge et or. Le cœur se matérialise comme une forme physique visible. Synchroniser ses attaques sur le rythme : frapper dans le battement, esquiver hors du battement.

**Le coup final** : Zell ne frappe pas. Elle se place au centre. Le cœur bat une dernière fois autour d'elle. Fondu au blanc. Des yeux qui s'ouvrent.

---

## PNJ

Les PNJ savent qui est Veilae. **Ils ne le lui disent jamais.** Ils parlent par énigmes, par silences, par familiarité étrange. Certains agissent comme s'ils la connaissaient depuis des siècles. Ils sont tous mystérieux, à des degrés différents.

**Non tuables** sauf si leur mort est scriptée dans le lore. Pas de massacre accidentel possible.

### Solin — Le Gardien des Neurones
Petit être de lumière blanche-bleue. Discret, ancien. Vit près des checkpoints, les entretient. Vend des objets basiques (fragments de soin, morceaux de carte). Parle en phrases courtes et fragmentées.
> *"Tu n'es pas la première lumière à passer par ici."*

Au moins **un Solin dans Les Sinus** (rôle de marchand de base).

### Mémo — L'Archiviste (La Mémoire)
Être frénétique et enthousiaste, obsédé par le catalogage. Aide Zell à comprendre les fragments collectés. Permet de rejouer les souvenirs. Légèrement chaotique — ses propres archives sont en désordre.
> *"Ce souvenir-là — je l'avais classé sous 'M' pour... pour... je ne sais plus."*

### Écho — L'Errant
PNJ fragmenté, apparaît aléatoirement dans différentes zones. Particules éparpillées, jamais cohérent. Donne des indices cryptiques sur l'identité de Veilae. Se contredit parfois. C'est une pensée oubliée qui essaie de se souvenir.
> *"V... elle aimait... le jaune ? Non. Le bleu ? Non..."*

### Filin — Le Réparateur (Zone des Câbles)
Pragmatique et brusque mais bienveillant. Améliore l'épée d'énergie en échange de Synapses + matériaux rares. Le seul PNJ vraiment commercial.
> *"J'peux la réparer. Mais ça va coûter."*

### Les Gardiens Silencieux — Zone Paisible
Petits êtres sans nom, qui ne parlent jamais. Observent Zell. Si elle s'arrête près d'eux assez longtemps, ils lui offrent un don (soin, Synapses). Représentent l'instinct de survie, le soin inconscient de soi.

### Veille — La Conscience Fragmentée (L'Oubli, très tard)
Miroir de Zell, mais sous une forme plus ancienne. La manifestation la plus proche de la vraie conscience de Veilae. Parle peu, sait des choses que le joueur ne comprend pas encore.
> *"J'ai attendu longtemps. Je savais que tu reviendrais."*

### Voix des PNJ
**Pas de voix humaines.** Chaque PNJ a un son abstrait :
- Solin : bourdonnement grave et calme
- Mémo : cliquetis staccato, frénétique
- Écho : réverbération longue, presque un écho
- Filin : grondement mécanique
- Le Double : le son exact de Zell, mais légèrement plus lent, plus grave

---

## Ennemis

Tous les ennemis ont une **origine narrative** — un lore. Ils ne sont pas là par hasard. Leurs comportements sont **prédéfinis et scriptés**. Pas de système d'amitié dynamique : si un ennemi devient un allié à un moment, c'est codé à l'avance pour cet ennemi.

**Ennemis exclusifs à leur zone** par défaut (à confirmer pendant le développement).

### Les Yeux (zone tuto)

Deux archétypes pensés **en contraste de sens** : devant l'un on se cache, devant l'autre on se fige. C'est le cœur du tuto — apprendre à lire l'ennemi avant de réagir.

**La Grosse Boule** — *voit mais n'entend pas*
Gros mob lent, **énormes yeux**, bouche béante, sourd. Détecte uniquement à la vue. Le bruit ne l'alerte jamais.
→ **Contrée au Refroidissement** : Zell baisse son glow, la Grosse Boule la perd.
→ Le déplacement reste libre tant qu'on est invisible.

**Les Aveugles** — *entendent mais ne voient pas*
Petits, ailés. Un métissage de **chauve-souris (façon Zubat)** et de **fantôme**. Yeux troués, **oreilles exagérément grandes**. Pistent au son et à la vibration. Arrivent **en meute**.
→ **Contrés en restant immobile ou en se déplaçant lentement.** Le Refroidissement ne sert à rien contre eux.

**Intérêt design** : les deux ennemis demandent des **réponses opposées**. La Grosse Boule : cache-toi (sois invisible, marche). Les Aveugles : fige-toi (reste visible mais silencieuse).

**Les Filaments**
Simple obstacle de traversée. Fils de lumière à couper à l'épée ou à franchir au dash.

### Les Émotions (Phase 2)

**Les Larmes** (Tristesse)
Lentes, mélancoliques, passives jusqu'à être acculées. En mourant laissent une flaque qui ralentit brièvement. Le chagrin s'attarde.

**Les Braises** (Colère)
Rapides, agressives, foncent sur Zell. Touchées à l'épée : se divisent en deux. Seul le Coup de Jus les détruit complètement.

**Les Éclats de Joie**
Rebondissants, chaotiques, presque adorables. Peuvent accidentellement booster le saut de Zell. Quand acculés : explosion en zone.

### La Bouche (Phase 2)

**Les Bactéries**
Se divisent en deux au coup d'épée (max 3 générations). Le Coup de Jus les détruit sans division. Rondes, colorées, presque mignonnes.

**Les Caries**
Version grande et sombre des Bactéries. Mi-boss récurrents, commandent les petites bactéries.

### La Mémoire

**Les Engrammés**
Souvenirs cristallisés — une main, une silhouette figée. Invulnérables, juste repoussables. Servent de plateformes mobiles dans certaines zones.

**Les Effacés**
Quasi-invisibles, détectables uniquement à leur contour. Au contact : une portion de la carte de Zell est temporairement effacée. Psychologiquement déstabilisants. L'Impulsion les révèle clairement.

### L'Oubli

**Les Glitches**
Ennemis qui semblent mal chargés. Stuttent, se téléportent sur de courtes distances, hitbox imprévisibles. Corruption pixelisée, texture manquante.

### Phase 2 — Ennemi spécial transversal

**L'Ombre**
Silhouette humanoïde de Zell (sa forme Phase 2), apparaît parfois dans le fond des couloirs — juste pour observer. Pas hostile. Disparaît si Zell s'approche. Elle seule peut la voir. Devient boss dans La Mémoire en Phase 2 (Le Double).

---

## Mécaniques diffuses

### Impulsion (déjà couverte)
Cf. section Skills. 3 charges, rechargées aux neurones, pas d'amélioration prévue.

### Traces de Conscience
Zell laisse de très légères empreintes lumineuses qui durent 60 secondes. Aide à ne pas se perdre dans le labyrinthe des Yeux. Discret, pour qui regarde.

### L'Écho de Mort
À l'endroit de la mort, une silhouette fantôme rejoue brièvement les derniers instants de Zell. Aide à comprendre comment elle est morte. S'efface quand elle récupère ses Synapses.

### La Résonance des Fragments
Quand Zell est proche d'un collectible caché, son corps vibre, émet un son doux. Plus forte à mesure qu'elle se rapproche. Boussole incarnée — pas d'indicateur sur la carte, juste une sensation.

### Surcharge Émotionnelle (Phase 2 uniquement)
Prendre 5+ coups consécutifs sans repos déclenche un état de surcharge. Les bords de l'écran pulsent de la couleur émotionnelle de la zone. Zell est ralentie. L'image vibre. Se dissipe en restant quelques secondes près d'un espace sûr. Représente l'écrasement émotionnel.

### La Réminiscence
Dans certains lieux, Zell peut activer un souvenir du lieu. Elle voit brièvement ce que cet endroit était avant d'être corrompu. Usages : lire des inscriptions détruites, révéler des passages, comprendre l'origine d'un ennemi.

### La Conductivité (Zone des Câbles)
Zell peut servir de pont électrique. Tenir une position entre deux contacts pendant que l'épée est chargée crée un circuit. Alimente des mécanismes, ouvre des portes.

### Sillage de Conscience
Quand Zell dash (ou se mini-téléporte), elle laisse un afterimage pendant une demi-seconde. Cet afterimage peut activer certains switchs qui "voient" Zell passer. Permet des puzzles de timing.

### Fragmentation Volontaire (Phase 2, tard)
Zell peut se disperser brièvement en particules pour traverser des passages étroits ou certaines barrières. Court délai, risquée — si touchée pendant la fragmentation, elle se recoagule en état endommagé.

---

## Monnaie — Les Synapses

Les **Synapses** sont les connexions biologiques entre neurones. Monnaie cohérente, immédiatement lisible.

**Gain** :
- Ennemis vaincus (drop variable selon difficulté)
- Zones cachées et coffres lumineux
- Récompenses de certains PNJ

**Dépense** :
- Marchands (items, infos, fragments de carte)
- Réparation de neurones endommagés
- Passages neuraux scellés
- Upgrades chez Filin

---

## Système de mort

À la mort :
- Zell éclate en particules au point de mort
- Ses Synapses restent sur place, en petit amas lumineux
- Elle se reforme au **dernier neurone activé**
- Retourner au point de mort = récupérer les Synapses
- Mourir à nouveau avant = perte définitive
- **Filet de sécurité** : 10% des Synapses sont automatiquement épargnées à chaque neurone activé

**Pas de limite de morts**, pas de pénalité permanente. La mort n'est pas punitive — elle est narrative.

---

## Carte du monde

La carte de Zell n'est pas une grille — c'est un **diagramme de réseau neuronal**.

- Salles = nœuds
- Couloirs = lignes
- Visuel : scan cérébral ou carte synaptique
- Zones découvertes : illuminées, colorées
- Zones non découvertes : contours fantômes
- Neurones-checkpoints : nœuds qui pulsent
- Passages secrets : lignes pointillées
- L'Oubli : section volontairement corrompue / incomplète

Fragments de carte achetables chez Solin (révèlent une zone voisine non explorée).

---

## Musique et son

### Tableau par zone

| Zone | Instruments | Ambiance |
|---|---|---|
| Les Yeux | Piano + flûte, doux | Éveil, curiosité fragile |
| Oreille Gauche | Ambient pur, voix filtrées | Mystère, distance |
| Zone de Rêve | Harpe, célesta, arythmique | Irréel, perturbant |
| La Mémoire | Piano seul, dissonances rares | Mélancolie, poids |
| Zone de Tri | Drone minimal, hum électrique | Froid, clinique |
| Zone des Câbles | Électronique chaud, groove | Énergie, tension |
| Zone Paisible | Vent, cordes douces | Paix, respiration |
| Les Émotions | Change par sous-zone | Tristesse / Colère / Joie |
| Oreille Droite | Comme gauche, plus intense | Révélation, urgence |
| La Bouche | Jazz léger, légèrement faux | Faux-joyeux, uncanny |
| L'Oubli | Musique qui glitche et s'efface | Instabilité, angoisse |
| Le Cœur | Battement de cœur = musique | Intensité pure |

### Pas de leitmotiv particulier prévu
Aucune mélodie centrale de Veilae à transformer à travers le jeu. Chaque zone a sa propre musique. Cette décision peut évoluer.

### Battement de cœur méta
Un battement très lent et grave court sous toute la musique du jeu, quasi-imperceptible. En Phase 3, quand il devient explicite, le joueur ressent une reconnaissance sans savoir pourquoi.

### Sons du monde extérieur
Toujours étouffés, filtrés, comme entendus depuis le fond d'un bain. Jamais intelligibles en Phase 1. Presque clairs en Phase 2. Plus présents en Phase 3.

### Musique réactive
La mélodie de zone joue différemment selon l'état de Zell : version propre à pleine santé, dissonances quand endommagée, intensification en combat, fragmentation en état critique.

---

## Puzzles

**Connexion Neuronale** — Relier des nœuds neuronaux flottants en traçant un chemin d'énergie. Compléter un circuit ouvre un passage.

**Séquence de Mémoire** — Des Rosas s'allument dans un ordre. Reproduire la séquence en les touchant. Rater 3 fois enfonce le fragment plus profond (chemin alternatif requis).

**Écho Sonore** (Oreille zones) — Écouter un pattern sonore puis activer les bonnes sources dans l'environnement dans le même ordre. Aucun indice visuel.

**La Patience** (Zone Paisible) — Rester immobile 10 secondes près d'un passage bloqué. Aucun ennemi, aucun danger. Pure épreuve de calme.

**L'Illusion** (Zone de Rêve) — Le "bon" chemin ressemble à un mur. Il faut marcher dedans. Logique de rêve : faire confiance à l'impossible.

**Le Classement** (Zone de Tri) — Glisser des dossiers lumineux dans les bons conteneurs selon couleur et forme. Mauvais placement = légère décharge électrique.

---

## Collectibles

**Souvenirs** — Scènes mémoire rejouables. Importance variable selon le boss qui les drop.

**Portrait de Veilae** — Puzzle collectible dispersé sur tout le jeu. Chaque fragment ajoute un élément (visage, cheveux, expression). Portrait complet révélé dans la cinématique finale.

**Pensées Fugaces** — Textes ou images qui clignotent 1-2 secondes quand Zell passe à certains endroits. Trop rapides pour tout lire d'un coup.

**Lettres Déchirées** — Fragments de messages, pages de carnet. Reconstituent les relations de Veilae : amis, famille, moments du quotidien.

**Nœuds Neuronaux Cachés** — Neurones secrets qui, activés, étendent le réseau de fast travel au-delà du chemin standard.

---

## Lore — exemples de textes

*Pistes pour écrire les vrais textes plus tard. Délibérément vagues.*

**Lettre #1** (Les Yeux, bien cachée) :
> "...tu reviendras pour l'anniversaire ? Maman a fait le gâteau au..."
*(déchirée — on ne saura jamais quel parfum)*

**Lettre #2** (La Mémoire) :
> "...je t'ai cherchée partout après les cours. V., réponds-moi quand tu..."
*(l'expéditeur ne finit pas — ni nom ni genre identifiable)*

**Lettre #3** (Oreille Droite, Phase 2 — la plus importante) :
> "Veilae. Les médecins disent que tu peux peut-être entendre. Alors je..."
*(quelqu'un lui parle dans la chambre d'hôpital. On l'entend enfin.)*

**Pensée Fugace** (Zone de Rêve) :
> "Le jaune du soleil sur la route ce matin-là."

**Pensée Fugace** (L'Oubli) :
> "V..."

**Inscription** (Zone Paisible) :
> "Ce qui est calme n'est pas perdu."

**Fragment de mémoire rejouable** (La Mémoire) :
Une silhouette sur un vélo. Lumière du soleil. Un sourire. La scène commence à se rembobiner, de plus en plus vite, jusqu'à ne plus être que du blanc.

---

## La chambre d'hôpital

On ne voit jamais le monde extérieur directement. Mais des bribes filtrent — par les Oreilles, par les cracks de La Peau, par les sons étouffés en arrière-plan.

Dans la chambre, **plusieurs personnes viennent au fil des jours**. Ils parlent à Veilae. Elle ne sait pas qu'ils sont là (ou si — un peu). Le joueur reconnaît leurs voix peu à peu, sans jamais les voir.

**Impact gameplay** : faible. Ce sont des présences qui colorent la phase 2 et 3, qui rendent la fin émotionnelle, mais qui ne déclenchent pas de mécaniques majeures.

À la fin, **un membre de la famille proche** dit son prénom — Veilae. C'est la première fois qu'on l'entend nettement.

---

## Direction artistique

- **Palette principale** : violet, doré, rose, noir profond (Phase 1) → s'assombrit en Phase 2 → rouge et or en Phase 3
- **Vert** : absent de tout l'univers sauf zones glitchées / corrompues (L'Oubli)
- **Effets** : Glow / Bloom omniprésent, particules lumineuses, flou directionnel léger en mouvement
- **Ambiance** : onirique, intérieur de l'esprit, organique
- **Inspirations** : Hollow Knight, Ori and the Blind Forest

### Méthode de production
Graphismes **faits à la main** dans Krita, avec aide IA pour des passes initiales (exploration de directions, génération de base). Retouche manuelle obligatoire avant import dans Unity. Le workflow exact est documenté dans `CAHIER_DES_CHARGES.md` (section Workflow de production).

### Cohérence
Chaque zone a son sous-univers visuel. Les ennemis d'une zone partagent un langage visuel commun. L'UI est minimale, intégrée au monde quand possible.

---

## Cinématique d'ouverture

Écran noir total. La conscience de Veilae naît progressivement dans le silence.

```
Sirène d'ambulance        → fade out progressif
Bip respiratoire hôpital  → fade out progressif
Silence total             → 3 secondes
Zell s'allume             → apparition douce, comme une flamme dans le noir
Fondu musique             → la musique des Yeux monte doucement
```

Aucun texte. Aucune explication. Sons libres de droits (freesound.org) pour les premières versions.

---

## Accessibilité

### Modes de difficulté
- **Mode Narration** : combat allégé, checkpoints fréquents, Synapses moins perdues à la mort
- **Mode Standard** : l'expérience telle qu'elle est conçue
- **Mode Épreuve** : ennemis plus durs, checkpoints rares, pertes accrues, aucune aide à la carte

### Options
- Daltonisme : alternatives visuelles pour les codes couleur émotionnels
- Réduction / désactivation du screen shake
- Vitesse de texte ajustable
- Mappage des touches reconfigurable

---

## Points reportés au polissage / à voir

Ces points ne bloquent pas la production. Ils seront tranchés plus tard, ou laissés ouverts pour évoluer pendant le développement.

- **Noms définitifs** des zones secondaires (Câbles, Tri, Paisible, etc.)
- **Système de carte** détaillé (interaction, marqueurs, etc.)
- **Système de menu / codex** détaillé
- **Système de nage** (pour les zones inondées comme la sous-zone Tristesse)
- **Détail du système d'upgrades** au-delà de l'épée
- ~~Dash ou mini-téléportation~~ → **Mini-téléportation électrique tranchée** (cf. section Dash)
- **Sort de La Peau** — idée gardée, scope incertain
- **L'Oubli** — forme exacte non tranchée
- **Sous-zones de La Mémoire** — peuvent exister, à concevoir
- **Ennemis exclusifs ou partagés entre zones** — à confirmer
- **Quêtes secondaires des PNJ** — à voir
- **Réactions des PNJ entre phases** — à élaborer
- **Bestiaire / journal détaillé** — à voir
- **Mécanique de retour régulier à la Salle des Souvenirs** — à inventer

---

*Pour les spécifications techniques (systèmes, contrôles, comportements), voir le `CAHIER_DES_CHARGES.md`.*
