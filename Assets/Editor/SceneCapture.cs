using System;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

/// <summary>
/// Capture statique d'une scène Unity vers un PNG, via la caméra principale.
/// Tourne en batchmode pour donner à Claude un "F5 visuel" de la scène.
///
/// Lance via :
///   Unity.exe -batchmode -quit -projectPath <proj>
///     -executeMethod SceneCapture.CaptureGameView
///     -scenePath "Assets/Scenes/X.unity"
///     -outputPath "C:\path\capture.png"
///     [-width 1920 -height 1080 -waitFrames 60]
///
/// NB : la capture est faite en Edit Mode (pas en Play Mode). Les scripts
/// Update() ne tournent donc pas. Pour le visuel pur (couleurs, sprites,
/// lumières, placements), c'est suffisant.
/// </summary>
public static class SceneCapture
{
    public static void CaptureGameView()
    {
        string scenePath  = "Assets/Scenes/TutoStart.unity";
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

        Camera cam = Camera.main ?? UnityEngine.Object.FindFirstObjectByType<Camera>();
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
        var dir = Path.GetDirectoryName(outputPath);
        if (!string.IsNullOrEmpty(dir)) Directory.CreateDirectory(dir);
        File.WriteAllBytes(outputPath, png);

        Debug.Log("[SceneCapture] OK -> " + outputPath);
        EditorApplication.Exit(0);
    }
}
