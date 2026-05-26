---
name: relance-unity-fin-feature
description: Quand Claude vient de terminer un batch de modifications qui change ce que Paul verra en Play Mode (code de gameplay, setup de scène, visuels, mécaniques, shaders, traînée, couleurs, etc.) et qu'il a commit + push, il DOIT automatiquement lancer Unity en mode interactif pour que Paul puisse immédiatement tester sans manipuler Unity Hub. À déclencher en fin de chaque batch gameplay/visuel cohérent, JAMAIS pour les changements purement doc/refactor/skills.
---

# relance-unity-fin-feature

**Règle de workflow** : après une session de modifications qui change ce que
Paul verra en Play Mode, **lancer Unity en mode interactif** automatiquement
à la toute fin du turn (après commit + push), pour que Paul puisse tester
sans rien faire.

## Déclencheur — ACTIVER ce skill quand :

- Modification de `PlayerController` ou autre script de gameplay
- Régénération d'une scène (`SetupTutoStart.Run` ou équivalent)
- Changement visuel sur Zell ou le décor (couleurs, sprites, lights, particules, shaders)
- Ajout / modif de mécanique (saut variable, dash, attack, etc.)
- Tout ce qui change le rendu OU le comportement en Play Mode

## Déclencheur — NE PAS activer ce skill quand :

- Changements de doc seuls (CDC, Structure_et_idées, CLAUDE.md)
- Refactoring sans effet en jeu
- Création / modification de skills `.claude/skills/`
- Changements de `.gitignore`, configuration projet
- Restauration de fichiers, déménagement
- Toute opération purement git / repo

## Action

À la **toute fin** du turn (après le `git push` réussi) :

```powershell
# Fermer toute instance Unity bloquante (au cas où)
Get-Process | Where-Object { $_.Name -eq "Unity" } |
  Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# Lancer Unity en interactif sur le projet
$unity = "C:\Program Files\Unity\Hub\Editor\6000.3.16f1\Editor\Unity.exe"
Start-Process $unity -ArgumentList "-projectPath","C:\Projects\zell"
```

Puis informer Paul que Unity est en train de s'ouvrir (~10-20s) et qu'il
peut Play dès qu'il est prêt.

## Workflow type complet

1. Paul demande une modification gameplay/visuel
2. Claude code
3. Claude run compile check (skill `lancer-unity` section 2)
4. Claude régénère la scène si besoin (`SetupTutoStart.Run`)
5. Claude run la capture (skill `lancer-unity` section 3)
6. Claude **`Read` le `.capture.png`** (skill `montrer-capture`)
7. Claude analyse, corrige si besoin
8. Claude commit + push
9. **Claude relance Unity interactif** ← ce skill
10. Paul ouvre Unity (déjà chargé), Play, teste

## Pourquoi

- Économise à Paul l'aller-retour Hub → Add project → Open
- Réduit le frottement entre la fin du code et le début du test
- Synchronise le flow : quand Claude finit, Paul peut immédiatement valider
- Encourage les itérations rapides (test → feedback → fix)

## Notes

- Si Unity est déjà ouvert sur le projet, **on tue d'abord** pour éviter
  les conflits de file lock sur Library/ (Unity gère mal les double-instances).
- Le `Start-Process` est **non-bloquant** — Claude termine son turn pendant
  qu'Unity charge en background.
- Cette règle est **partagée par tous les collaborateurs** via git
  (skill versionnée dans `.claude/skills/`).
