---
name: kra-vers-png
description: Exporter un dessin Krita (.kra) en PNG et le préparer pour Godot. À utiliser quand l'utilisateur fournit un fichier .kra (ou mentionne un dessin Krita) à intégrer comme texture/sprite, car Godot ne sait pas lire le .kra.
---

# kra-vers-png

Godot **ne lit pas le `.kra`**. Ce skill convertit un dessin Krita en PNG via la
ligne de commande de Krita, puis le dépose dans le projet.

## 1. Localiser Krita

1. Chemin connu (machine de Paul) : `C:\Program Files\Krita (x64)\bin\krita.exe`
2. Sinon chercher :
   ```powershell
   Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "krita.exe" -ErrorAction SilentlyContinue -Depth 3 | Select-Object -First 3 FullName
   ```
3. Si rien : demander à l'utilisateur où Krita est installé.

## 2. Exporter le .kra en PNG

```powershell
& "<krita.exe>" "<chemin\dessin.kra>" --export --export-filename "<chemin\sortie.png>"
```

- Exporter de préférence directement dans `assets/textures/` du projet
  (sous-dossier pertinent, ex. `assets/textures/chair/`).
- L'export ouvre brièvement Krita puis se ferme — c'est normal. Attendre la fin
  avant de continuer.
- Vérifier que le PNG est bien créé (`Test-Path`).

## 3. Intégrer dans Godot

- Une fois le PNG dans `assets/`, Godot le réimporte automatiquement au prochain
  démarrage de l'éditeur (génère un `.import`, qui est gitignoré — normal).
- Câbler la texture là où c'est demandé (Sprite2D, `Polygon2D.texture`, ou
  `shader_parameter/source_tex` d'un `ShaderMaterial`).
- Pour les textures de tunnel chair (sol/plafond), penser à un `tex_repeat` /
  UV cohérent comme dans `chair_putrefaction_uv.gdshader`.

## Note

Rappeler à l'utilisateur qu'il devra **réexporter** après chaque modification du
`.kra` (ou relancer ce skill).
