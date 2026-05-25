---
name: shader-godot
description: Créer ou modifier un shader 2D Godot 4 (canvas_item) propre pour ZELL, en évitant les pièges connus de Godot 4.6, et câbler le ShaderMaterial. À utiliser quand on veut un nouvel effet visuel de shader (chair, fond, herbe, halo, brouillard…) ou retoucher un shader existant.
---

# shader-godot

ZELL utilise des shaders **2D `canvas_item`** uniquement (jamais `spatial`).
Ce skill scaffolde un shader propre et le câble, sans retomber dans les pièges
déjà rencontrés.

## Règles dures (Godot 4.6)

- Toujours `shader_type canvas_item;` (jamais `spatial`).
- **`TEXTURE_PIXEL_SIZE` n'existe plus** → ne pas l'utiliser. Pour échantillonner
  des voisins, passer une taille en uniform (cf. `auto_normal_kernel` dans
  `chair_putrefaction_uv.gdshader`).
- Éviter `vec4(vec4, float)` (crash de compilation). Assembler avec `.rgb` :
  `COLOR = vec4(col.rgb, alpha);`.
- Les couleurs réglables : `uniform vec4 ma_couleur : source_color = ...;`.
- L'animation se fait avec `TIME` (respiration : `sin(TIME * speed)`).
- Si le shader sample une texture : `uniform sampler2D source_tex : filter_linear_mipmap, repeat_enable;`
  et échantillonner via `texture(source_tex, UV * tex_repeat)`.

## Conventions ZELL réutilisables

S'inspirer des shaders existants dans `assets/shaders/` :
- Respiration (« breathing ») : `breath_speed` + `breath_amount`, module l'albédo
  avec une sinusoïde lissée (voir `chair_putrefaction_uv.gdshader`).
- Fondu de profondeur : `distance_fade` + `fade_curve`, assombrit le lointain
  (UV.y → 0) tout en gardant le premier plan net.
- Déformation interactive : `uniform vec2 player_pos` (en coords locales, fourni
  par un script via `to_local`) + poussée quadratique en hauteur, base fixe
  (voir `grass_silhouette.gdshader` + `scenes/world/InteractiveGrass.gd`).

## Procédure

1. Créer `assets/shaders/<nom>.gdshader` avec `shader_type canvas_item;`, les
   `uniform … : hint_range/source_color` pertinents, un `fragment()` clair et
   commenté en français.
2. Dans la scène (`.tscn`), créer un `[sub_resource type="ShaderMaterial" …]`
   pointant le shader, et renseigner chaque `shader_parameter/<nom>`.
3. L'affecter au `material` du `Polygon2D`/`Sprite2D` voulu.
4. **Vérifier** : lancer `verif-avant-commit`, puis `lancer-godot` pour voir le
   rendu. Ajuster les uniforms depuis l'inspecteur.
5. Commit + push (règle Git du `CLAUDE.md`).

## Penser au placement

Respecter « champ visible F5 » : un shader sublime sur un polygone hors-cadre ne
se voit pas. Vérifier la position/taille du polygone par rapport au spawn.
