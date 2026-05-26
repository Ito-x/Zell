using UnityEngine;
using UnityEngine.InputSystem;

/// <summary>
/// Contrôleur de Zell — déplacement Q/D AZERTY, saut variable, hooks attaque/dash.
///
/// Saut variable :
///   - Tap court sur Espace = saut bas (velocity cut au release)
///   - Maintenir Espace = saut maximal
///
/// Mapping AZERTY :
///   Unity reference les touches par POSITION physique sur clavier US.
///   Sur AZERTY, la touche labellisée "Q" est en position US-"A" → on lit `aKey`.
///
/// Combat (placeholders pour l'instant) :
///   - Clic gauche  = attaque (à brancher à l'épée plus tard)
///   - Clic droit   = dash (à brancher à la mini-téléportation plus tard)
/// </summary>
[RequireComponent(typeof(Rigidbody2D))]
public class PlayerController : MonoBehaviour
{
    [Header("Mouvement")]
    public float moveSpeed = 8f;
    public float jumpForce = 14f;
    public float gravityScale = 3f;

    [Header("Saut variable")]
    [Tooltip("Multiplicateur de la vitesse verticale quand on relâche Espace en montant. " +
             "Plus c'est bas, plus le saut court est court.")]
    [Range(0f, 1f)] public float jumpCutMultiplier = 0.4f;

    [Header("Combat hooks")]
    public float dashCooldown = 0.5f;

    [Header("Détection sol (raycast)")]
    public float groundRayLength = 0.7f;
    public LayerMask groundLayer = ~0;

    private Rigidbody2D _rb;
    private Collider2D _col;
    private bool _isGrounded;
    private float _lastDashTime = -999f;

    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        _col = GetComponent<Collider2D>();
        _rb.gravityScale = gravityScale;
        _rb.freezeRotation = true;
        Physics2D.queriesStartInColliders = false;

        // Friction 0 sur le player pour éviter de coller aux murs en saut.
        if (_col != null && _col.sharedMaterial == null)
        {
            var mat = new PhysicsMaterial2D("PlayerNoFriction")
            {
                friction = 0f,
                bounciness = 0f
            };
            _col.sharedMaterial = mat;
        }
    }

    void Update()
    {
        var kb = Keyboard.current;
        var mouse = Mouse.current;
        if (kb == null) return;

        // Ground check par raycast vers le bas
        var hit = Physics2D.Raycast(transform.position, Vector2.down, groundRayLength, groundLayer);
        _isGrounded = hit.collider != null;

        // === Mouvement horizontal ===
        float h = 0f;
        if (kb.aKey.isPressed || kb.leftArrowKey.isPressed) h = -1f;
        else if (kb.dKey.isPressed || kb.rightArrowKey.isPressed) h = 1f;
        _rb.linearVelocity = new Vector2(h * moveSpeed, _rb.linearVelocity.y);

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

        // === Combat hooks (placeholders) ===
        if (mouse != null)
        {
            if (mouse.leftButton.wasPressedThisFrame)
                DoAttack();

            if (mouse.rightButton.wasPressedThisFrame && Time.time - _lastDashTime > dashCooldown)
            {
                DoDash();
                _lastDashTime = Time.time;
            }
        }
    }

    private void DoAttack()
    {
        Debug.Log("[Player] Attaque (placeholder — brancher epee plus tard)");
        // TODO: instancier hitbox épée, slash visuel arc blanc-or
    }

    private void DoDash()
    {
        Debug.Log("[Player] Dash (placeholder — brancher mini-teleportation plus tard)");
        // TODO: mini-téléportation Radagon-like, iframes, afterimage
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.cyan;
        Gizmos.DrawLine(transform.position, transform.position + Vector3.down * groundRayLength);
    }
}
