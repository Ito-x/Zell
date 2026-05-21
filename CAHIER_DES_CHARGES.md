# ZELL — Cahier des Charges

## 1. Vision & Identité

- **Genre :** Metroidvania 2D onirique
- **Concept :** Exploration de l'esprit de Veilae, une adolescente dans le coma
- **Style visuel :** Dessin animé flou, féerique, forte présence de particules et d'effets lumineux (Glow/Bloom)
- **Narration :** Environnementale, révélant l'identité de Veilae (alias Zell) au fil de l'aventure

---

## 2. Évolution du Protagoniste

| Phase | Forme | Déclencheur |
|-------|-------|-------------|
| 1 | Orbe d'énergie née du choc | Début du jeu |
| 2 | Forme humanoïde féminine d'énergie | Révélation narrative |

- **Nom complet :** Veilae (révélé à la fin)
- **Surnom :** Zell

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

## 4. Milestones

### 🟣 MILESTONE 0 — Prototype de mouvement ✅
- CharacterBody2D avec mouvement horizontal et saut
- Physique avancée : Coyote time, Jump buffering, accélération/friction
- Caméra 2D avec limites de zone

### 🟡 MILESTONE 1 — Combat & "Coup de Jus"
- Attaque : Épée d'énergie (Area2D) avec animations
- Mécanique unique : "Coup de Jus" — désarme les ennemis (l'ennemi tente de récupérer son arme)
- Système de vie, frames d'invincibilité, Game Over

### 🟠 MILESTONE 2 — Zone Tutorielle
- Zone : "Les Yeux" (ambiance sombre, palette violet/doré/rose)
- Checkpoints : Neurones de sauvegarde (type Elden Ring)
- Carte : Système de Fog of War et marqueurs de neurones

### 🟠 MILESTONE 3 — Navigation
- Système de carte avec Fog of War
- Marqueurs de neurones (checkpoints)

### 🟢 MILESTONE 4 — Spells
- **Spell Fusion du Métal :** Détruit les obstacles métalliques (chaînes, cadenas)
- **Spell Réseau Neuronal :** Fast travel entre les neurones connectés

### 🟢 MILESTONE 5 — Progression
- Amélioration de l'épée (5 niveaux : portée, dégâts, paralysie finale)

---

## 5. Systèmes Clés

### GameManager (Autoload)
- Sauvegarde JSON/Resource
- État global du jeu
- Souvenirs collectés
- Sorts débloqués
- Phases de Veilae

### Composition par composants
Utilisation systématique de composants (`HealthComponent`, `HitboxComponent`, etc.) pour éviter l'héritage complexe.

### IA Ennemis
Machine à états finis (FSM) pour :
- Patrouilles
- Détection du joueur
- Comportements de combat
- Récupération d'arme (mécanique "Coup de Jus")

---

## 6. Direction Artistique

- **Palette principale :** Violet, doré, rose, noir profond
- **Effets :** Glow/Bloom omniprésent, particules lumineuses
- **Ambiance :** Onirique, intérieur de l'esprit, organique
- **Inspirations visuelles :** Hollow Knight, Ori and the Blind Forest
