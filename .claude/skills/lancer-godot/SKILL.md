---
name: lancer-godot
description: Lancer le jeu ZELL ou une scène précise dans Godot 4, et/ou en faire une capture d'écran pour vérifier visuellement le rendu (le « F5 » de Claude). À utiliser quand on demande de lancer/tester le jeu, voir le rendu d'une scène, ou confirmer qu'un changement visuel marche à l'écran.
---

# lancer-godot

Permet de **voir réellement** ce que donne le jeu, au lieu de coder à l'aveugle.
Deux usages : lancer la scène dans une fenêtre, ou prendre une capture d'écran
que Claude peut ensuite lire.

## 1. Localiser le binaire Godot (faire ça en premier)

Essayer dans cet ordre, prendre le premier qui existe :

1. Sur le PATH : `godot`, puis `godot4`.
2. Chemin connu (machine de Paul) :
   `C:\Users\paulc\OneDrive\Desktop\Godot_v4.6.3-stable_win64.exe`
3. Sinon, chercher avec PowerShell :
   ```powershell
   Get-ChildItem "$env:USERPROFILE\Desktop","$env:USERPROFILE\Downloads","C:\Program Files" -Recurse -Filter "*odot*win64*.exe" -ErrorAction SilentlyContinue -Depth 3 | Select-Object -First 5 FullName
   ```
4. Si rien : **demander à l'utilisateur** le chemin du `.exe` Godot (ou comment il
   le lance), et le proposer pour ajout au PATH.

Le projet est la racine du dépôt (là où se trouve `project.godot`).

## 2. Lancer une scène / le jeu

Lancer en arrière-plan pour ne pas bloquer la session :

```powershell
& "<godot.exe>" --path "<racine_projet>" "res://scenes/world/LesYeux.tscn"
```

Sans argument de scène, la scène principale (`LesYeux.tscn`) se lance. Prévenir
l'utilisateur que la fenêtre s'ouvre, et lui demander son retour visuel.

## 3. Capture d'écran (pour que Claude voie le rendu)

Un outil est fourni dans le dépôt : `tools/capture.tscn` + `tools/capture.gd`.
Il instancie la scène cible, laisse rendre ~30 frames, sauve un PNG et quitte.

```powershell
& "<godot.exe>" --path "<racine_projet>" "res://tools/capture.tscn" -- "res://scenes/world/LesYeux.tscn"
```

- Le PNG est écrit dans `<racine_projet>\.capture.png` (chemin affiché après
  `CAPTURE_OK` dans la sortie).
- Ensuite, **lire** ce `.capture.png` avec l'outil Read pour analyser le rendu
  (cadrage F5, couleurs, position du décor, etc.).
- Cette capture nécessite un affichage/GPU (pas `--headless`). Si elle échoue
  (machine sans écran), se rabattre sur le lancement fenêtré (section 2) et
  demander à l'utilisateur une capture manuelle.

## Notes

- `.capture.png` est temporaire — ne pas le commiter (l'ajouter à `.gitignore`
  s'il gêne).
- Toujours relier le résultat à la règle « champ visible F5 » du `CLAUDE.md` :
  vérifier que le décor est bien dans le cadre au spawn.
