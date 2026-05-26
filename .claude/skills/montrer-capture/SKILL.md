---
name: montrer-capture
description: Quand Claude vient de prendre une capture d'écran de vérification d'une scène Unity (typiquement via SceneCapture.CaptureGameView qui produit .capture.png), il DOIT immédiatement lire le PNG avec Read pour qu'il apparaisse inline dans la conversation. Comme ça Paul a un retour visuel statique de ce que Claude voit, sans devoir lancer Unity lui-même. À déclencher systématiquement après tout appel à SceneCapture ou équivalent qui produit un PNG de vérification.
---

# montrer-capture

**Règle de workflow** : après chaque capture d'écran de vérification, toujours
afficher le résultat **inline dans la conversation** via l'outil `Read` sur le
PNG.

## Déclencheur

Après tout appel batchmode qui produit un PNG de vérification :
- `Unity.exe ... -executeMethod SceneCapture.CaptureGameView ...` → produit `.capture.png`
- Tout autre script Editor qui sauve un PNG pour Claude

## Action

Une fois la commande de capture terminée, **avant toute autre étape** (commit,
analyse, conclusion) :

```
Read C:\Projects\zell\.capture.png
```

L'image apparaît inline dans la conversation Claude Code. Paul peut comparer
le rendu attendu vs la réalité sans rien lancer.

## Pourquoi

- Claude n'a pas d'autre moyen de "voir" la scène — c'est son F5 statique.
- Paul peut suivre visuellement ce que Claude voit pendant qu'il code.
- Évite à Paul d'ouvrir Unity juste pour vérifier un rendu.
- Permet à Claude de **corriger immédiatement** s'il voit que le rendu est cassé.

## Workflow typique

1. Claude code une modif visuelle
2. Claude run compile check
3. Claude run la capture (`SceneCapture.CaptureGameView`)
4. **Claude `Read` immédiatement le `.capture.png` → image inline** ← ce skill
5. Claude analyse le rendu, corrige si besoin, ou continue

## Limites

- La capture est faite en Edit Mode, pas en Play Mode. Donc :
  - Le mouvement n'est pas visible (player statique)
  - Le TrailRenderer n'apparaît pas (besoin de mouvement)
  - Les animations Update() ne tournent pas
- Pour les vérifs de gameplay réel (saut, dash, traînée en mouvement),
  il faut le Play Mode → voir le skill `relance-unity-fin-feature`.
