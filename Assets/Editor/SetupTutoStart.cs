using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering.Universal;

/// <summary>
/// Génère la scène TutoStart en code : blockout du spawn de la zone Les Yeux.
/// 3 plateformes (LEFT inaccessible / SPAWN center / RIGHT via stepping stones),
/// plafond, sol bas avec porte, murs latéraux, Player boule d'énergie, caméra,
/// Light 2D globale.
///
/// Usage :
///   - Menu Unity : ZELL → Setup TutoStart Scene
///   - Batchmode  : Unity.exe -batchmode -quit -executeMethod SetupTutoStart.Run
/// </summary>
public static class SetupTutoStart
{
    private const string SceneAssetPath = "Assets/Scenes/TutoStart.unity";
    private const string SpriteFolder = "Assets/Art/Sprites";

    [MenuItem("ZELL/Setup TutoStart Scene")]
    public static void Run()
    {
        EnsureFolder("Assets/Scenes");
        EnsureFolder("Assets/Art");
        EnsureFolder(SpriteFolder);

        // Pré-générer les sprites carré + cercle si absents
        var squareSprite = GetOrCreateSquareSprite();
        var circleSprite = GetOrCreateCircleSprite();

        // Nouvelle scène vide
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);

        // === Caméra (placeholder, sera reparentée sur le Player) ===
        var camGO = new GameObject("Main Camera");
        camGO.tag = "MainCamera";
        var cam = camGO.AddComponent<Camera>();
        cam.orthographic = true;
        cam.orthographicSize = 8f;
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = new Color(0.05f, 0.06f, 0.10f);

        // === Light 2D globale (ambiante douce) ===
        var lightGO = new GameObject("Global Light 2D");
        var gLight = lightGO.AddComponent<Light2D>();
        gLight.lightType = Light2D.LightType.Global;
        gLight.intensity = 0.9f;
        gLight.color = new Color(0.95f, 0.95f, 1f);

        // === World container ===
        var world = new GameObject("World");

        // PLAFOND (toute la largeur, haut de la map)
        CreateBlock(world.transform, "Plafond", new Vector2(0, 9), new Vector2(80, 2), new Color(0.18f, 0.18f, 0.22f), squareSprite);

        // SOL HAUT (3 plateformes)
        CreateBlock(world.transform, "SolGauche", new Vector2(-25, -1), new Vector2(14, 2), new Color(0.45f, 0.45f, 0.50f), squareSprite);
        CreateBlock(world.transform, "SolSpawn", new Vector2(0, -1), new Vector2(12, 2), new Color(0.60f, 0.55f, 0.45f), squareSprite);
        CreateBlock(world.transform, "SolDroite", new Vector2(25, -1), new Vector2(14, 2), new Color(0.45f, 0.45f, 0.50f), squareSprite);

        // STEPPING STONES (uniquement à droite — gauche infranchissable)
        CreateBlock(world.transform, "MiniPlat1", new Vector2(9.5f, -0.5f), new Vector2(2.2f, 1f), new Color(0.55f, 0.55f, 0.60f), squareSprite);
        CreateBlock(world.transform, "MiniPlat2", new Vector2(13f, -0.5f), new Vector2(2.2f, 1f), new Color(0.55f, 0.55f, 0.60f), squareSprite);
        CreateBlock(world.transform, "MiniPlat3", new Vector2(16.5f, -0.5f), new Vector2(2.2f, 1f), new Color(0.55f, 0.55f, 0.60f), squareSprite);

        // SOL BAS (large, accessible en tombant dans les trous)
        CreateBlock(world.transform, "SolBas", new Vector2(0, -10), new Vector2(80, 4), new Color(0.30f, 0.30f, 0.35f), squareSprite);

        // PORTE (visuel doré, posée sur le sol bas, sans interaction pour l'instant)
        CreateBlock(world.transform, "Porte", new Vector2(0, -6.5f), new Vector2(2, 3), new Color(0.95f, 0.78f, 0.32f), squareSprite);

        // MURS LATÉRAUX (containment — empêchent Zell de sortir de la map)
        CreateBlock(world.transform, "MurGauche", new Vector2(-40, 0), new Vector2(2, 24), new Color(0.25f, 0.20f, 0.20f), squareSprite);
        CreateBlock(world.transform, "MurDroit", new Vector2(40, 0), new Vector2(2, 24), new Color(0.25f, 0.20f, 0.20f), squareSprite);

        // === Player ===
        var player = CreatePlayer(circleSprite);

        // Reparent caméra sur le Player et offset léger
        camGO.transform.SetParent(player.transform, worldPositionStays: false);
        camGO.transform.localPosition = new Vector3(0, 1, -10);

        // Sauvegarde de la scène
        EditorSceneManager.SaveScene(scene, SceneAssetPath);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        Debug.Log("[SetupTutoStart] Scene cree : " + SceneAssetPath);
    }

    // ── Création d'un bloc statique (sol/mur/plafond) ───────────────────
    private static GameObject CreateBlock(Transform parent, string name, Vector2 pos, Vector2 size, Color color, Sprite sprite)
    {
        var go = new GameObject(name);
        go.transform.SetParent(parent, false);
        go.transform.position = pos;

        var sr = go.AddComponent<SpriteRenderer>();
        sr.sprite = sprite;
        sr.color = color;
        sr.drawMode = SpriteDrawMode.Sliced;
        sr.size = size;
        sr.sortingOrder = -1;

        var col = go.AddComponent<BoxCollider2D>();
        col.size = size;

        return go;
    }

    // ── Création du Player boule d'énergie ──────────────────────────────
    private static GameObject CreatePlayer(Sprite circle)
    {
        var player = new GameObject("Player");
        player.transform.position = new Vector2(0, 2f);
        player.tag = "Player";

        var rb = player.AddComponent<Rigidbody2D>();
        rb.gravityScale = 3f;
        rb.freezeRotation = true;
        rb.interpolation = RigidbodyInterpolation2D.Interpolate;
        rb.collisionDetectionMode = CollisionDetectionMode2D.Continuous;

        var col = player.AddComponent<CircleCollider2D>();
        col.radius = 0.45f;

        player.AddComponent<PlayerController>();

        // Visual : conteneur + 4 couches concentriques (du plus large/dim au cœur)
        var visual = new GameObject("Visual");
        visual.transform.SetParent(player.transform, false);
        visual.AddComponent<EnergyOrbVisual>();

        CreateOrbLayer(visual.transform, "OrbOuter", 3.0f, new Color(0.30f, 0.50f, 1.00f, 0.15f), 0, circle);
        CreateOrbLayer(visual.transform, "OrbMid", 2.0f, new Color(0.45f, 0.75f, 1.00f, 0.30f), 1, circle);
        CreateOrbLayer(visual.transform, "OrbInner", 1.1f, new Color(0.80f, 0.95f, 1.00f, 0.70f), 2, circle);
        CreateOrbLayer(visual.transform, "OrbCore", 0.45f, new Color(1.00f, 1.00f, 1.00f, 1.00f), 3, circle);

        // Light 2D ponctuelle (le glow réel autour de la boule)
        var lightGO = new GameObject("OrbLight");
        lightGO.transform.SetParent(visual.transform, false);
        var pl = lightGO.AddComponent<Light2D>();
        pl.lightType = Light2D.LightType.Point;
        pl.color = new Color(0.6f, 0.85f, 1.0f);
        pl.intensity = 2.5f;
        pl.pointLightOuterRadius = 5f;
        pl.pointLightInnerRadius = 0.6f;

        return player;
    }

    private static GameObject CreateOrbLayer(Transform parent, string name, float scale, Color color, int order, Sprite sprite)
    {
        var go = new GameObject(name);
        go.transform.SetParent(parent, false);
        go.transform.localScale = Vector3.one * scale;

        var sr = go.AddComponent<SpriteRenderer>();
        sr.sprite = sprite;
        sr.color = color;
        sr.sortingOrder = order;

        return go;
    }

    // ── Génération paresseuse des sprites placeholder (carré + cercle doux) ──
    private static Sprite GetOrCreateSquareSprite()
    {
        var path = SpriteFolder + "/WhiteSquare.png";
        var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(path);
        if (sprite != null) return sprite;

        var tex = new Texture2D(8, 8, TextureFormat.RGBA32, false);
        var pixels = new Color32[8 * 8];
        for (int i = 0; i < pixels.Length; i++) pixels[i] = new Color32(255, 255, 255, 255);
        tex.SetPixels32(pixels);
        tex.Apply();
        File.WriteAllBytes(path, tex.EncodeToPNG());
        Object.DestroyImmediate(tex);
        AssetDatabase.ImportAsset(path);

        var imp = (TextureImporter)AssetImporter.GetAtPath(path);
        imp.textureType = TextureImporterType.Sprite;
        imp.spriteImportMode = SpriteImportMode.Single;
        imp.spritePixelsPerUnit = 8f;
        imp.filterMode = FilterMode.Bilinear;
        imp.wrapMode = TextureWrapMode.Repeat;
        var settings = new TextureImporterSettings();
        imp.ReadTextureSettings(settings);
        settings.spriteMeshType = SpriteMeshType.FullRect;
        imp.SetTextureSettings(settings);
        imp.SaveAndReimport();

        return AssetDatabase.LoadAssetAtPath<Sprite>(path);
    }

    private static Sprite GetOrCreateCircleSprite()
    {
        var path = SpriteFolder + "/SoftCircle.png";
        var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(path);
        if (sprite != null) return sprite;

        int s = 256;
        var tex = new Texture2D(s, s, TextureFormat.RGBA32, false);
        var center = new Vector2(s / 2f, s / 2f);
        float maxR = s / 2f;
        var pixels = new Color32[s * s];
        for (int y = 0; y < s; y++)
        {
            for (int x = 0; x < s; x++)
            {
                float d = Vector2.Distance(new Vector2(x + 0.5f, y + 0.5f), center);
                float t = d / maxR;
                float a = (t >= 1f) ? 0f : Mathf.Pow(1f - t, 1.6f);
                byte ab = (byte)Mathf.Clamp(a * 255f, 0f, 255f);
                pixels[y * s + x] = new Color32(255, 255, 255, ab);
            }
        }
        tex.SetPixels32(pixels);
        tex.Apply();
        File.WriteAllBytes(path, tex.EncodeToPNG());
        Object.DestroyImmediate(tex);
        AssetDatabase.ImportAsset(path);

        var imp = (TextureImporter)AssetImporter.GetAtPath(path);
        imp.textureType = TextureImporterType.Sprite;
        imp.spriteImportMode = SpriteImportMode.Single;
        imp.spritePixelsPerUnit = 256f;
        imp.filterMode = FilterMode.Bilinear;
        imp.alphaIsTransparency = true;
        imp.SaveAndReimport();

        return AssetDatabase.LoadAssetAtPath<Sprite>(path);
    }

    private static void EnsureFolder(string path)
    {
        if (AssetDatabase.IsValidFolder(path)) return;
        var parts = path.Split('/');
        string acc = parts[0];
        for (int i = 1; i < parts.Length; i++)
        {
            var sub = acc + "/" + parts[i];
            if (!AssetDatabase.IsValidFolder(sub))
                AssetDatabase.CreateFolder(acc, parts[i]);
            acc = sub;
        }
    }
}
