using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering.Universal;

/// <summary>
/// Génère la scène TutoStart en code : blockout du spawn de la zone Les Yeux.
/// 3 plateformes (LEFT inaccessible / SPAWN center / RIGHT via stepping stones),
/// plafond, sol bas avec porte (visuel seul, sans collider), murs latéraux,
/// Player boule d'énergie warm (ambre/or), Light 2D, traînée derrière la boule.
///
/// Usage :
///   - Menu Unity : ZELL → Setup TutoStart Scene
///   - Batchmode  : Unity.exe -batchmode -quit -executeMethod SetupTutoStart.Run
/// </summary>
public static class SetupTutoStart
{
    private const string SceneAssetPath = "Assets/Scenes/TutoStart.unity";
    private const string SpriteFolder = "Assets/Art/Sprites";

    // Matériau partagé friction=0 — appliqué à TOUS les colliders pour
    // éviter le sticking aux murs en saut.
    private static PhysicsMaterial2D _noFriction;

    [MenuItem("ZELL/Setup TutoStart Scene")]
    public static void Run()
    {
        EnsureFolder("Assets/Scenes");
        EnsureFolder("Assets/Art");
        EnsureFolder(SpriteFolder);

        var squareSprite = GetOrCreateSquareSprite();
        var circleSprite = GetOrCreateCircleSprite();

        // Matériau partagé sans friction
        _noFriction = new PhysicsMaterial2D("NoFriction") { friction = 0f, bounciness = 0f };

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);

        // === Caméra (sera reparentée sur le Player) ===
        var camGO = new GameObject("Main Camera");
        camGO.tag = "MainCamera";
        var cam = camGO.AddComponent<Camera>();
        cam.orthographic = true;
        cam.orthographicSize = 8f;
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = new Color(0.06f, 0.04f, 0.08f); // sombre legerement violace

        // === Light 2D globale (ambiance chaude douce) ===
        var lightGO = new GameObject("Global Light 2D");
        var gLight = lightGO.AddComponent<Light2D>();
        gLight.lightType = Light2D.LightType.Global;
        gLight.intensity = 0.85f;
        gLight.color = new Color(1f, 0.92f, 0.85f); // chaud creme

        // === World container ===
        // Toutes les plateformes / murs / plafond × 2 par rapport au layout initial.
        // EXCEPTIONS :
        //  - Sol bas : × 5 plus loin verticalement (gros vide pour placer plus tard
        //    des plateformes descendantes vers la droite)
        //  - Porte : taille gigantesque, exceptionnellement présente
        // Player NON inclus dans World → garde sa taille de référence, Zell paraît
        // toute petite dans ce grand monde.
        var world = new GameObject("World");

        // PLAFOND (×2)
        CreateBlock(world.transform, "Plafond", new Vector2(0, 18), new Vector2(160, 4),
            new Color(0.18f, 0.14f, 0.18f), squareSprite, withCollider: true);

        // SOL HAUT (×2) — surface walkable à y=0 (= -2 + half_h 2)
        CreateBlock(world.transform, "SolGauche", new Vector2(-50, -2), new Vector2(28, 4),
            new Color(0.40f, 0.32f, 0.36f), squareSprite, withCollider: true);
        CreateBlock(world.transform, "SolSpawn", new Vector2(0, -2), new Vector2(24, 4),
            new Color(0.55f, 0.45f, 0.35f), squareSprite, withCollider: true);
        CreateBlock(world.transform, "SolDroite", new Vector2(50, -2), new Vector2(28, 4),
            new Color(0.40f, 0.32f, 0.36f), squareSprite, withCollider: true);

        // STEPPING STONES (×2)
        CreateBlock(world.transform, "MiniPlat1", new Vector2(19f, -1), new Vector2(4.4f, 2f),
            new Color(0.50f, 0.40f, 0.40f), squareSprite, withCollider: true);
        CreateBlock(world.transform, "MiniPlat2", new Vector2(26f, -1), new Vector2(4.4f, 2f),
            new Color(0.50f, 0.40f, 0.40f), squareSprite, withCollider: true);
        CreateBlock(world.transform, "MiniPlat3", new Vector2(33f, -1), new Vector2(4.4f, 2f),
            new Color(0.50f, 0.40f, 0.40f), squareSprite, withCollider: true);

        // SOL BAS — surface walkable à y=-80 (vs y=-16 avant). Vide ×5 sous sol haut
        // pour pouvoir ajouter plus tard des plateformes intermédiaires descendantes.
        CreateBlock(world.transform, "SolBas", new Vector2(0, -84), new Vector2(160, 8),
            new Color(0.28f, 0.22f, 0.26f), squareSprite, withCollider: true);

        // PORTE — gigantesque, exceptionnelle. Centrée sur sol bas, taille (16 × 24)
        // sprite seul (pas de collider) → fait partie du background, interaction
        // sans hitbox à venir.
        CreateBlock(world.transform, "Porte", new Vector2(0, -68), new Vector2(16, 24),
            new Color(0.95f, 0.78f, 0.32f), squareSprite, withCollider: false);

        // MURS LATÉRAUX — couvrent tout le vide vertical (plafond → sous sol bas)
        CreateBlock(world.transform, "MurGauche", new Vector2(-80, -32), new Vector2(4, 120),
            new Color(0.20f, 0.16f, 0.18f), squareSprite, withCollider: true);
        CreateBlock(world.transform, "MurDroit", new Vector2(80, -32), new Vector2(4, 120),
            new Color(0.20f, 0.16f, 0.18f), squareSprite, withCollider: true);

        // === Player ===
        var player = CreatePlayer(circleSprite, squareSprite);

        // Caméra LIBRE qui suit le Player via FollowCamera2D (damping + dead zone + lookahead)
        camGO.transform.position = new Vector3(player.transform.position.x, player.transform.position.y + 1f, -10f);
        var follow = camGO.AddComponent<FollowCamera2D>();
        follow.target = player.transform;
        follow.offset = new Vector2(0f, 1f);
        follow.deadZone = new Vector2(2.0f, 1.5f);
        follow.dampingX = 0.20f;
        follow.dampingY = 0.35f;
        follow.lookAheadDistance = 3f;
        follow.lookAheadSmooth = 0.30f;

        EditorSceneManager.SaveScene(scene, SceneAssetPath);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        Debug.Log("[SetupTutoStart] Scene generee : " + SceneAssetPath);
    }

    // ── Création d'un bloc statique ───────────────────────────────────
    private static GameObject CreateBlock(Transform parent, string name, Vector2 pos, Vector2 size,
                                          Color color, Sprite sprite, bool withCollider)
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

        if (withCollider)
        {
            var col = go.AddComponent<BoxCollider2D>();
            col.size = size;
            col.sharedMaterial = _noFriction;
        }

        return go;
    }

    // ── Player boule d'énergie warm (ambre/or) ────────────────────────
    private static GameObject CreatePlayer(Sprite circle, Sprite square)
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
        col.sharedMaterial = _noFriction;

        // PlayerController + passe les sprites pour les visuels du dash
        var ctrl = player.AddComponent<PlayerController>();
        ctrl.circleSpriteRef = circle;
        ctrl.squareSpriteRef = square;

        // === Visual : 4 couches warm + Light 2D + TrailRenderer ===
        var visual = new GameObject("Visual");
        visual.transform.SetParent(player.transform, false);
        visual.AddComponent<EnergyOrbVisual>();

        // Couches concentriques chaudes (orange → ambre → or → blanc-chaud)
        CreateOrbLayer(visual.transform, "OrbOuter", 3.0f, new Color(1.00f, 0.45f, 0.15f, 0.14f), 0, circle);
        CreateOrbLayer(visual.transform, "OrbMid",   2.0f, new Color(1.00f, 0.65f, 0.25f, 0.30f), 1, circle);
        CreateOrbLayer(visual.transform, "OrbInner", 1.1f, new Color(1.00f, 0.85f, 0.45f, 0.75f), 2, circle);
        CreateOrbLayer(visual.transform, "OrbCore",  0.45f, new Color(1.00f, 0.96f, 0.85f, 1.00f), 3, circle);

        // Light 2D ponctuelle warm
        var lightGO = new GameObject("OrbLight");
        lightGO.transform.SetParent(visual.transform, false);
        var pl = lightGO.AddComponent<Light2D>();
        pl.lightType = Light2D.LightType.Point;
        pl.color = new Color(1.0f, 0.75f, 0.40f);
        pl.intensity = 2.5f;
        pl.pointLightOuterRadius = 5f;
        pl.pointLightInnerRadius = 0.6f;

        // === Traînée subtile derrière la boule ===
        AddTrail(player);

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

    private static void AddTrail(GameObject player)
    {
        var trailGO = new GameObject("Trail");
        trailGO.transform.SetParent(player.transform, false);
        trailGO.transform.localPosition = Vector3.zero;

        var trail = trailGO.AddComponent<TrailRenderer>();
        trail.time = 0.30f;
        trail.startWidth = 0.55f;
        trail.endWidth = 0.05f;
        trail.minVertexDistance = 0.05f;
        trail.sortingOrder = -1; // derriere les couches visuelles

        // Matériau additif basique via le shader Sprites/Default
        // (assez bon pour un proto, on raffinera plus tard avec un shader perso)
        trail.material = new Material(Shader.Find("Sprites/Default"));

        // Gradient chaud qui fade en transparence
        var grad = new Gradient();
        grad.SetKeys(
            new GradientColorKey[]
            {
                new GradientColorKey(new Color(1f, 0.7f, 0.25f), 0f),
                new GradientColorKey(new Color(1f, 0.4f, 0.10f), 1f)
            },
            new GradientAlphaKey[]
            {
                new GradientAlphaKey(0.55f, 0f),
                new GradientAlphaKey(0f, 1f)
            }
        );
        trail.colorGradient = grad;
    }

    // ── Sprites placeholder ──────────────────────────────────────────
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
