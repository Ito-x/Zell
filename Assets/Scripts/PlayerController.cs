using UnityEngine;
using UnityEngine.InputSystem;

/// <summary>
/// Contrôleur de Zell — déplacement Q/D AZERTY, saut variable, dash (mini-téléportation
/// Radagon-like), hooks attaque.
///
/// Saut variable :
///   - Tap court sur Espace = saut bas (velocity cut au release)
///   - Maintenir Espace = saut maximal
///
/// Dash (clic droit) :
///   - Mini-téléportation instantanée sur `dashDistance` unités dans la direction de
///     face (input courant > dernier facing > droite par défaut)
///   - Raycast pour clamper la fin du dash si on rentre dans un mur
///   - I-frames pendant `dashIFrameDuration` (utile quand on aura des dégâts)
///   - Visuel : afterimage warm au point de départ + 2 flashs électriques (A et B)
///
/// Mapping AZERTY :
///   Unity reference les touches par POSITION physique sur clavier US.
///   Sur AZERTY, la touche labellisée "Q" est en position US-"A" → on lit `aKey`.
/// </summary>
[RequireComponent(typeof(Rigidbody2D))]
public class PlayerController : MonoBehaviour
{
    [Header("Mouvement")]
    public float moveSpeed = 8f;
    public float jumpForce = 14f;
    public float gravityScale = 3f;

    [Header("Saut variable")]
    [Range(0f, 1f)] public float jumpCutMultiplier = 0.4f;

    [Header("Dash (mini-téléportation Radagon-like)")]
    public float dashDistance = 4.5f;
    public float dashCooldown = 0.5f;
    public float dashIFrameDuration = 0.20f;
    public float dashFlashDuration = 0.18f;
    public float afterimageDuration = 0.35f;
    public Color lightningColor = new Color(0.7f, 0.92f, 1.0f, 0.95f);
    public Color afterimageColor = new Color(1.0f, 0.7f, 0.25f, 0.55f);

    [Header("Visual References (set by setup)")]
    public Sprite circleSpriteRef;
    public Sprite squareSpriteRef;

    [Header("Détection sol (raycast)")]
    public float groundRayLength = 0.7f;
    public LayerMask groundLayer = ~0;

    [Header("Etat (lecture seule)")]
    [SerializeField] private bool _isGrounded;
    [SerializeField] private bool _isInvincible;
    [SerializeField] private float _facingDir = 1f;

    private Rigidbody2D _rb;
    private Collider2D _col;
    private float _lastDashTime = -999f;

    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        _col = GetComponent<Collider2D>();
        _rb.gravityScale = gravityScale;
        _rb.freezeRotation = true;
        Physics2D.queriesStartInColliders = false;

        if (_col != null && _col.sharedMaterial == null)
        {
            var mat = new PhysicsMaterial2D("PlayerNoFriction") { friction = 0f, bounciness = 0f };
            _col.sharedMaterial = mat;
        }
    }

    void Update()
    {
        var kb = Keyboard.current;
        var mouse = Mouse.current;
        if (kb == null) return;

        var hit = Physics2D.Raycast(transform.position, Vector2.down, groundRayLength, groundLayer);
        _isGrounded = hit.collider != null;

        // === Mouvement horizontal — AZERTY Q/D + flèches ===
        float h = 0f;
        if (kb.aKey.isPressed || kb.leftArrowKey.isPressed) h = -1f;
        else if (kb.dKey.isPressed || kb.rightArrowKey.isPressed) h = 1f;
        _rb.linearVelocity = new Vector2(h * moveSpeed, _rb.linearVelocity.y);

        // Met à jour le facing dir (utile pour le dash quand pas d'input)
        if (Mathf.Abs(h) > 0.01f) _facingDir = Mathf.Sign(h);

        // === Saut (déclenchement) ===
        bool jumpPressed = kb.spaceKey.wasPressedThisFrame || kb.upArrowKey.wasPressedThisFrame;
        if (jumpPressed && _isGrounded)
        {
            _rb.linearVelocity = new Vector2(_rb.linearVelocity.x, jumpForce);
        }

        // === Saut variable : coupe la vitesse verticale au release si on monte encore ===
        bool jumpReleased = kb.spaceKey.wasReleasedThisFrame || kb.upArrowKey.wasReleasedThisFrame;
        if (jumpReleased && _rb.linearVelocity.y > 0f)
        {
            _rb.linearVelocity = new Vector2(_rb.linearVelocity.x, _rb.linearVelocity.y * jumpCutMultiplier);
        }

        // === Combat hooks ===
        if (mouse != null)
        {
            if (mouse.leftButton.wasPressedThisFrame)
                DoAttack();

            if (mouse.rightButton.wasPressedThisFrame && Time.time - _lastDashTime > dashCooldown)
            {
                DoDash(h);
                _lastDashTime = Time.time;
            }
        }
    }

    private void DoAttack()
    {
        Debug.Log("[Player] Attaque (placeholder — brancher epee plus tard)");
        // TODO: instancier hitbox épée, slash visuel arc blanc-or
    }

    private void DoDash(float horizontalInput)
    {
        // Direction : input courant si présent, sinon last facing
        float dir = Mathf.Abs(horizontalInput) > 0.01f ? Mathf.Sign(horizontalInput) : _facingDir;

        Vector3 startPos = transform.position;
        Vector3 endPos = startPos + Vector3.right * (dir * dashDistance);

        // Raycast pour ne pas entrer dans un mur
        var wallHit = Physics2D.Raycast(startPos, Vector2.right * dir, dashDistance, groundLayer);
        if (wallHit.collider != null)
        {
            // S'arrête un peu avant le mur (radius du player + petite marge)
            endPos = (Vector3)wallHit.point - new Vector3(dir * 0.6f, 0f, 0f);
        }

        // Visuels avant téléportation (au point de départ)
        SpawnAfterimage(startPos);
        SpawnLightning(startPos);

        // Téléportation
        transform.position = endPos;
        // Conserve un peu d'élan horizontal (sensation de jet)
        _rb.linearVelocity = new Vector2(dir * moveSpeed * 1.2f, 0f);

        // Visuel d'arrivée
        SpawnLightning(endPos);

        // I-frames
        _isInvincible = true;
        Invoke(nameof(EndIFrames), dashIFrameDuration);

        Debug.Log($"[Player] Dash dir={dir} from {startPos} to {endPos}");
    }

    private void EndIFrames() => _isInvincible = false;

    private void SpawnAfterimage(Vector3 pos)
    {
        if (circleSpriteRef == null) return;
        var go = new GameObject("Afterimage");
        go.transform.position = pos;
        go.transform.localScale = Vector3.one * 1.1f; // un peu plus large que l'orb

        var sr = go.AddComponent<SpriteRenderer>();
        sr.sprite = circleSpriteRef;
        sr.color = afterimageColor;
        sr.sortingOrder = -2;

        var fade = go.AddComponent<FadeAndDestroy>();
        fade.duration = afterimageDuration;
        fade.shrink = true;
        fade.shrinkTo = 0.4f;
    }

    private void SpawnLightning(Vector3 pos)
    {
        if (squareSpriteRef == null) return;
        var go = new GameObject("LightningFlash");
        go.transform.position = pos;

        var sr = go.AddComponent<SpriteRenderer>();
        sr.sprite = squareSpriteRef;
        sr.color = lightningColor;
        sr.drawMode = SpriteDrawMode.Sliced;
        sr.size = new Vector2(0.35f, 7f); // beam vertical fin
        sr.sortingOrder = 4;

        var fade = go.AddComponent<FadeAndDestroy>();
        fade.duration = dashFlashDuration;
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.cyan;
        Gizmos.DrawLine(transform.position, transform.position + Vector3.down * groundRayLength);
    }
}
