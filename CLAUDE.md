# ZELL — Guide pour Claude (et les contributeurs)

> Ce fichier est chargé automatiquement au début de chaque session Claude Code
> dans ce dépôt. Il contient les règles de travail partagées par toute l'équipe.

## Le projet

**ZELL** — Metroidvania **2D onirique** sur **Unity 2D URP**. Le protagoniste
Veilae (surnom *Zell*) explore son propre esprit pendant un coma. Style : dessin
animé flou/féerique, particules, glow/bloom 2D. Zone tuto = **Les Yeux**.

Design détaillé dans `CAHIER_DES_CHARGES.md` (37 Objectifs) et
`Structure_et_idées.md` (lore + progression).

## Langue & communication

- **Réponds en français.**
- Le porteur du projet (Paul) est **débutant complet** en Unity et ne code pas
  encore en C#. Explique chaque concept simplement, sans jargon inutile.
- **Valide avant de créer un nouveau fichier** : explique ce que tu vas faire
  et pourquoi avant de le générer.

## Engine & contexte technique

- **Unity 2D URP** (Universal Render Pipeline 2D). **Pas de 3D** sauf demande
  explicite. Si un brief mentionne `MeshRenderer`, `Camera` 3D perspective,
  `Volumetric Fog`, c'est une erreur : trouver l'équivalent 2D
  (`SpriteRenderer`, `Camera` orthographique, post-process `Volume` 2D).
- **Pipeline 2D** : `Light2D`, `Sprite Shape`, `Tilemap`, `Volume` post-process
  (Bloom 2D), parallaxe via scripts ou Cinemachine.
- **C#** pour les scripts, **ShaderGraph** (préférable) ou HLSL `.shader` pour
  les shaders custom.
- L'ancien projet **Godot est archivé sur la branche `legacy_godot`** (rosaces,
  brume noire, shaders gdshader, scripts gd). Les **concepts** sont
  réutilisables, les fichiers non.

## Structure du projet Unity (une fois le projet créé)

```
/Assets/
  /Art/        sprites, textures (PNG exportés des .kra)
  /Audio/
  /Prefabs/
  /Scenes/     .unity
  /Scripts/    C#
  /Shaders/    ShaderGraph / .shader / .hlsl
  /Settings/   Renderer 2D, URP asset, Volume profiles
/Packages/
/ProjectSettings/
```

`Library/`, `Temp/`, `Logs/`, `obj/`, `*.csproj`, `*.sln` → **gitignorés**.

## Règles & pièges à se rappeler

- Création projet : Unity Hub → **2D Universal Project** (pas 2D Built-in,
  pas 3D).
- Import PNG : Texture Type = **Sprite (2D and UI)**, ajuster
  *Pixels Per Unit* selon l'asset (jouer dessus pour la taille en scène).
- Le **glow/bloom** se règle dans un `Volume` (Global Volume) + `Bloom`,
  avec le `Renderer 2D` correctement assigné dans l'URP Asset.
- `Light2D` (Global / Spot / Freeform / Sprite) au lieu de lumières 3D.
- (Cette section s'enrichira au fil des galères rencontrées.)

## Penser « champ visible »

Paul teste en **Play Mode** dans Unity. Du décor « présent dans la scène »
mais hors du cadre caméra au spawn = « ça ne s'affiche pas » pour lui.
- Placer le décor dans le rectangle visible autour du Player au spawn.
- Préférer des éléments visibles (suffisamment grands à l'échelle PPU choisie).

## Périmètre (scope) — ne pas extrapoler

Le design se construit progressivement par zones/phases. Quand une consigne
porte sur une partie précise (tuto / Phase 1 / jeu complet), **rester dans ce
périmètre**. Ne pas supprimer des éléments établis ailleurs sur la base d'une
consigne locale. En cas de doute : **demander avant d'éditer**, préférer
ajouter/scoper plutôt que supprimer.

## Git

- **Commit + push automatiquement** après chaque modification de doc ou de
  contenu du projet, **sans demander confirmation**.
- Messages de commit en français : `feat(scene): …` / `fix(player): …` /
  `docs: …` / `chore: …`.
- Branches :
  - `master` — projet Unity actif
  - `legacy_godot` — archive intégrale de la V1 sur Godot 4.6 (référence
    visuelle/technique uniquement, on n'y commit plus)

## Skills d'équipe (`.claude/skills/`)

Le dossier est vide pour l'instant — on reconstruira au fur et à mesure des
besoins Unity. Skills probables à venir :

- `lancer-unity` — Play Mode + capture pour vérification visuelle (équivalent
  du F5 de Claude)
- `verif-avant-commit` — build Unity headless / `Editor.exe -batchmode
  -nographics -quit` pour attraper les erreurs de compile C# et de ressources
- `kra-vers-png` — exporter Krita vers PNG et le déposer dans `Assets/Art/`
- `shader-unity` — créer un ShaderGraph propre ou un `.shader` HLSL

Au moment où on crée un skill : `.claude/skills/<nom>/SKILL.md`, puis commit
+ push. Pour récupérer ceux des autres : `git pull`.
