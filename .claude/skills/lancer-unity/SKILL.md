---
name: lancer-unity
description: Lancer Unity sur le projet ZELL en mode headless (vérification de compilation C# rapide) ou interactif (éditeur ouvert), ou prendre une capture d'écran d'une scène via un script Editor. C'est le « F5 » de Claude pour Unity 2D URP. À utiliser quand on demande de tester le projet, vérifier que les scripts compilent, voir le rendu d'une scène, ou confirmer qu'un changement visuel marche.
---

# lancer-unity

Permet à Claude de **voir réellement** ce que donne le projet Unity, ou de
vérifier que les scripts C# compilent, sans devoir attendre que Paul lance
l'éditeur manuellement.

Trois usages :
1. **Vérification rapide de compilation** (headless, sans GPU)
2. **Capture d'écran d'une scène** (requires GPU + script Editor)
3. **Lancement interactif** de Unity (Paul interagit, pas de retour à Claude)

## 1. Localiser le binaire Unity

Chemin connu sur la machine Paul :
`C:\Program Files\Unity\Hub\Editor\6000.3.16f1\Editor\Unity.exe`

Fallback (si une autre version est installée) :
```powershell
Get-ChildItem "C:\Program Files\Unity\Hub\Editor" -Directory |
  Sort-Object Name -Descending | Select-Object -First 1 |
  ForEach-Object { Join-Path $_.FullName "Editor\Unity.exe" }
```

Le projet est à `C:\Projects\zell\` (jamais OneDrive — voir `CLAUDE.md`).

## 2. Vérification de compilation headless

Le mode le plus rapide pour attraper les erreurs C# et les ressources cassées :

```powershell
$unity = "C:\Program Files\Unity\Hub\Editor\6000.3.16f1\Editor\Unity.exe"
$proj  = "C:\Projects\zell"
$log   = "$proj\.unity_compile.log"
& $unity -batchmode -quit -nographics -projectPath $proj -logFile $log
$code = $LASTEXITCODE
"ExitCode: $code"
if (Test-Path $log) {
    Select-String -Path $log -Pattern "error CS|Exception|Failed to compile|Cannot find" -CaseSensitive:$false |
      Select-Object -First 50
}
```

Flags :
- `-batchmode` : pas d'UI
- `-quit` : Unity sort après l'opération
- `-nographics` : pas de GPU (compile pur, très rapide ~10-30s)
- `-projectPath` : où est le projet
- `-logFile` : chemin du log Unity (sinon va dans `%LOCALAPPDATA%\Unity\Editor\Editor.log`)

**Analyse :**
- `ExitCode == 0` et aucun `error CS...` → ✅ OK, scripts compilent
- `ExitCode != 0` ou des `error CS1234:` dans le log → ❌ ne pas commiter, corriger

## 3. Capture d'écran d'une scène

Unity n'a pas de mode CLI natif pour « charger scène + screenshot + quit ».
Il faut un script Editor dans `Assets/Editor/SceneCapture.cs`. Le créer si
absent (voir le template à la fin de ce skill).

Avec le script en place :

```powershell
$unity = "C:\Program Files\Unity\Hub\Editor\6000.3.16f1\Editor\Unity.exe"
$proj  = "C:\Projects\zell"
$scene = "Assets/Scenes/SampleScene.unity"   # adapter
$out   = "$proj\.capture.png"
$log   = "$proj\.unity_capture.log"
& $unity -batchmode -quit -projectPath $proj `
  -executeMethod SceneCapture.CaptureGameView `
  -scenePath $scene -outputPath $out -logFile $log
"ExitCode: $LASTEXITCODE"
```

Important : **pas de `-nographics`** ici (faut un GPU pour rendre). Sur une
machine sans écran/GPU ça plantera ; dans ce cas, se rabattre sur le mode
interactif (section 4) et demander une capture manuelle à Paul.

Ensuite Claude **Read** `.capture.png` pour analyser le rendu.

`.capture.png` est dans `.gitignore`, pas à commiter.

## 4. Lancement interactif (Paul joue avec)

Pour ouvrir l'éditeur normalement, Paul interagit, Claude n'a pas de retour direct :

```powershell
$unity = "C:\Program Files\Unity\Hub\Editor\6000.3.16f1\Editor\Unity.exe"
Start-Process $unity -ArgumentList "-projectPath", "C:\Projects\zell"
```

À utiliser quand Paul demande explicitement « ouvre Unity ».

## Limites (honnêteté)

- Le mode batch sans GPU n'attrape PAS les erreurs purement visuelles ou
  certaines compilations shader. Pour ça : capture ou mode interactif.
- Le script Editor pour la capture est expérimental — selon la complexité
  de la scène (URP, post-process, lights), le rendu en batchmode peut
  différer légèrement de Play Mode. Ne jamais conclure « le rendu est bon »
  juste sur une capture batchmode — préférer le F5 manuel pour validation finale.
- Si Unity est déjà ouvert sur le projet quand on lance la CLI : conflit
  (l'instance déjà ouverte verrouille `Library/`). Fermer l'éditeur manuel
  avant les commandes batch.

## Template du script Editor pour la capture

À déposer dans `Assets/Editor/SceneCapture.cs` lors du premier usage. (Dossier
`Editor` à créer si absent — Unity reconnaît tout C# dans un dossier `Editor`
comme code éditeur seulement, exclu du build.)

```csharp
// Assets/Editor/SceneCapture.cs
using System;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class SceneCapture
{
    // Lance via :
    //   Unity.exe -batchmode -quit -projectPath <proj>
    //     -executeMethod SceneCapture.CaptureGameView
    //     -scenePath "Assets/Scenes/X.unity"
    //     -outputPath "C:\path\capture.png"
    //     [-width 1920 -height 1080 -waitFrames 60]
    public static void CaptureGameView()
    {
        string scenePath  = "Assets/Scenes/SampleScene.unity";
        string outputPath = Path.Combine(Directory.GetCurrentDirectory(), "capture.png");
        int width  = 1920;
        int height = 1080;
        int waitFrames = 60;

        var args = Environment.GetCommandLineArgs();
        for (int i = 0; i < args.Length - 1; i++)
        {
            switch (args[i])
            {
                case "-scenePath":  scenePath  = args[i + 1]; break;
                case "-outputPath": outputPath = args[i + 1]; break;
                case "-width":  int.TryParse(args[i + 1], out width);  break;
                case "-height": int.TryParse(args[i + 1], out height); break;
                case "-waitFrames": int.TryParse(args[i + 1], out waitFrames); break;
            }
        }

        try
        {
            EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
        }
        catch (Exception e)
        {
            Debug.LogError("[SceneCapture] OpenScene failed: " + e.Message);
            EditorApplication.Exit(2);
            return;
        }

        Camera cam = Camera.main ?? UnityEngine.Object.FindObjectOfType<Camera>();
        if (cam == null)
        {
            Debug.LogError("[SceneCapture] No camera in scene");
            EditorApplication.Exit(3);
            return;
        }

        var rt = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32);
        rt.antiAliasing = 1;
        cam.targetTexture = rt;

        for (int i = 0; i < waitFrames; i++)
            cam.Render();

        var tex = new Texture2D(width, height, TextureFormat.RGB24, false);
        RenderTexture.active = rt;
        tex.ReadPixels(new Rect(0, 0, width, height), 0, 0);
        tex.Apply();

        cam.targetTexture = null;
        RenderTexture.active = null;

        byte[] png = tex.EncodeToPNG();
        Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
        File.WriteAllBytes(outputPath, png);

        Debug.Log("[SceneCapture] OK -> " + outputPath);
        EditorApplication.Exit(0);
    }
}
```

(Quand on crée ce fichier la première fois, faire un compile check + tester
sur SampleScene avant de l'utiliser comme outil de vérif.)
