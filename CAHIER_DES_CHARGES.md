# ZELL — Cahier des Charges

## 1. Vision & Identité

- **Nom du jeu :** **Zell**
- **Genre :** Metroidvania 2D onirique
- **Concept :** Exploration de l'esprit de Veilae, une adolescente (~18 ans) dans le coma suite à un accident de voiture involontaire (traité de façon délibérément floue)
- **Style visuel :** Dessin animé flou, féerique, forte présence de particules et d'effets lumineux (Glow/Bloom). **Graphismes faits à la main, avec aide IA.**
- **Plateformes :** PC + console
- **Narration :** Environnementale, mystérieuse. Le vrai nom (Veilae) est révélé à la fin par la voix d'un membre de la famille proche.

---

## 2. Évolution du Protagoniste

| Phase | Forme | Déclencheur |
|-------|-------|-------------|
| 1 | Orbe d'énergie née du choc | Début du jeu |
| 2 | Forme humanoïde féminine d'énergie | Révélation narrative |
| 3 | Course finale dans Le Cœur | Boss final |

- **Nom complet :** Veilae (provisoire, révélé à la fin)
- **Surnom :** Zell
- **Profil :** Enfant unique, ~18 ans

---

## 3. Architecture Technique (Godot 4.x)

```
ZELL/
├── scenes/
│   ├── player/
│   ├── enemies/
│   ├── world/
│   ├── ui/
│   ├── bosses/
│   └── zones/
├── scripts/
│   ├── autoloads/     → GameManager.gd, AudioManager.gd
│   ├── components/    → Health, Hitbox, Hurtbox, StateMachine
│   └── resources/     → SpellData, UpgradeData
├── assets/
│   ├── sprites/
│   ├── audio/
│   ├── fonts/
│   └── shaders/
└── project.godot
```

---

## 4. 🔴 Priorités immédiates — À bosser en premier

Trois systèmes structurants à concevoir avant le reste. Ils conditionnent tout le code à venir.

### 4.1 Boucle de combat — PRIORITÉ #1

À détailler concrètement avant la moindre ligne de code combat :

- Touches actives en combat (déplacement, saut, attaque, dash, spell, soin)
- iframes sur le dash : oui / non / partielles ?
- Heal en combat : possible ou pas ? Avec quelle ressource ?
- Combos d'épée : enchaînement 3-coups ou attaques indépendantes ?
- Parry / déflection ?
- PV de base de Zell (proposition : 3-4 coups)
- Dégâts de base de l'épée (proposition : 2-3 coups pour tuer un ennemi standard)
- Stamina : oui / non ?
- **Coup de Jus** ✅ tranché : jauge qui se remplit en frappant les ennemis (mécanique "ultimatum"), pas un cooldown

→ *Décrire 30 secondes de gameplay typique dans une salle avec 2 ennemis.*

### 4.2 Système de transitions — PRIORITÉ #2

À concevoir :

- Comment on passe d'une scène/zone à l'autre techniquement (loading, persistance d'état)
- Visuel des transitions (fondu, fenêtre, panneau...)
- Persistance du joueur (position, PV, jauge)
- Persistance du monde (ennemis vaincus restent-ils morts ? Cf. choix HK vs Celeste)
- Cas spécial : Les Sinus (zone de transition centrale, Dirtmouth-like) — point de passage entre toutes les zones principales

### 4.3 Système de mort — PRIORITÉ #3

À concevoir :

- Que se passe-t-il à la mort de Zell (visuel, sons, où on respawn)
- **Décidé** : pas de limite de morts, pas de pénalité permanente
- Synapses (monnaie) laissées au point de mort, à récupérer
- Filet de sécurité : 10% des Synapses sauvegardées à chaque neurone (proposition)
- Les ennemis respawnent-ils ? À trancher
- Respawn au dernier neurone visité, ou neurone "ancré" choisi explicitement ?
- Écho de Mort : silhouette fantôme rejouant les derniers instants → à valider

---

## 5. Milestones

### 🟣 MILESTONE 0 — Prototype de mouvement ✅
- CharacterBody2D avec mouvement horizontal et saut
- Physique avancée : Coyote time, Jump buffering, accélération/friction
- Caméra 2D avec limites de zone

### 🟡 MILESTONE 1 — Combat & "Coup de Jus" (priorité absolue après le détail du 4.1)
- Attaque : Épée d'énergie (Area2D) avec animations
- **Coup de Jus** : désarme les ennemis via jauge se remplissant en frappant ; l'ennemi tente de récupérer son arme
- Système de vie, frames d'invincibilité, Game Over (cf. §4.3)

### 🟠 MILESTONE 2 — Zone Tutorielle : Les Yeux
- Ambiance sombre, Rosas violettes/dorées/roses/bordeaux
- Checkpoints : Neurones de sauvegarde
- Mini-boss : Aveugle géant (version plus forte, avec features additionnelles)
- 4 fragments de souvenirs débloquant : épée, dash (ou mini-téléportation), double saut, grimper

### 🟠 MILESTONE 3 — Navigation
- Système de transitions inter-zones (cf. §4.2)
- Zone de transition centrale : **Les Sinus** (au moins un marchand pour la carte)
- Carte : Fog of War, marqueurs de neurones

### 🟢 MILESTONE 4 — Spells
- **Fusion du Métal :** Détruit chaînes/cadenas
- **Réseau Neuronal :** Fast travel — déblocage en deux temps : 1) battre un mini-boss, puis 2) exploration

### 🟢 MILESTONE 5 — Progression
- Amélioration de l'épée (5 niveaux : portée, dégâts, **paralysie réservée au dernier niveau uniquement**)
- HP augmentables
- Impulsion : pas d'amélioration prévue

---

## 6. Systèmes Clés

### GameManager (Autoload)
- Sauvegarde JSON/Resource
- État global du jeu, souvenirs collectés, sorts débloqués, phase de Veilae

### Composition par composants
Utilisation systématique de composants (`HealthComponent`, `HitboxComponent`, etc.) pour éviter l'héritage complexe.

### IA Ennemis
Machine à états finis (FSM) pour patrouilles, détection, combat, récupération d'arme (Coup de Jus).
- **Ennemis non pacifiables** : comportements scriptés à l'avance. Toute amitié possible est écrite dans le lore.
- **Ennemis exclusifs à leur zone** (à confirmer)

### PNJ
- Connaissent Veilae sans le lui dire, mystérieux
- Certains agissent comme des amis de longue date
- **Non tuables** sauf cas scripté

---

## 7. Direction Artistique

- **Palette principale :** Violet, doré, rose, noir profond
- **Effets :** Glow/Bloom omniprésent, particules lumineuses
- **Ambiance :** Onirique, intérieur de l'esprit, organique
- **Inspirations visuelles :** Hollow Knight, Ori and the Blind Forest
- **Méthode :** Graphismes faits à la main, avec aide IA (workflow à formaliser : génération → retouche → import Godot)

### Géographie de la map (logique anatomique)
- Oreilles → sur les côtés
- Nez → en bas (zone optionnelle)
- Cerveau / Mémoire → en haut
- Cœur → au centre, accessible uniquement en Phase 3
- Zone de Rêve : très haut, ambiance **psychédélique / perturbante** (rainbow ivre, pas féerique mignon)
- Les Sinus : zone de transition centrale (Dirtmouth-like)

---

## 8. Reporté au polissage / à voir

Ces points ne bloquent pas la production mais restent à trancher plus tard :

- Noms définitifs des zones secondaires (Câbles, Tri, Paisible, etc.)
- Système de carte détaillé
- Système de menu / codex
- Système de nage (zones inondées)
- Détail du système d'upgrades
- Le dash : mini-téléportation ou autre ?
- Sort de la zone La Peau (idée gardée en réserve)
- L'Oubli : forme exacte non tranchée
- Sous-zones de La Mémoire
