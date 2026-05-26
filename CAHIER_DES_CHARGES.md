# CAHIER DES CHARGES — ZELL

**Version 2 — Refonte complète (mai 2026)**
**Engine : Unity 6.3 LTS, 2D URP**

*Document maître. Source de vérité unique. Mis à jour à chaque décision tranchée.*
*Pour le détail narratif (lore, dialogues exemples, voix des PNJ), voir `Structure_et_idées.md`.*

---

## Table des matières

0. [Vue d'ensemble](#0-vue-densemble)
1. [Univers — résumé narratif](#1-univers--résumé-narratif)
2. [Personnage joueur — Zell](#2-personnage-joueur--zell)
3. [Mouvement et contrôles](#3-mouvement-et-contrôles)
4. [Skills et capacités](#4-skills-et-capacités)
5. [Système de combat](#5-système-de-combat)
6. [Mécaniques diffuses](#6-mécaniques-diffuses)
7. [Zone tuto — Les Yeux](#7-zone-tuto--les-yeux)
8. [Phase 1 — autres zones](#8-phase-1--autres-zones)
9. [Phase 2](#9-phase-2)
10. [Phase 3 — Le Cœur](#10-phase-3--le-cœur)
11. [PNJ](#11-pnj)
12. [Bestiaire](#12-bestiaire)
13. [Boss](#13-boss)
14. [HUD et interface](#14-hud-et-interface)
15. [Carte du monde](#15-carte-du-monde)
16. [Mort et sauvegarde](#16-mort-et-sauvegarde)
17. [Monnaie — Synapses](#17-monnaie--synapses)
18. [Audio](#18-audio)
19. [Direction artistique](#19-direction-artistique)
20. [Cinématiques](#20-cinématiques)
21. [Accessibilité](#21-accessibilité)
22. [Tech stack Unity](#22-tech-stack-unity)
23. [Architecture du projet](#23-architecture-du-projet)
24. [Workflow de production](#24-workflow-de-production)
25. [État actuel du projet](#25-état-actuel-du-projet)
26. [Roadmap immédiate](#26-roadmap-immédiate)
27. [Points reportés](#27-points-reportés)

---

## 0. Vue d'ensemble

**Genre :** Metroidvania 2D onirique narratif.
**Plateformes cible :** PC d'abord (Windows IL2CPP), console plus tard.
**Engine :** Unity 6.3 LTS avec pipeline Universal 2D (URP 2D Renderer).
**Équipe :** Paul (Itonauwu), solo, débutant. Aide Claude (IA) pour code, design, doc.
**Workflow art :** Krita pour les sources, export PNG, import Unity. Aide IA pour passes initiales.

### Philosophie de design

- **Narration entièrement environnementale.** Aucune cinématique explicative. Tout est ressenti, jamais expliqué.
- **UI minimale.** Pas de barres criardes. Tout intégré au monde quand possible.
- **Pas de pixel art.** Style peint lisse type Hollow Knight Silksong / Ori, mais avec son propre univers (intérieur d'un cerveau).
- **Beau avant tout.** Profondeur, lumière, parallaxe, glow. Immersion prioritaire sur la performance pure.
- **Une seule fin pour tous.** Pas de "true ending" caché, pas de variantes selon collectibles. Le mystère est partagé.
- **Cohérence stricte du langage visuel.** Le vert est proscrit de tout le jeu sauf zones glitchées (Oubli).

---

## 1. Univers — résumé narratif

**Pitch :** Veilae, jeune femme d'environ 18 ans, est dans le coma après un accident de voiture involontaire. Le joueur explore l'intérieur de sa conscience sous la forme de Zell — d'abord boule d'énergie, puis forme humanoïde, puis pure poussée. Le jeu se déroule entièrement à l'intérieur, on ne voit jamais le monde réel directement.

### Trois phases narratives

| Phase | Forme de Zell | Thème | Conclusion |
|---|---|---|---|
| **Phase 1** | Boule d'énergie | Qui elle était (identité, sens, souvenirs) | Transformation, flash blanc |
| **Phase 2** | Humanoïde d'énergie | Ce qu'elle traverse (zones modifiées + nouvelles) | Veilae affronte sa volonté de continuer |
| **Phase 3** | Élan pur | Le Cœur — choisir de vivre | Yeux qui s'ouvrent |

### La fin

À la fin, les yeux de Veilae s'ouvrent et une voix d'un proche dit **"Veilae..."** — première fois que le joueur entend son vrai nom clairement. Indices "V." disséminés tout au long du jeu (lettres, voix distordues, fragments de l'Oubli) pour ceux qui regardent.

Plus de détail narratif dans **`Structure_et_idées.md`**.

---

## 2. Personnage joueur — Zell

### Apparence

Phase 1 : **boule d'énergie** multi-couches concentriques.

| Couche | Rôle visuel |
|---|---|
| **Halo extérieur (OrbOuter)** | Très large, alpha faible, bleu-violet diffus |
| **Mid (OrbMid)** | Moyen, plus saturé, cyan-blanc |
| **Inner (OrbInner)** | Proche cœur, blanc lumineux |
| **Cœur (OrbCore)** | Tout petit, blanc pur, le plus dense |
| **Light 2D ponctuelle** | Glow réel sur l'environnement (URP 2D) |

Le tout pulse doucement et **chaque couche dérive légèrement avec sa propre phase** (sinus décalés) pour donner l'effet "fluide vivant", pas figé. Implémenté dans `EnergyOrbVisual.cs`.

**Pas de bras ni de jambes en Phase 1.** Tranché mai 2026 : juste la boule qui flotte.

**Question reportée** : pieds ? bâtons ? juste flotte au-dessus du sol style "lune clair-obscur" ? → Pour l'instant **flotte simple**, à retravailler quand on aura l'art final.

### Évolution visuelle par santé

Pas de barre de vie dans l'espace de jeu. Le **sprite lui-même** change avec les PV.

| Santé | Apparence |
|---|---|
| 100% | Sphère nette, gradient blanc-or-ambré, glow stable |
| 75% | Bords plus dispersés, particules flottantes |
| 50% | Forme moins définie, plus ambrée que blanche, particules qui dérivent |
| 25% | Centre minuscule, presque entièrement particules |
| Critique | Tremblante, presque invisible, tenue par un fil |

### Satellites de cohérence (= les PV explicites)

**5 petites flammèches ambrées** affichées séparément du sprite, **qui tournent en cercle** dans le HUD (pas autour du perso — décision photo schéma mai 2026 : visuellement plus simple en HUD séparé). Chaque flammèche = 1 PV. À chaque coup pris, la dernière s'éteint. Les upgrades HP ajoutent des flammèches (6, 7, 8…).

En Phase 2, les flammèches continuent de tourner autour de la version humanoïde de Zell — pas de refonte du système.

### États visuels selon les pouvoirs

- **Refroidissement actif** → Zell passe en **couleurs négatives de son corps**. Le glow chaud (ambre/blanc) devient bleu-violet froid. Possibilité d'une **flamme noir/violette brouillée** comme effet de transition.
- **Impulsion en charge** → Zell se concentre, devient **bleu** (contours bleus + intérieur bleu plus transparent). Au centre, **un chiffre clignote** indiquant le nombre de charges restantes — style **HxH entraînement de Gon et Kirua** (le chiffre apparaît, change, disparaît, comme un compteur Nen).
- **Coup d'épée** → flash blanc-or à chaque swing.
- **Dash (mini-téléportation)** → rayon vertical de foudre au point A (Radagon-like), Zell disparaît, second rayon au point B, afterimage 0.35s.

### L'épée d'énergie (à partir du tuto)

Une fois récupérée, **toujours visible à côté de Zell**, reliée à son centre par un **fil d'énergie ambré** (le "bras de lumière"). À l'attaque, elle s'élance vers la direction du coup, un slash arc blanc-or matérialise la zone touchée.

### Phase 2 — Humanoïde

Forme humanoïde féminine d'énergie. Les satellites de cohérence continuent d'orbiter autour. L'épée reste reliée par le fil d'énergie. Plus de détail dans `Structure_et_idées.md`.

---

## 3. Mouvement et contrôles

### Schéma de touches (clavier AZERTY)

| Action | Touche |
|---|---|
| Gauche | **Q** ou flèche gauche |
| Droite | **D** ou flèche droite |
| Sauter | **Espace** ou flèche haut |
| Attaquer | **Clic gauche** (souris) |
| Dash | **Clic droit** (souris) |
| Impulsion | **F** |
| Refroidissement | (à définir) |
| Interagir | **E** |
| Regarder en haut | **Z** |
| Regarder en bas | **S** |

Tout reconfigurable plus tard dans les options. Support manette à valider.

### Physique de mouvement

- **Vitesse horizontale** : ~8 unités/s en marche normale (à ajuster par feel)
- **Force de saut** : ~14 (à calibrer)
- **Gravité** : `Rigidbody2D.gravityScale = 3`
- **Pas de friction au sol** (commande directe via `linearVelocity`)
- **Détection sol** : `Physics2D.Raycast` vers le bas, longueur 0.7, `queriesStartInColliders = false`
- **Pas de double saut.** La verticalité s'ouvre avec le **dash vertical** débloqué plus tard en Phase 1.

### Coyote time + Jump buffer

À ajouter plus tard pour le feel — ~0.1s de tolérance après avoir quitté le sol, ~0.1s de buffer si on appuie sur saut juste avant d'atterrir. Standard metroidvania.

---

## 4. Skills et capacités

### Refroidissement — inné

Zell baisse son émission. Glow chaud passe à bleu-violet froid transparent. Les créatures qui pistent à la **vue** la perdent. Inutile contre les Aveugles (qui pistent au son).

- **Jauge dédiée** (à styliser sur un côté du HUD, cf section 14)
- Se vide quand actif, se recharge à l'arrêt
- Pas une furtivité totale — c'est un compromis
- Contre-mesure principale contre la Grosse Boule (tuto)

### Impulsion — 1er fragment (zone Pupille en bas de la zone tuto)

**Perception pure, zéro dégât.** Onde radiale révèle pendant quelques secondes :
- Ennemis cachés ou invisibles
- Fausses parois (les "murs détectables avec Impulsion" du tuto)
- Pièges cachés
- Collectibles
- Le vrai chemin dans les zones d'illusion (Zone de Rêve, Oubli)

- **3 charges**, rechargées aux neurones et en méditant (Zone Paisible)
- Animation visuelle : Zell devient bleue, chiffre des charges restantes clignote au centre style HxH
- Pas d'usage offensif prévu

### Dash horizontal — 2e fragment (zone Câbles/Nerfs optiques, droite du tuto)

**Mini-téléportation électrique instantanée** sur distance fixe. Pas un dash glissé.

- Signature visuelle Radagon-like (rayon vertical de foudre point A → réapparition point B)
- I-frames pendant l'opération
- Burst électrique + afterimage 0.35s au point de départ
- Cooldown court
- Distance courte (pas pour traverser des grandes zones)

### Dash vertical — débloqué plus tard en Phase 1

Remplace définitivement l'idée du double saut. Ouvre la verticalité du monde et le backtracking vers les zones du tuto laissées de côté (gauche infranchissable au début, etc.).

### Coup de Jus — mécanique signature

**Jauge qui se remplit en frappant les ennemis.** Une fois pleine :
- Sur **mob normal** : l'ennemi est **désarmé**, son arme tombe au sol. Il court la chercher, vulnérable pendant. **Zell ne peut pas la ramasser.**
- Sur **boss** : pas de désarmement → **dégâts électriques importants**

Crée des moments tactiques : achever pendant la vulnérabilité ? Fuir ?

**Affichage HUD** : jauge qui se remplit dans la **couleur courante de Zell** (chaude par défaut, bleue en Refroidissement / Impulsion).

### Épée d'énergie

Récupérée lors de l'épreuve du Chevalier Cristallin (boss tuto). **Plantée dans la porte du spawn** au début → c'est la **clé du tuto** : insérée dans la porte, elle ouvre l'accès à la Phase 1. Pas de clé séparée, arme et clé sont une seule chose.

Améliorable 5 fois chez **Filin** (Zone des Câbles, Phase 1) :

| Upgrade | Effet | Apparence |
|---|---|---|
| Base | - | Lame courte blanc-or |
| 1 | Portée +1 | Plus longue |
| 2 | Portée +2 ou Dégâts +1 (libre) | Bordure ambré-orange |
| 3 | Variante choix | Très longue, sillage bref |
| 4 | Variante choix | Crépitante, audible avant d'être vue |
| 5 | **Paralysie** | Pointe bleu électrique, 3 couleurs, flash blanc-bleu à chaque swing |

**Upgrade 5 — paralysie** : déblocable **uniquement à la toute fin** quand toutes les autres sont prises. Stun ennemi court, coût énergie énorme. Demande **les 4 matériaux des zones** (un de chaque), prouvant exploration complète.

### Spell de Fusion du Métal — Boss de La Mémoire

Fait fondre chaînes, cadenas, obstacles métalliques. Débloque zones et passages inaccessibles avant.

### Spell du Réseau Neuronal — fast travel

Déblocage en deux temps :
1. **Battre un mini-boss spécifique** → capacité de base
2. **Activer les neurones** dans le monde → étend le réseau de téléportation

---

## 5. Système de combat

### Hitbox / hurtbox

Pattern composants Unity :
- `HealthComponent` sur ennemi/joueur (PV courants, max, mort)
- `HurtboxComponent` (zone qui prend les dégâts, lié à health)
- `HitboxComponent` (zone qui inflige des dégâts, lié à direction / dégâts)

Collision Hitbox → Hurtbox via Physics2D layers + tags.

### Esquive

- **Au sol** : pas d'esquive dédiée (le saut sert d'esquive verticale)
- **En l'air** : pas non plus, on évite par positionnement
- **Dash** : i-frames pendant l'opération (~0.2s)

### Knockback

Léger recul à l'impact (Zell + ennemi), avec un délai d'invincibilité court (~0.4s) pour pas perdre plusieurs PV en une frame.

### Slash visuel

À chaque attaque épée, **arc blanc-or** matérialise la zone touchée façon Hollow Knight. Direction selon la direction d'attaque (8 directions possibles plus tard, basique horizontal au début).

---

## 6. Mécaniques diffuses

### Traces de Conscience

Empreintes lumineuses qui durent ~60 s sur le sol où Zell est passée. Aide à ne pas se perdre dans les labyrinthes (Yeux, Oubli).

### L'Écho de Mort

À l'endroit de la mort, une silhouette fantôme rejoue brièvement les derniers instants de Zell. Aide à comprendre comment elle est morte. S'efface quand elle récupère ses Synapses.

### La Résonance des Fragments

Près d'un collectible caché, le sprite de Zell vibre, émet un son doux. Plus fort en approchant. Boussole incarnée, pas d'indicateur sur la carte.

### Surcharge Émotionnelle (Phase 2 uniquement)

Prendre 5+ coups consécutifs sans repos → état de surcharge. Bords d'écran pulsent de la couleur émotionnelle de la zone. Zell ralentie. Image vibre. Se dissipe après quelques secondes près d'un espace sûr.

### La Réminiscence

À certains endroits, Zell active un souvenir du lieu. Voit brièvement ce qu'il était avant corruption. Lit des inscriptions effacées, révèle des passages, comprend l'origine d'ennemis.

### La Conductivité (Zone des Câbles)

Zell sert de pont électrique. Tenir position entre deux contacts pendant que l'épée est chargée → circuit. Alimente mécanismes, ouvre portes.

### Sillage de Conscience

Dash laisse un afterimage 0.5s. Cet afterimage peut activer des switchs qui "voient" Zell passer. Puzzles de timing.

### Fragmentation Volontaire (Phase 2, tard)

Zell se disperse en particules pour traverser passages étroits. Court, risqué — si touchée pendant, se recoagule endommagée.

---

## 7. Zone tuto — Les Yeux

### Vue d'ensemble

Première zone du jeu. Sombre, décorée de **Rosas** (formes circulaires géométriques violettes, dorées, roses, bordeaux — phosphènes vus les yeux fermés). Musique douce piano + flûte.

### Trois sous-zones

| Sous-zone | Position relative au spawn | Pouvoir / récompense |
|---|---|---|
| **Cristalin** | Haut-gauche | Fin de tuto, accès au mini-boss Dragon de Cristal puis Chevalier Cristallin |
| **Pupille** (zone aveugle/noire) | En bas | **Impulsion** (1er fragment) |
| **Câbles / Nerfs optiques** | À droite | **Dash horizontal** (2e fragment, déblocage par énigmes) |

Le **boss principal du tuto** (Chevalier Cristallin) est dans une arène séparée accessible après avoir résolu le Cristalin. Le **Dragon de Cristal** est un mini-boss dans la zone Cristalin qui drop le **1er fragment de souvenir lié au lore**.

### Layout détaillé du spawn

```
                    PLAFOND (continu, gros couloir)
   ┌──────────────────────────────────────────────────────┐
   │  ↑ vers Cristalin              ↑ vers ?              │
   │ ←                                                  → │
   │  ┌────────┐  (trou infranchissable)  ┌────────┐      │
   │  │ LEFT   │                          │SPAWN   │      │
   │  │ (gros  │                          │(plus   │      │
   │  │ bloc)  │                          │ petit) │      │
   │  └────────┘                          └────────┘      │
   │                  ↓ chute mortelle ↓                  │
   │                                                      │
   │  PICS MORTELS (mmmm tout en bas)  - SOL CASSABLE -   │
   │                                                      │
   │  ┌──────────────────[PORTE]──────────────────────┐   │
   │  │              ÉPÉE ENFONCÉE                    │   │
   │  │           (1ère arme du jeu)                  │   │
   │  └───────────────────────────────────────────────┘   │
   └──────────────────────────────────────────────────────┘
                                                    ↓ Pupille
```

À droite du SPAWN : **2-3 mini-plateformes flottantes** (stepping stones) qui mènent à la zone RIGHT, puis vers les Câbles.

### Éléments interactifs détaillés

- **Plateforme cassable** (`---- sol qui va cassé`) : on marche dessus une fois, elle craque, **reste cassée tout le reste du jeu**. Pas de réapparition.
- **Pics mortels** (ligne ondulée en bas du schéma) : si Zell tombe dessus, **mort instantanée** (retour au dernier neurone).
- **Mur invisible révélable par Impulsion** : certains murs ressemblent à du sol normal mais sont traversables après usage d'Impulsion (révélés temporairement). C'est l'usage clé d'Impulsion dans le tuto.
- **Coffres** : posés à divers endroits, contiennent Synapses ou un fragment de carte / objet de soin. Visibles, ouverts une fois.
- **Porte du spawn** : visuel doré, **épée enfoncée dedans** sous forme de pickup. Quand Zell récupère l'épée (après le boss), la porte devient interactable et s'ouvre vers la Phase 1.
- **Mur invisible côté gauche** : empêche Zell d'aller à gauche du spawn au début. Levé tard (probablement après le dash vertical de Phase 1, ouverture du Cristalin).

### Ennemis du tuto

Pensés **en contraste de sens** — apprendre à lire l'ennemi avant de réagir.

| Ennemi | Sens utilisé | Contre-mesure |
|---|---|---|
| **La Grosse Boule** | Voit, n'entend pas | **Refroidissement** (devient invisible à la vue) |
| **Les Aveugles** (meute) | Entendent, ne voient pas | **Rester immobile** ou se déplacer très lentement |
| **Les Filaments** | Obstacle de traversée | Couper à l'épée ou franchir au dash |

### Mini-boss Cristalin — Dragon de Cristal

Drop le **1er fragment de souvenir lié au lore** (probablement un bijou — à valider). Cristal, démarqué visuellement du reste (chair / cils). Pas de combat impossible — accessible quand on a Dash + Impulsion.

### Boss du tuto — Le Chevalier Cristallin

**Premier vrai combat du jeu + tuto épée.**

Mise en scène :
1. Zell entre dans la salle. **Excalibur** plantée dans un **rocher de chair** au centre.
2. Le Chevalier assis sur un **trône à droite**.
3. Il invite Zell à tenter de retirer l'épée. Elle y parvient (seule une porteuse digne).
4. Il se lève, la combat **loyalement**.
5. On gagne. L'épée devient pleinement sienne, animation d'obtention.
6. Le Chevalier s'incline ou se dissout.

L'**épée comme clé du tuto** : on revient au spawn, on l'insère dans la **porte scellée**, elle s'ouvre → accès à la Phase 1.

### Flow complet du tuto

1. **Réveil** au spawn avec uniquement le Refroidissement (inné)
2. Exploration : trous, mur invisible gauche, pics. Zell apprend la prudence en mourant peut-être.
3. Découverte de la **Pupille** (zone aveugle en bas) → **1er fragment = Impulsion**
4. Retour, utilisation d'Impulsion pour révéler des passages cachés / faux murs
5. Découverte des **Câbles / Nerfs optiques** (à droite) → énigmes → **2e fragment = Dash horizontal**
6. Accès au **Cristalin** (haut-gauche, demande Dash + Impulsion)
7. Mini-boss **Dragon de Cristal** → 1er fragment souvenir
8. Arène du **Chevalier Cristallin** → épée
9. Retour spawn → porte + épée → **Phase 1**

### Mécaniques de furtivité opposée

Le tuto enseigne deux modes de discrétion antagonistes :
- **Devant la Grosse Boule** : se cacher (invisible mais en mouvement)
- **Devant les Aveugles** : se figer (visible mais silencieuse)

Le joueur doit lire l'ennemi avant de réagir.

---

## 8. Phase 1 — autres zones

### Les Sinus — zone de transition (hub social)

Rôle de Dirtmouth dans Hollow Knight. Sas calme entre Les Yeux et le reste. Au moins **un Solin marchand** (fragments de carte, objets de soin). Atmosphère sobre. Un seuil.

### Oreille Gauche

Tapissée d'**herbe noire** (cils auditifs). Bribes de l'extérieur — gens qui parlent, flou comme derrière une porte. Jamais intelligible. Boss : **Le Filtre**.

### Zone de Rêve — très haut sur la map

**Pas féerique mignon. Psychédélique et perturbante.** Saturée. Géométrie impossible, gravité qui s'inverse. Plateformes qui obéissent à la logique du rêve — une plateforme "solide" peut s'effondrer si on y croit trop fort. Un souvenir où Veilae rêvait de voler est caché ici. Musique : harpe + célesta, sans rythme fixe.

### La Mémoire — zone majeure

Zone avec des chaînes. **Composée comme un réseau de neurones** (gros couloirs interconnectés).

**Salles spécifiques** (cf. photo schéma) :
- **Salle des Souvenirs** : pièce bloquée par chaînes (Spell de Fusion du Métal requis). Stocke les souvenirs collectés, rejouables individuellement.
- **Salle du Codex** : grande pièce où **toutes les espèces sont répertoriées**. Pour qu'une espèce apparaisse dans le Codex : soit une **action spécifique sur le mob**, soit l'**avoir tué N fois** (à trancher : 5 ? 10 ?). NPC associé.

Sous-zones possibles : bons souvenirs / mauvais souvenirs / archives. À concevoir en cours de prod.

Boss principal : **L'Oubli Voulu** → drop Spell de Fusion du Métal + souvenir majeur. En Phase 2, accueille le **Double**.

### Zone de Tri — boss secondaire

Archives du cerveau. Rayonnages infinis de dossiers lumineux. Clinique, blanc-gris froid. Bureaucratie de l'inconscient. Puzzles de classement. Ennemis : **Les Classeurs** (automates hostiles si on perturbe l'ordre). Boss secondaire : **Le Réviseur**. Musique : drone minimal.

### Zone des Câbles — boss secondaire + Filin

Faisceaux massifs de câbles enchevêtrés. Couleurs chaudes (orange, jaune, blanc). Système nerveux moteur/sensoriel. Certains câbles "live" infligent dégâts électriques. Mécanique : rediriger des courants. **Filin** le forgeron y vit (améliore l'épée). Ennemis : **Les Courts-Circuits**. Boss secondaire : **La Surcharge**.

### Zone Paisible — boss secondaire

Vaste, lumière ambrée douce, plateformes flottantes comme des nénuphars. Presque aucun ennemi. **Mécanique de méditation** : rester immobile quelques secondes restaure charges d'Impulsion + soigne légèrement. Inscriptions environnementales (Synapses si lues). Boss secondaire : **Le Gardien Paisible** (teste Zell mais ne veut pas se battre). Musique : vent, cordes douces.

---

## 9. Phase 2

Toutes les zones de Phase 1 sont **modifiées** :
- Visuels assombris
- Dialogues PNJ qui évoluent
- Parfois nouveaux ennemis
- Les Rosas pâlissent

À cela s'ajoutent des zones inédites.

### Les Émotions

Trois sous-zones qui saignent les unes dans les autres :
- **Tristesse** : corridors inondés, plateformes à ras d'eau, bleu-gris atténué
- **Colère** : terrain qui s'effrite, murs qui craquent, rouge intense, particules de feu
- **Joie** : aveuglement lumineux jaune-blanc, le plus grand danger est caché là

Boss : **Le Nœud Émotionnel** (3 phases, une par émotion).

### Oreille Droite

Même esthétique que la Gauche, plus intense. Sons presque clairs. On croit entendre un prénom. **Révélation narrative majeure** ici.

### La Bouche

Couleurs de bonbons (rose, bleu, vert menthe) avec sous-couche de pourriture. Plateformes en sucre qui se dissolvent. Terrain collant (chewing-gum, ralentit). Ennemis : **Les Bactéries** (se divisent au coup d'épée, max 3 générations — seul le Coup de Jus les détruit sans division) et **Les Caries** (mi-boss récurrents). Boss : **Le Festin**.

### L'Oubli

Zone instable, littéralement **incomplète**. Tuiles manquantes, salles arrêtées net. Terrain disparaît derrière Zell parfois. **Carte ne s'enregistre pas correctement** ici, par design. Contient les indices "V." disséminés. Ennemis : **Les Glitches** (mal chargés, hitbox imprévisibles, texture manquante). Boss : **Le Vide**.

### Ennemi spécial transversal — L'Ombre

Silhouette humanoïde de Zell (Phase 2), apparaît parfois dans le fond des couloirs juste pour observer. Pas hostile. Disparaît si Zell s'approche. Devient boss dans La Mémoire en Phase 2 (= **Le Double**).

---

## 10. Phase 3 — Le Cœur

Une **seule zone**, accessible uniquement à ce moment. **Élan pur vers l'avant.** Le battement de cœur devient la musique : irrégulier, lent, puis régulier. Tout pulse à chaque battement. Rouge et or.

Boss final en 3 sous-phases :
1. **Arythmie** : attaques irrégulières, patterns imprévisibles
2. **Arrêt** : silence total, tout gèle, puis un seul battement massif qui fait d'énormes dégâts
3. **Renaissance** : le cœur bat régulièrement pour la première fois, devient beau, Veilae choisit de vivre

**Coup final** : Zell ne frappe pas. Elle se place au centre. Le cœur bat une dernière fois autour. Fondu blanc. Des yeux qui s'ouvrent.

### Zone secrète — La Peau

Idée gardée en réserve, pas obligatoire dans le scope initial. Frontière du monde. Quasi-blanche. Pas d'ennemis, pas de collectibles. Cracks par moments → éclats du réel. Plus de cracks à mesure que le jeu avance.

---

## 11. PNJ

Les PNJ savent qui est Veilae. **Ils ne le lui disent jamais.** Énigmes, silences, familiarité étrange. **Non tuables** sauf si mort scriptée dans le lore.

### Profils principaux

| PNJ | Rôle | Voix abstraite |
|---|---|---|
| **Solin** | Gardien des Neurones, marchand de base (Sinus) | Bourdonnement grave calme |
| **Mémo** | Archiviste (Mémoire), gère souvenirs et Codex | Cliquetis staccato frénétique |
| **Écho** | Errant, indices cryptiques sur Veilae | Réverbération longue |
| **Filin** | Réparateur (Câbles), upgrade l'épée | Grondement mécanique |
| **Gardiens Silencieux** | Zone Paisible, offrent dons si Zell s'arrête | Aucun son |
| **Veille** | Conscience fragmentée (Oubli, très tard) | Voix exacte de Zell mais légèrement plus lente |

### Voix des PNJ

**Pas de voix humaines.** Sons abstraits. Sous-titres pour tout dialogue.

Plus de détail (citations exemple, comportement) dans `Structure_et_idées.md`.

---

## 12. Bestiaire

### Architecture ennemi

Pattern Unity composants :
- Préfab `EnemyBase` avec : Rigidbody2D, Collider2D, `HealthComponent`, `HurtboxComponent`, `HitboxComponent` (pour ses attaques), `StateMachineComponent`, `DropComponent` (ce qu'il drop à la mort)
- **Données dans ScriptableObject** : `EnemyData.asset` avec stats, sprites, AI patterns
- Spawn via prefab + data → un même squelette pour de nombreux ennemis

### Ennemis par zone (résumé)

| Zone | Ennemis principaux |
|---|---|
| Yeux (tuto) | Grosse Boule, Aveugles (meute), Filaments |
| Sinus | Aucun (zone safe) |
| Oreille Gauche | À définir |
| Mémoire | Engrammés (souvenirs cristallisés, repoussables), Effacés (effacent partie de la carte) |
| Zone de Tri | Les Classeurs (automates) |
| Câbles | Les Courts-Circuits |
| Paisible | Quasi aucun ennemi |
| Rêve | À définir, ennemis psychédéliques |
| Émotions (P2) | Larmes (Tristesse), Braises (Colère), Éclats de Joie |
| Oreille Droite | À définir |
| Bouche (P2) | Bactéries, Caries |
| Oubli (P2) | Glitches |
| Tout (P2) | L'Ombre (transversal) |

### Caractéristiques générales

- **Comportements scriptés**, pas d'IA dynamique complexe au début
- **Ennemis exclusifs à leur zone** par défaut (peut évoluer)
- Tous ont une **origine narrative** — ils ne sont pas là par hasard. Combattre dans Zell = combattre une partie de soi. Jamais dit.

---

## 13. Boss

### Pattern technique

- Préfab `BossBase` : composants similaires à ennemi + `BossPhaseManager` (gère phases multiples)
- Données dans ScriptableObject `BossData.asset`
- Salle d'arène = scène ou zone dédiée
- Lock-in : Zell ne peut pas sortir tant que le boss n'est pas vaincu
- Cinématique d'intro courte (entrée dans l'arène) + cinématique de fin (drop souvenir / capacité)

### Liste des boss principaux

| Boss | Zone | Drop |
|---|---|---|
| **Dragon de Cristal** (mini-boss) | Cristalin (tuto) | 1er fragment de souvenir |
| **Chevalier Cristallin** | Arène tuto | Épée d'énergie |
| **Filtre** | Oreille Gauche | Souvenir + ouverture du flux |
| **L'Oubli Voulu** | La Mémoire | Spell de Fusion du Métal + souvenir |
| **Nœud Émotionnel** (3 phases) | Émotions | Souvenir + ? |
| **Le Double** | Mémoire (P2) | Révélation narrative |
| **Le Festin** | Bouche (P2) | Souvenir |
| **Le Vide** | Oubli (P2) | Lettre "V." |
| **Le Cœur** (3 sous-phases) | Phase 3 | Fin du jeu |

### Boss secondaires

| Boss | Zone | Drop |
|---|---|---|
| **Le Réviseur** | Zone de Tri | Matériau rare + Synapses |
| **La Surcharge** | Câbles | Matériau rare + Synapses |
| **Le Gardien Paisible** | Paisible | Matériau rare + Synapses + sagesse |
| **Mini-boss Réseau Neuronal** | À définir | Spell Réseau Neuronal (de base) |

Détails de mise en scène dans `Structure_et_idées.md`.

---

## 14. HUD et interface

### Philosophie

L'écran de jeu doit être **vide au maximum**. Tout dans le monde. Pas de barres criardes. Pas de minimap permanente. Pas de notifications agressives.

### Éléments à l'écran (en permanence)

```
┌──────────────────────────────────────────────────┐
│  ●●●●●  ← flammèches HP en cercle (HUD séparé)   │
│  ────── ← jauge Coup de Jus (couleur de Zell)    │
│                                                  │
│                                                  │
│                       Zell                       │
│                        ●                         │
│                                                  │
│                                                  │
│ ███████ ← jauge Refroidissement (à styliser,    │
│           sur un côté de l'écran, à trancher)    │
└──────────────────────────────────────────────────┘
```

| Élément | Comportement |
|---|---|
| **HP — flammèches en cercle** | Cinq petites flammèches ambrées qui tournent en cercle dans un coin du HUD (pas autour de Zell — décision schéma mai 2026). Chaque flammèche = 1 PV. La dernière s'éteint à chaque coup. Les upgrades ajoutent des flammèches (6, 7, 8…). |
| **Jauge Coup de Jus** | Petite, près des flammèches HP. Se remplit dans la **couleur courante de Zell** (chaude par défaut, bleue en Refroidissement, etc.) |
| **Jauge Refroidissement** | Style à trancher. Probablement **sur un côté** du HUD (gauche ou droite). Se vide quand actif, se recharge à l'arrêt. |
| **Charges d'Impulsion** | **Pas dans le HUD permanent.** Apparaissent **au milieu de Zell** sous forme de **chiffres clignotants** uniquement quand Impulsion est en charge ou en cours — style **entraînement Nen HxH (Gon/Kirua)**. 3 charges max. |

### Éléments contextuels

- **Synapses** : compteur **apparaît brièvement à la récolte** (2-3s) puis disparaît. **Pas permanent** dans le HUD — c'est intentionnellement discret. (Décision schéma mai 2026.)
- **Sauvegarde auto** : petite icône (boîte de sauvegarde) **apparaît brièvement** quand une sauvegarde se déclenche (activation de neurone, transition de phase, etc.).
- **Item obtenu** : nom de l'objet + petit visuel apparaît en bas d'écran ~2s.
- **Dialogue PNJ** : boîte sobre en bas, fond légèrement opaque.

### Menu pause

Touche dédiée (Échap). Le jeu se fige sans flou. Musique légèrement atténuée.

Sections :
- **Carte** (réseau neuronal)
- **Inventaire** (sac où sont rangés les objets, les fragments de souvenirs, matériaux, etc.)
- **Spells** (capacités débloquées avec petite description)
- **Codex** *(préférence à trancher : in-menu ou exclusivement in-world dans la Salle Codex de la Mémoire — décision actuelle penchant pour in-world)*
- **Options**
- **Quitter**

### Codex — choix de design

**Décision tendance :** le Codex est principalement **in-world dans la Salle Codex** de la Mémoire — une vraie pièce du jeu, pas un onglet de menu. Donne une raison de revenir à la Mémoire, et renforce le "tout est dans le monde". À valider.

Une copie consultable dans le menu pause peut exister, mais avec moins de détails / présentation moins riche. À trancher.

### Style graphique du HUD

- Typographie unique au jeu, lisible mais discrète
- Cadres très fins, transparences importantes
- Animations apparition/disparition douces (~0.3s)
- Aucun élément qui ne **scintille pas légèrement** (cohérence avec l'univers vivant)

---

## 15. Carte du monde

**Pas une grille.** Un **diagramme de réseau neuronal** / scan synaptique.

- **Salles = nœuds**
- **Couloirs = lignes**
- **Zones découvertes : illuminées, colorées**
- **Zones non découvertes : contours fantômes**
- **Neurones-checkpoints : nœuds qui pulsent**
- **Passages secrets : lignes pointillées**
- **L'Oubli : section volontairement corrompue / incomplète**

### Gros couloirs

Décision schéma mai 2026 (post-tuto) : **"Je veux des gros couloirs UwU"** — donc on dimensionne large à partir de la Phase 1.

### Fragments de carte

Achetables chez Solin (Sinus). Chaque fragment révèle une zone voisine non explorée.

---

## 16. Mort et sauvegarde

### Mort

À chaque mort :
1. Zell éclate en particules au point de mort
2. **Synapses** restent sur place en petit amas lumineux
3. Zell se reforme au **dernier neurone activé**
4. Retourner au point de mort = récupérer les Synapses
5. Mourir avant = **perte définitive** des Synapses laissées
6. **Filet de sécurité** : 10% des Synapses sont **automatiquement épargnées** à chaque neurone activé (préservées même si on perd le tas)

**Pas de limite de morts**, pas de pénalité permanente. La mort n'est pas punitive — elle est narrative.

### Sauvegarde

**Auto** à chaque :
- Activation de neurone
- Boss vaincu
- Capacité débloquée
- Transition de phase

**Pas d'action joueur pour sauvegarder** — c'est transparent. Petit icône "boîte de sauvegarde" apparaît brièvement.

**Variables persistées** :
- Position du dernier neurone activé
- PV max et courants
- Synapses (total + 10% verrouillé)
- Capacités débloquées
- Souvenirs collectés
- Neurones activés
- Neurones cachés découverts
- Ennemis morts dans la zone courante (réinitialisés à chaque repos)
- Phase courante
- Progression PNJ
- Collectibles trouvés (lettres, pensées, fragments de portrait)
- Matériaux rares en inventaire
- Options joueur

**Implémentation Unity :**
- Sérialisation JSON dans `Application.persistentDataPath`
- Double fichier (principal + backup) pour résistance corruption
- Un slot par profil (3 max si multi-joueurs sur la même machine — à valider)

---

## 17. Monnaie — Synapses

Les **Synapses** sont les connexions biologiques entre neurones. Monnaie cohérente, immédiatement lisible.

### Gain

- Ennemis vaincus (drop variable selon difficulté)
- Zones cachées et coffres lumineux
- Récompenses de certains PNJ
- Lecture d'inscriptions dans la Zone Paisible

### Dépense

- Marchands (Solin → cartes, soins ; autres ?)
- Réparation de neurones endommagés
- Passages neuraux scellés (déblocage)
- Upgrades chez Filin

### Apparence visuelle de la Synapse

**À trancher.** Pas un dollar ni un euro. Doit ressembler à **une connexion neurale** :
- Petite **volute lumineuse en spirale** ?
- Symbole synaptique stylisé (genre `ψ` ou variante) ?
- Petit point lumineux avec arborescence ?

Décision à prendre à l'art pass.

### Affichage HUD

**Pas de compteur permanent.** Le total des Synapses **n'apparaît que** :
- Brièvement quand on en récupère (animation chiffre qui monte)
- En permanence dans le menu pause (Inventaire / Spells)
- Chez les marchands (négociation)

---

## 18. Audio

### Musique par zone

| Zone | Instruments | Ambiance |
|---|---|---|
| Les Yeux (tuto) | Piano + flûte, doux | Éveil, curiosité fragile |
| Sinus | Cordes calmes, hum doux | Seuil, transition |
| Oreille Gauche | Ambient pur, voix filtrées | Mystère, distance |
| Zone de Rêve | Harpe, célesta, arythmique | Irréel, perturbant |
| La Mémoire | Piano seul, dissonances rares | Mélancolie, poids |
| Zone de Tri | Drone minimal, hum électrique | Froid, clinique |
| Zone des Câbles | Électronique chaud, groove | Énergie, tension |
| Zone Paisible | Vent, cordes douces | Paix, respiration |
| Les Émotions (P2) | Change par sous-zone | Tristesse / Colère / Joie |
| Oreille Droite (P2) | Comme gauche, plus intense | Révélation, urgence |
| La Bouche (P2) | Jazz léger, légèrement faux | Faux-joyeux, uncanny |
| L'Oubli (P2) | Musique qui glitche et s'efface | Instabilité, angoisse |
| Le Cœur (P3) | Battement de cœur = musique | Intensité pure |

### Pas de leitmotiv central

Pas de mélodie de Veilae à transformer à travers le jeu. Chaque zone a sa propre identité musicale.

### Battement de cœur méta

Battement très lent et grave sous **toute** la musique du jeu, quasi-imperceptible. En Phase 3 il devient explicite — le joueur ressent une reconnaissance sans savoir pourquoi.

### Sons du monde extérieur

Toujours **étouffés, filtrés** comme entendus du fond d'un bain. Jamais intelligibles en Phase 1. Presque clairs en Phase 2. Plus présents en Phase 3. La voix finale **"Veilae..."** est complètement claire.

### Musique réactive

La mélodie de zone joue différemment selon l'état de Zell :
- Version propre à pleine santé
- Dissonances quand endommagée
- Intensification en combat
- Fragmentation en état critique

### Sources audio

Pour les premières versions : libre de droits acceptable (freesound.org). À remplacer par compositions originales avant release.

---

## 19. Direction artistique

### Style général

- **Onirique, lisse, peint** — type Hollow Knight Silksong / Ori and the Blind Forest
- **PAS de pixel art**
- **Style personnel** : pas une copie servile de Silksong, ZELL a son univers (chair, neurones, Rosas, brume noire). Référence pour le rendu, pas pour le contenu.

### Palette

- **Phase 1** : violet, doré, rose, bordeaux, noir profond
- **Phase 2** : palette qui s'assombrit, bleus froids, rouges ajoutés
- **Phase 3** : rouge et or dominants
- **VERT INTERDIT** dans tout le jeu **sauf zones glitchées / corrompues** (Oubli). Règle stricte.

### Effets globaux

- **Glow / Bloom** omniprésent mais maîtrisé (URP Volume Bloom)
- **Light 2D** (URP 2D) pour l'éclairage local (la boule de Zell projette de la lumière sur les murs)
- **Particules** lumineuses partout (poussière, vapeur, éclats)
- **Flou directionnel léger** en mouvement
- **Vibration subtile** sur les éléments importants (Rosas, neurones, souvenirs)

### Composition par couches (parallaxe profonde)

Inspiré du dispositif déjà testé en Godot (3 plans rosaces + brume + chair). Tradition Silksong / Ori. Structure standard pour chaque zone :

```
PREMIER PLAN (devant Zell)         ← brume, herbes, particules
  ↓
COUCHE GAMEPLAY (sol, plafond)     ← collisions + Sprite Shape (chair organique)
  ↓
ARRIÈRE-PLAN PROCHE (×0.7)         ← formes proches, détails
  ↓
ARRIÈRE-PLAN LOINTAIN (×0.4)       ← grandes formes, silhouettes
  ↓
CIEL / FOND ULTIME (×0.1)          ← couleur, brouillard
```

### Méthode de production

- **Sprites et arrière-plans faits à la main** dans Krita
- **Aide IA** possible pour passes initiales (génération, exploration de directions)
- **Retouche manuelle obligatoire** avant import Unity
- **Sprite Shape** Unity pour le sol/plafond organique (chair onduleuse) — texture de bord (cils + chair) + fill (chair intérieure)

### Cohérence

Chaque zone a son sous-univers visuel. Les ennemis d'une zone partagent un langage visuel commun. L'UI est minimale et intégrée au monde quand possible.

### Inspirations

- **Hollow Knight: Silksong** (lissé, parallaxe, light 2D, brume)
- **Ori and the Blind Forest** (couleur, fluidité, particules)
- **NineSols** (style BD différent, à NE PAS imiter)
- **HxH** pour les chiffres clignotants des charges d'Impulsion (Gon/Kirua training Nen)

---

## 20. Cinématiques

### Cinématique d'ouverture

Écran noir total.
```
Sirène d'ambulance lointaine     → fade out progressif
Bip respiratoire d'hôpital       → fade out progressif
Silence total                    → 3 secondes
Zell s'allume                    → apparition douce, flamme dans le noir
Fondu musique des Yeux           → monte doucement
```
**Aucun texte. Aucune explication.** Enchaîne directement sur le gameplay.

### Cinématique de fin

- Le Cœur bat pour la première fois régulièrement
- Fondu au blanc total
- Vue extérieure brève (hôpital ?) — les yeux de Veilae s'ouvrent
- Voix d'un membre de la famille proche : **"Veilae..."**
- Fondu au blanc à nouveau
- Crédits

### Transitions de phase (mini-cinématiques ~3s)

- **Phase 1 → 2** : flash blanc, transformation de Zell (boule → humanoïde), pause d'écran
- **Phase 2 → 3** : entrée dans Le Cœur, l'arène se révèle, battement de cœur devient la musique

### Direction

- **Pas d'animations complexes**
- **Composition par tableaux fixes + transitions**
- Le **son fait 80% du travail émotionnel**

---

## 21. Accessibilité

### Modes de difficulté

- **Mode Narration** : combat allégé, checkpoints fréquents, peu de Synapses perdues à la mort. Pour ceux qui veulent l'histoire.
- **Mode Standard** : l'expérience telle que conçue.
- **Mode Épreuve** : ennemis plus durs, checkpoints rares, pertes accrues, aucune aide carte.

### Options

- **Daltonisme** : alternatives visuelles pour les codes couleur émotionnels
- **Réduction / désactivation du screen shake**
- **Vitesse de texte** ajustable
- **Maintien automatique** de touches (pour éviter le crampage)
- **Sous-titres** pour tous les sons importants
- **Contraste élevé** optionnel

### Mappage des touches

- Reconfigurable sur clavier et manette
- Présets prédéfinis (gaucher, mains réduites, etc.)

---

## 22. Tech stack Unity

| Couche | Choix |
|---|---|
| **Engine** | Unity 6.3 LTS (`6000.3.16f1`) |
| **Pipeline** | Universal 2D (URP 2D Renderer) |
| **Langage** | C# (Visual Studio Community 2026) |
| **Input** | New Input System (legacy `Input` fallback OK pour itérations rapides) |
| **Caméra** | Cinemachine (à intégrer plus tard pour le feel pro) |
| **Terrain** | Sprite Shape (sol/plafond organique) + Tilemap si besoin pour zones plus géométriques |
| **Lumière** | Light 2D (URP 2D) + Global Light |
| **Post-process** | Volume + Bloom (URP) |
| **Shaders** | ShaderGraph en priorité, `.hlsl` brut si besoin spécifique (brume FBM…) |
| **Particules** | Built-in Particle System Unity (suffit pour 2D) |
| **Audio** | AudioMixer Unity + AudioListener spatialisé |
| **UI** | UI Toolkit (UI moderne basée sur USS/UXML) ou uGUI classique — **à trancher**, probablement uGUI pour simplicité au début |
| **Texte** | TextMeshPro |
| **Animation** | Animator + Animation Clips ; tweens via DOTween si nécessaire (à installer si besoin) |

### Build

- **Cible primaire** : Windows IL2CPP (compilation native, plus rapide que Mono)
- Console plus tard

---

## 23. Architecture du projet

### Structure de dossiers

```
C:\Projects\zell\                  ← racine projet (HORS OneDrive)
├── .git/                          ← versionnement
├── .claude/                       ← skills Claude
│   └── skills/
│       └── lancer-unity/SKILL.md
├── Assets/                        ← projet Unity
│   ├── Art/                       ← sprites, textures (PNG)
│   │   ├── Sprites/               ← placeholders (WhiteSquare, SoftCircle)
│   │   └── prem_graph.png         ← BG legacy
│   ├── Audio/                     ← .wav, .ogg (à venir)
│   ├── Editor/                    ← scripts éditeur (SetupTutoStart, etc.)
│   ├── Prefabs/                   ← préfabs réutilisables (à venir)
│   ├── Scenes/                    ← .unity (TutoStart, SampleScene, etc.)
│   ├── ScriptableObjects/         ← data assets (EnemyData, BossData, etc.)
│   ├── Scripts/                   ← code de runtime
│   │   ├── PlayerController.cs
│   │   ├── EnergyOrbVisual.cs
│   │   └── (à venir : Health, Hurtbox, Hitbox, etc.)
│   ├── Settings/                  ← UniversalRP, Renderer2D, VolumeProfiles
│   └── Shaders/                   ← .shadergraph, .hlsl (à venir)
├── Packages/                      ← manifest UPM
├── ProjectSettings/               ← config projet Unity
├── Source_Art/                    ← sources Krita (HORS Unity, gitignorée pour .kra)
│   ├── Prem graph.kra
│   ├── Noeil.kra
│   └── Les Rosaces.html
├── Library/, Logs/, UserSettings/ ← local Unity, gitignorés
├── CAHIER_DES_CHARGES.md          ← CE document
├── Structure_et_idées.md          ← lore détaillé
├── CLAUDE.md                      ← règles pour l'IA
└── .gitignore
```

### Backup .kra externe

Les fichiers Krita sources (.kra, lourds, gitignorés) sont **doublés dans OneDrive** :
`C:\Users\paulc\OneDrive\Backup_Zell_Sources\`

Cette copie sert de filet de sécurité cloud (OneDrive sync). Mise à jour à chaque grosse session Krita.

### Pattern composants

```
Player GameObject
├── Rigidbody2D
├── CircleCollider2D
├── PlayerController.cs            ← input + movement
├── HealthComponent.cs (à créer)   ← PV, mort
├── HurtboxComponent.cs (à créer)  ← reçoit les dégâts
├── HitboxComponent.cs (à créer)   ← inflige les dégâts (épée)
└── Visual (child)
    ├── EnergyOrbVisual.cs         ← pulse + drift
    ├── OrbOuter, OrbMid, OrbInner, OrbCore (SpriteRenderer)
    └── OrbLight (Light 2D)
```

### Data-Oriented (ScriptableObjects)

Tout ce qui est **contenu** (ennemis, boss, dialogues, items, souvenirs, zones) dans des `ScriptableObject` réutilisables, pas hardcodé.

Exemples (à créer) :
- `EnemyData.asset` (sprite, PV, dégâts, drop loot, AI pattern key)
- `BossData.asset` (phases, attaques par phase, drops)
- `MemoryData.asset` (souvenir : titre, contenu, source boss, lore)
- `DialogueData.asset` (lignes de dialogue, branchements)

### Autoloads (singletons Unity)

À mettre en place via `DontDestroyOnLoad` ou pattern `Singleton<T>` :
- **GameManager** : état global, phase courante, sauvegarde
- **AudioManager** : musique, sons, transitions
- **SceneManager** custom : chargement zones avec fade
- **DialogueManager** : lecture dialogues, branchements
- **InputManager** : abstraction au-dessus du New Input System

### Texte / i18n

**Aucun texte en dur dans le code.** Tous les textes dans des ressources / JSON / CSV référencés par clés. Permet réécriture + traduction sans toucher au code. À mettre en place dès que le premier dialogue arrive.

### Conventions

- **Une scène par zone** (ex : `TutoStart.unity`, `Sinus.unity`, `Memoire.unity`).
- **Préfabs réutilisables** pour les éléments répétés (porte, neurone, coffre, plateforme cassable, pic, mur invisible).
- **Layers Unity** :
  - 0 : Default
  - 8 : Player
  - 9 : Ground
  - 10 : Enemy
  - 11 : EnemyHurtbox
  - 12 : PlayerHitbox
  - 13 : InteractZone
  - (à finaliser quand on en a besoin)
- **Tags** : `Player`, `Enemy`, `Boss`, `Interactable`, `Killzone`, `Checkpoint`.

---

## 24. Workflow de production

### Cycle d'itération

1. **Spec** : design dans le CDC (ce doc) — qu'est-ce qu'on fait, pourquoi
2. **Blockout** : implémentation rapide dans Unity avec primitives (rectangles, cercles) — valider la mécanique
3. **Iter** : tester en Play Mode, ajuster les valeurs
4. **Art** : remplacer les placeholders par les vrais assets Krita
5. **Polish** : effets, lights, particules, audio
6. **Verif** : skill `lancer-unity` pour compile check + capture
7. **Commit + push** : auto après chaque modif validée

### Workflow Krita → Unity

Pour chaque asset :
1. **Krita** : dessiner sur calques séparés (un canvas 1920×1080 ou plus, selon)
2. **Export** : `File → Export advanced` ou `Save current layer as image`, format PNG transparent
3. **Import Unity** : déposer dans `Assets/Art/` (sous-dossier approprié)
4. **Réglages d'import** : Texture Type = Sprite (2D and UI), Pixels Per Unit = 100 (par défaut), Filter Mode = Bilinear, Compression = High Quality (ou aucune si on veut zéro perte)
5. **Tileable ?** Si oui, dans Krita activer Wrap Around Mode (W) pendant le dessin, et dans Unity `Wrap Mode = Repeat`.

### Workflow Sprite Shape (pour sol/plafond organique)

1. Dans Krita, dessiner :
   - **`edge_top.png`** : bande horizontale (2048×512) avec cils noirs en haut + chair en bas. **Tileable horizontal** (mode Wrap dans Krita).
   - **`fill_chair.png`** : carré de chair pure (1024×1024). **Tileable h+v**.
2. Dans Unity :
   - Créer un **Sprite Shape Profile** asset
   - Assigner `edge_top` à l'angle "horizontal up", `fill_chair` au "fill"
   - Sur la scène, créer un **Sprite Shape Controller** GameObject
   - Tracer la courbe avec l'outil plume (clics, points de contrôle)
   - Le terrain organique se génère automatiquement

### Versionnage git

- **`master`** : branche principale, projet Unity actif
- **`legacy_godot`** : archive de l'ancienne version Godot (gardée en référence)
- **`origin`** : `https://github.com/Ito-x/Zell.git`

**Auto-commit + push** après chaque modif validée (cf. règle dans CLAUDE.md).

### Skill Claude `lancer-unity`

Trois usages :
1. **Compile check** headless (rapide, ~30 s) → valide les scripts C#
2. **Capture screen** d'une scène via script Editor `SceneCapture.cs` (à créer au 1er besoin, template dans le skill)
3. **Lancement interactif** de Unity

Détails dans `.claude/skills/lancer-unity/SKILL.md`.

### Règles anti-pièges (cf. CLAUDE.md)

- **NE JAMAIS** mettre le projet dans OneDrive (sync conflicts, lock files). Le projet vit dans `C:\Projects\zell\`.
- Les `.kra` sont gitignorés (lourds). Backupés à part dans OneDrive.
- Library/, Temp/, Logs/, UserSettings/, *.slnx → gitignorés.
- Toujours `Universal 2D` à la création de nouveau projet Unity.

---

## 25. État actuel du projet

**Date de cette refonte : mai 2026.**

### Ce qui est fait

| Élément | Statut |
|---|---|
| Bascule Godot → Unity 2D URP | ✅ Faite |
| Projet Unity créé (`Universal 2D`, 6.3 LTS) | ✅ |
| Projet déplacé hors OneDrive (`C:\Projects\zell\`) | ✅ |
| Repo git restructuré, branche `legacy_godot` archive | ✅ |
| Backup `.kra` dans OneDrive | ✅ |
| Skill Claude `lancer-unity` (compile check OK testé) | ✅ |
| Scène `TutoStart.unity` blockout (3 plateformes + sol bas + porte placeholder + murs) | ✅ |
| Player boule d'énergie multi-couches (placeholder) | ✅ |
| `PlayerController.cs` : mouvement Q/D + Espace, raycast ground | ✅ |
| `EnergyOrbVisual.cs` : pulse + drift sinusoidal | ✅ |
| `SetupTutoStart.cs` (Editor) : génère la scène en code | ✅ |
| Sprites placeholder auto-générés (WhiteSquare, SoftCircle) | ✅ |
| Light 2D globale + Light 2D ponctuelle sur Zell | ✅ |
| Compile clean, scene se charge, scripts compilent | ✅ |

### Ce qui n'est pas encore fait (priorité courante)

| Élément | Priorité | Notes |
|---|---|---|
| Tester le blockout en Play Mode | 🔴 **À faire en premier** | Paul doit valider movement, saut, distances, caméra |
| Cinemachine pour la caméra | 🟠 | Follow + damping, donne le feel pro |
| Cubes obstacles sur les plateformes (cf. schéma photo) | 🟠 | Petits blocs à grimper, donne du relief |
| Plateforme cassable | 🟠 | Mécanique scriptée (trigger → destroy after delay) |
| Pics mortels | 🟠 | Killzone trigger → respawn |
| Mur invisible révélable par Impulsion | 🟡 | Plus tard, quand on aura Impulsion |
| Coffres avec récompenses | 🟡 | Préfab `Chest` + ouverture |
| Porte interactive + pickup épée | 🟡 | Interaction E + check possession épée |
| Sprite Shape pour sol/plafond organique | 🟡 | Quand on aura les textures Krita |
| Backgrounds parallaxes Krita | 🟡 | Quand Paul aura dessiné |
| HUD (flammèches HP, jauge Coup de Jus) | 🟡 | Plus tard, après gameplay validé |
| Ennemis tuto (Grosse Boule, Aveugles, Filaments) | 🟢 | Plus tard |
| Boss Chevalier Cristallin | 🟢 | Plus tard |
| Sinus + zones Phase 1 | 🟢 | Phase production longue |

🔴 Bloquant / urgent — 🟠 Prochain sprint — 🟡 Sprint suivant — 🟢 Plus tard

### Boule d'énergie placeholder vs final

L'implémentation actuelle (4 couches SpriteRenderer + Light 2D) est **fonctionnelle pour itérer le gameplay**. Le rendu final (boule plus belle, animations de Refroidissement / Impulsion / Dash) viendra après validation du movement.

### Décisions tranchées récemment (mai 2026)

| Date | Décision |
|---|---|
| mai 2026 | Switch Godot → Unity 2D URP |
| mai 2026 | Pas de bras / jambes pour la boule d'énergie en Phase 1 (juste la boule) |
| mai 2026 | Mouvement AZERTY Q/D (pas A/D) |
| mai 2026 | Projet hors OneDrive obligatoire (`C:\Projects\zell\`) |
| mai 2026 | HP affichés en **flammèches qui tournent en cercle dans le HUD** (séparé du player, plus simple) |
| mai 2026 | Charges d'Impulsion = **chiffres clignotants au milieu de Zell** style HxH Nen |
| mai 2026 | Synapses **pas en compteur permanent**, apparaissent à la récolte |
| mai 2026 | Codex tendance **in-world dans Salle Codex de la Mémoire** |
| mai 2026 | Carte = **réseau neuronal**, gros couloirs post-tuto |
| mai 2026 | Sprite Shape pour sol/plafond organique (pas tilemap) |

---

## 26. Roadmap immédiate

### Sprint actuel — Valider le blockout

1. **Paul ouvre Unity sur `TutoStart.unity`, appuie Play**
2. Valide : Q/D bouge la boule, Espace saute, trou gauche infranchissable, trou droit franchissable via stepping stones, caméra suit
3. Si OK → on continue. Si bugs → on debug.

### Sprint suivant — Détails gameplay du tuto

1. **Cinemachine** pour la caméra (smooth follow + damping + lookahead)
2. **Cubes obstacles** sur les plateformes (jumping puzzles intra-plateforme)
3. **Pics mortels** + killzone + respawn au spawn (système de checkpoint basique)
4. **Plateforme cassable** : préfab `BreakablePlatform`, trigger sur step, destroy after delay + state global "déjà cassée"

### Sprint suivant — Mécaniques avancées du tuto

1. **Porte interactive** : trigger E + check possession épée → ouvre
2. **Épée pickup** sur la porte : visuel + interaction E → ajoute épée à l'inventaire + active combat
3. **Coffres** : préfab `Chest` + ouverture animation + drop Synapses
4. **Mur invisible révélable** : sprite avec collider + script `RevealableWall` qui devient visible pendant 2-3s quand Impulsion frappe

### Sprint art — Intégration premier asset Krita

1. Paul dessine premier asset : **`edge_top.png`** + **`fill_chair.png`** pour Sprite Shape
2. Setup Sprite Shape Profile dans Unity
3. Remplacer les blocs gris du blockout par Sprite Shape
4. Premier rendu artistique de la zone tuto

### Sprint art — Backgrounds parallaxe

1. Paul dessine `bg_ciel`, `bg_lointain`, `bg_proche` (4096×1080 ou approchant)
2. Setup parallaxe Unity (script `Parallax2DLayer` à créer)
3. Volume Bloom URP pour le glow ambiant

### Sprint ennemis — Premier mob

1. Architecture composants : `HealthComponent`, `HurtboxComponent`, `HitboxComponent`, `StateMachineComponent`
2. Premier ennemi : **La Grosse Boule** (mob lent, voit, sourd, contré par Refroidissement)
3. Préfab + ScriptableObject `EnemyData`

### Sprint combat — Épée + Coup de Jus

1. **Épée** : préfab arme avec `HitboxComponent`, animation swing, slash visuel arc blanc-or
2. **Jauge Coup de Jus** : remplissage au hit, déclenchement à pleine, désarmement du mob
3. HUD jauge dans la couleur de Zell

### Sprint boss — Chevalier Cristallin

1. Arène boss, scène dédiée
2. Mise en scène (entrée, Excalibur, trône, retrait, duel)
3. `BossPhaseManager`, 1-2 phases pour ce 1er boss
4. Drop = épée définitive (`PlayerInventory.UnlockSword()`)

### Suivant — Sinus + Phase 1 zones

Plus loin dans la prod. On verra quand le tuto est complet et jouable.

---

## 27. Points reportés

Ces points ne bloquent pas la production. Ils seront tranchés plus tard, ou laissés ouverts pour évoluer.

### Visuel

- **Pieds / bâtons / juste flotte** pour Zell après le 1er fragment ? → pour l'instant juste flotte
- **Symbole de Synapse** : volute, ψ, autre ?
- **Style HUD précis** : maquette à designer avec Claude
- **Codex in-menu ou exclusivement in-world** ?
- **Salle des Souvenirs : layout exact**
- **Le Mémoire = composé comme un réseau de neurones** — concrètement à dessiner

### Mécaniques

- **Système de carte détaillé** (interaction, marqueurs, zoom, etc.)
- **Système de menu / codex détaillé**
- **Mécanique de nage** (Tristesse Phase 2)
- **Sort de La Peau** (idée gardée, scope incertain)
- **Forme exacte de L'Oubli**
- **Sous-zones de La Mémoire** (bons/mauvais souvenirs/archives)
- **Codex : action sur mob ou nombre tués ?** (5 ? 10 ?)
- **Quêtes secondaires des PNJ**
- **Réactions des PNJ entre phases**

### Audio

- **Composition originale** (libre de droits acceptable pour le proto)
- **Voix abstraites par PNJ** : à designer/synthétiser

### Tech

- **UI Toolkit ou uGUI ?** → probablement uGUI pour simplicité, à confirmer
- **Cinemachine** : intégration et présets
- **DOTween** : à installer si on a besoin de tweens fluides
- **Système de localisation** : choisir entre `Unity Localization Package`, JSON maison, ou autre
- **Slots de sauvegarde** : 1 vs 3 multi-joueurs

### Lore

- **Noms définitifs** de certaines zones secondaires (Câbles, Tri, Paisible…)
- **Bestiaire détaillé** par zone Phase 1 et 2
- **Mécanique de retour à la Salle des Souvenirs** : forcée à un moment, ou libre ?

---

*Pour les détails narratifs (zones spécifiques, boss spécifiques, dialogues exemples, voix des PNJ), voir `Structure_et_idées.md`.*

*Pour les règles à respecter par Claude lors du dev, voir `CLAUDE.md`.*

*Pour la chaine de production technique, voir `.claude/skills/lancer-unity/SKILL.md`.*
