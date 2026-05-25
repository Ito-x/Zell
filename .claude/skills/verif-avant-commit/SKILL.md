---
name: verif-avant-commit
description: Vérifier que le projet Godot ZELL importe et que les scripts/shaders compilent, en mode headless, avant de commiter/pusher. À utiliser après avoir modifié un .tscn, un .gd ou un .gdshader, pour attraper les erreurs que Claude ne voit pas (pas de F5).
---

# verif-avant-commit

Filet de sécurité : comme Claude ne voit pas le F5, ce skill lance Godot en
**headless** pour faire remonter les erreurs de chargement/compilation avant un
commit.

## 1. Localiser Godot

Comme dans le skill `lancer-godot` (PATH → chemin connu → recherche → demander).

## 2. Lancer la vérification headless

Depuis la racine du projet :

```powershell
& "<godot.exe>" --headless --path "<racine_projet>" --import
```

`--import` (ré)importe les ressources et charge le projet, puis quitte. Les
erreurs de parsing de scripts/shaders et les ressources cassées apparaissent dans
la sortie.

## 3. Analyser la sortie

Chercher les lignes contenant : `ERROR`, `SCRIPT ERROR`, `Parser Error`,
`Failed`, `Cannot`, `shader`. 

- **Aucune erreur** → OK pour commiter/pusher.
- **Erreurs** → ne PAS commiter. Corriger d'abord, ré-exécuter ce skill.

```powershell
$out = & "<godot.exe>" --headless --path "<racine>" --import 2>&1
$out | Select-String -Pattern "ERROR|SCRIPT ERROR|Parser|Failed|Cannot|shader" -CaseSensitive:$false
```

## Limites (honnêteté)

- Le headless n'a pas de GPU : certaines erreurs **purement visuelles** ou de
  compilation GPU de shader peuvent ne pas apparaître. Ce skill attrape surtout
  les erreurs de **parsing** (syntaxe GDScript, syntaxe shader, refs cassées).
- Pour la validation visuelle réelle, enchaîner avec `lancer-godot` (capture).
- Ne jamais présenter « headless OK » comme « le rendu est bon » — c'est juste
  « ça charge sans planter ».
