# HANDOVER — Session du 27 mai 2026

> Document de passage entre sessions. À lire en début de session pour reprendre
> rapidement le contexte. Mis à jour à chaque fin de session si Paul le demande.

---

## TL;DR (30 secondes)

Cette session, on est partis d'un projet Unity 2D URP fraîchement créé (couleurs bleues, blockout TutoStart minimal) et on a atterri avec :

- **Player boule d'énergie warm** (ambre/or/orange) avec trail subtil, saut variable, dash Radagon-like (clic droit, mini-téléportation + i-frames + visuels électriques cyan), hooks clic gauche pour attaque.
- **Caméra `FollowCamera2D` custom** (damping + dead zone + lookahead) sans Cinemachine.
- **Scène TutoStart agrandie** : monde ×2, vide vertical ×5 sous le sol haut (pour future descente), SpawnPlatform encore ×4 chaque côté (96 unités de large), porte gigantesque 16×24.
- **3 skills d'équipe** dans `.claude/skills/` : `lancer-unity`, `montrer-capture`, `relance-unity-fin-feature`.
- **CDC réécrit de zéro** en 27 sections cohérentes Unity.
- **AZERTY corrigé** : `Keyboard.current.aKey` (= touche Q physique sur AZERTY) — Unity utilise positions US.

Paul n'a pas encore re-testé la dernière itération (SpawnPlatform ×4 + porte gigantesque). À faire en premier demain.

---

## État du projet à la fin de session

### Scène `Assets/Scenes/TutoStart.unity` (dimensions actuelles)

| Élément | Position | Taille | Notes |
|---|---|---|---|
| Plafond | (0, 18) | 240 × 4 | très large, couvre la map étendue |
| SolGauche | (-86, -2) | 28 × 4 | inaccessible depuis spawn (gap ~38 units) |
| **SolSpawn** | (0, -2) | **96 × 4** | "très long couloir", sort des 2 côtés écran |
| SolDroite | (86, -2) | 28 × 4 | accessible via stepping stones |
| MiniPlat1 / 2 / 3 | x = 55, 62, 69 | 4.4 × 2 | gaps 4.8 / 2.6 / 2.6 / 0.8 (jumpables) |
| SolBas | (0, -84) | 240 × 8 | vide ×5 sous sol haut |
| **Porte** | (0, -68) | **16 × 24** | gigantesque, sprite seul (pas de collider) |
| MurGauche / Droit | x = ±110 | 4 × 120 | containment |

**Player spawn** : (0, 2). Tombe sur SolSpawn.

### Scripts en place

- `Assets/Scripts/PlayerController.cs` — input AZERTY (aKey/dKey), saut variable, dash Radagon (raycast wall-clamp + i-frames + visuels), hooks Attack/Dash (placeholders log)
- `Assets/Scripts/EnergyOrbVisual.cs` — pulse + dérive sinusoïdale des 4 couches concentriques
- `Assets/Scripts/FollowCamera2D.cs` — caméra custom (damping X 0.20, Y 0.35 / dead zone 2×1.5 / lookahead 3)
- `Assets/Scripts/FadeAndDestroy.cs` — helper afterimage/flash (fade + optional shrink + destroy)
- `Assets/Editor/SetupTutoStart.cs` — génère TutoStart.unity en code (menu `ZELL → Setup TutoStart Scene` ou `-executeMethod`)
- `Assets/Editor/SceneCapture.cs` — capture batchmode d'une scène vers PNG (pour skill `montrer-capture`)

### Player (couleurs / propriétés)

- 4 couches concentriques warm :
  - OrbOuter (3.0 scale, alpha 0.14, orange dim)
  - OrbMid (2.0, alpha 0.30, ambre)
  - OrbInner (1.1, alpha 0.75, gold)
  - OrbCore (0.45, alpha 1.0, blanc chaud)
- Light 2D ponctuelle warm gold (intensity 2.5, radius 5)
- TrailRenderer subtil : 0.3s, width 0.55→0.05, gradient warm ambré → transparent
- PhysicsMaterial2D friction = 0 (fix mur sticky)

### Contrôles (AZERTY)

| Action | Touche |
|---|---|
| Gauche | **Q** (= aKey en physique US) ou flèche gauche |
| Droite | **D** (dKey) ou flèche droite |
| Sauter | **Espace** (variable : tap court, hold long) ou flèche haut |
| Attaquer | Clic gauche (placeholder log) |
| Dash | Clic droit (Radagon-like, mini-téléportation 4.5 units, cooldown 0.5s) |

### Skills d'équipe partagés (`.claude/skills/`)

1. **`lancer-unity`** — le "F5" Claude. 3 usages : compile check headless, capture via SceneCapture, lancement interactif.
2. **`montrer-capture`** — *règle de workflow* : après chaque SceneCapture, Claude DOIT immédiatement `Read` le `.capture.png` pour qu'il apparaisse inline.
3. **`relance-unity-fin-feature`** — *règle de workflow* : après chaque batch gameplay/visuel + commit + push, Claude DOIT lancer Unity interactif. PAS pour doc/refactor/skills.

### Docs maintenus

- **`CAHIER_DES_CHARGES.md`** (v2, refonte mai 2026) — 27 sections, source de vérité pour spécifications
- **`Structure_et_idées.md`** — lore complet (zones, boss, PNJ, voix)
- **`CLAUDE.md`** — règles pour Claude (et collaborateurs)
- **`HANDOVER.md`** (ce fichier) — état de fin de session

### Backups

- Repo git principal : `C:\Projects\zell\` (jamais OneDrive)
- GitHub : `github.com/Ito-x/Zell` branche `master`
- Branche `legacy_godot` archive l'ancienne version Godot
- `.kra` (Krita sources) dans `OneDrive\Backup_Zell_Sources\`

---

## Roadmap immédiate (à faire au prochain démarrage)

### 1. **Test Play Mode** (Paul, demain matin)

Vérifier en jeu :
- SpawnPlatform géante : feel "vaste couloir" ?
- Q/D + Espace fluide ? Saut variable ressenti (tap vs hold) ?
- Dash clic droit : déclenche bien le téléport + visuels électriques cyan ?
- Tomber dans un trou → chute longue → atterrissage sur sol bas → porte gigantesque visible ?
- Caméra : feel damping/dead zone/lookahead ?

### 2. **Si test OK → enchaîner sur**

Par ordre de valeur ajoutée :

1. **Plateformes descendantes intermédiaires** dans le grand vide vertical (côté droit) pour donner un chemin de descente progressive (et plus tard de remontée avec dash vertical)
2. **Pics mortels** + killzone trigger + respawn au spawn point (système de checkpoint basique)
3. **Plateforme cassable** (préfab `BreakablePlatform`, état persistant "déjà cassée")
4. **Porte interactive** : Area2D trigger + input E + check possession épée → ouvre / déclenche transition
5. **Coffres** : préfab `Chest`, ouverture une fois, drop Synapses

### 3. **Si test PAS OK**

- Saut trop bas / trop haut → ajuster `jumpForce` (actuel 14) ou `gravityScale` (actuel 3)
- Gaps trop durs → réduire écart entre stepping stones
- Caméra trop molle / trop rigide → tuner `dampingX/Y` (0.20 / 0.35) ou `deadZone` (2 / 1.5)
- Porte trop / pas assez grosse → ajuster `(16, 24)` dans `SetupTutoStart.cs`
- Couleurs Zell off → tuner les 4 couches dans `SetupTutoStart.CreatePlayer`

### 4. **Plus tard (sprints suivants)**

- **Sprite Shape** pour sol/plafond organique (quand Paul aura dessiné `edge_top.png` + `fill_chair.png` en Krita)
- **Backgrounds parallaxe** (3 plans : ciel, lointain, proche)
- **HUD** : flammèches HP en cercle + jauge Coup de Jus + chiffres clignotants Impulsion (style HxH Nen)
- **Premier ennemi** : Grosse Boule (mob lent, voit, sourd, contré par Refroidissement)
- **Vrai épée + slash visuel** pour brancher le clic gauche
- **Boss Chevalier Cristallin**
- **Cinemachine** si le FollowCamera2D custom ne suffit plus (transitions/boss)

---

## Décisions tranchées cette session (à respecter)

| Décision | Pourquoi |
|---|---|
| **Unity 6.3 LTS + URP 2D** (pas Cinemachine pour l'instant) | Léger, on a le contrôle |
| **Couleurs warm (jamais bleu) sur Zell** | Énergie / conscience / chaleur — c'est l'identité du perso |
| **AZERTY : `aKey` (pas `qKey`)** | Unity utilise positions physiques US → Q AZERTY est en pos US-A |
| **New Input System (`Keyboard.current`)** | Projet Universal 2D template configure New uniquement |
| **Porte = sprite seul, pas de collider** | Fait partie du background, interaction sans hitbox |
| **Dash = mini-téléportation (pas glissé)** | Style Radagon (cf. CDC section 4) |
| **Saut variable** | Standard metroidvania, demandé explicitement |
| **PhysicsMaterial2D friction = 0 partout** | Fix mur-sticky |
| **Camera = `FollowCamera2D` custom** | Cinemachine plus tard si besoin |
| **Scène en code via `SetupTutoStart.cs`** | Reproducible, versionnable, pas de .unity à la main |
| **Skills auto-déclenchés** : `montrer-capture` après screen, `relance-unity-fin-feature` après batch | Workflow fluide entre Claude et Paul |

---

## Pièges connus à éviter

- **NE JAMAIS** mettre le projet dans OneDrive (conflits casse Windows, file locks).
- **NE PAS** utiliser `KeyCode.Q` sur AZERTY pour la touche labellisée "Q" — c'est `KeyCode.A` (positions US).
- **NE PAS** utiliser `UnityEngine.Input` legacy → utiliser `Keyboard.current` / `Mouse.current`.
- **NE PAS** parent la caméra au Player (rigide). Utiliser `FollowCamera2D` standalone.
- **Toujours** fermer les instances Unity batchmode résiduelles avant nouveau Setup (sinon file lock).
- **Toujours** appliquer le skill `montrer-capture` après SceneCapture (Read inline le PNG).
- **Toujours** appliquer le skill `relance-unity-fin-feature` après batch gameplay/visuel + commit.

---

## Dernier commit avant fin de session

```
971c0ac feat(scene): SpawnPlatform x4 chaque cote (24->96 wide), map decalee proportionnellement
```

Working tree clean, master à jour avec origin.

---

*Bonne reprise demain ! Le projet est dans un bon état stable et testable.*
