# ZELL — Guide pour Claude (et les contributeurs)

> Ce fichier est chargé automatiquement au début de chaque session Claude Code
> dans ce dépôt. Il contient les règles de travail partagées par toute l'équipe.
> **Les skills d'équipe sont dans `.claude/skills/`** (voir la section dédiée).

## Le projet

**ZELL** — Metroidvania **2D onirique** sur **Godot 4.6**. Le protagoniste Veilae
(surnom *Zell*) explore son propre esprit pendant un coma. Style : dessin animé
flou/féerique, particules, glow/bloom. Zone tuto = **Les Yeux**
(`scenes/world/LesYeux.tscn`, c'est la scène principale).

Design détaillé dans `CAHIER_DES_CHARGES.md` (37 Objectifs) et
`Structure_et_idées.md` (lore + progression).

## Langue & communication

- **Réponds en français.**
- Le porteur du projet (Paul) est **débutant complet** en Godot et ne code pas.
  Explique chaque concept simplement, sans jargon inutile.
- **Valide avant de créer un nouveau fichier** : explique ce que tu vas faire et
  pourquoi avant de le générer.

## Architecture technique — règles dures

- **Le jeu est 2D + parallaxe. JAMAIS 3D.** La scène est un `Node2D`, tout le
  décor est en `Polygon2D`, tous les shaders sont `shader_type canvas_item`,
  rendu en `canvas_items`. Si un brief demande du `spatial`/3D (caméra 3D, point
  de fuite, `WorldEnvironment` fog par distance…), c'est une **erreur** : le
  traduire en équivalent 2D (perspective faussée par polygones trapèze + UV,
  « distance caméra » = recul vertical vers le centre, profondeur via parallaxe).
- Structure des dossiers à respecter :
  ```
  scenes/ (player, enemies, world, ui, bosses, zones)
  scripts/ (autoloads, components, resources)
  assets/  (sprites, audio, fonts, shaders, textures)
  ```

## Pièges Godot 4.6 déjà rencontrés (à éviter d'office)

- `TEXTURE_PIXEL_SIZE` **n'existe plus** dans les shaders → ne pas l'utiliser.
- Éviter les constructeurs `vec4(vec4, float)` (crash de compilation). Caster
  explicitement avec `.rgb` quand on assemble des couleurs.
- **Fond coloré 2D** : `WorldEnvironment.background_color` ne peint PAS le fond.
  Utiliser `rendering/environment/defaults/default_clear_color` dans
  `project.godot`, ou un grand `Polygon2D`/`ColorRect` derrière la scène.
  Le `WorldEnvironment` ne sert qu'au glow/tonemap/adjustment en 2D.

## Penser « champ visible F5 »

Paul teste systématiquement avec **F5**. Du décor « présent dans la scène » mais
hors du cadre de la caméra au spawn = « ça ne s'affiche pas » pour lui.
- Placer le décor dans le rectangle visible autour du Player au spawn (viewport
  1920×1080).
- Préférer des éléments visibles (40-80px+) à de petits points perdus.
- Utiliser le skill `lancer-godot` pour vérifier visuellement avant de conclure.

## Périmètre (scope) — ne pas extrapoler

Le design se construit progressivement par zones/phases. Quand une consigne porte
sur une partie précise (tuto / Phase 1 / jeu complet), **rester dans ce
périmètre**. Ne pas supprimer des éléments établis ailleurs sur la base d'une
consigne locale. En cas de doute : **demander avant d'éditer**, préférer
ajouter/scoper plutôt que supprimer.

## Git

- **Commit + push automatiquement** après chaque modification de doc ou de
  contenu du projet, **sans demander confirmation**.
- Messages de commit en français, style `feat(zone): …` / `fix(...)` / `docs:`.

## Skills d'équipe (`.claude/skills/`)

Ces skills sont partagés via git. Claude les déclenche selon le contexte ; tu peux
aussi les invoquer avec `/<nom>`.

| Skill | À quoi ça sert |
|---|---|
| `lancer-godot` | Lancer la scène (ou tout le jeu) et faire une capture d'écran pour vérifier visuellement (le « F5 » de Claude). |
| `kra-vers-png` | Exporter un dessin Krita `.kra` en `.png` et le déposer dans `assets/textures/` (Godot ne lit pas le `.kra`). |
| `shader-godot` | Créer un shader 2D `canvas_item` propre, en évitant les pièges Godot 4.6, + câblage du `ShaderMaterial`. |
| `verif-avant-commit` | Vérifier que le projet importe et que scripts/shaders compilent (Godot headless) avant de pusher. |

## Comment partager de nouvelles règles / skills (synchro d'équipe)

Tout passe par git — c'est ça la « synchro automatique » :

- **Nouvelle règle** → l'ajouter dans **ce `CLAUDE.md`**, puis commit + push.
- **Nouveau skill** → créer `.claude/skills/<nom>/SKILL.md`, puis commit + push.
- **Pour récupérer ce que les autres ont ajouté** → `git pull`. Les nouvelles
  règles et skills sont alors actifs dès la session Claude suivante.

> Note : `.claude/skills/` est volontairement dé-ignoré dans `.gitignore`. Le reste
> de `.claude/` (réglages, sessions) reste local et n'est pas partagé.
