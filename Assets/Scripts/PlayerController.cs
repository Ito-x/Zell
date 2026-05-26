using UnityEngine;
using UnityEngine.InputSystem;

/// <summary>
/// Contrôleur basique pour la boule d'énergie Zell — déplacement gauche/droite + saut.
/// Aucune fioriture, on itère après.
///
/// IMPORTANT — mapping AZERTY :
/// Unity reference les touches par leur POSITION physique sur un clavier US (QWERTY).
/// Sur AZERTY :
///   - La touche labellisée "Q" est en position US-"A" → on lit donc `aKey`
///   - La touche labellisée "D" est en position US-"D" → on lit donc `dKey`
/// Donc pour un AZERTY "Q gauche, D droite", on lit aKey / dKey.
/// </summary>
[RequireComponent(typeof(Rigidbody2D))]
public class PlayerController : MonoBehaviour
{
    [Header("Mouvement")]
    public float moveSpeed = 8f;
    public float jumpForce = 14f;
    public float gravityScale = 3f;

    [Header("Détection sol (raycast)")]
    public float groundRayLength = 0.7f;
    public LayerMask groundLayer = ~0;

    private Rigidbody2D _rb;
    private bool _isGrounded;

    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        _rb.gravityScale = gravityScale;
        _rb.freezeRotation = true;
        Physics2D.queriesStartInColliders = false;
    }

    void Update()
    {
        var kb = Keyboard.current;
        if (kb == null) return;

        // Ground check
        var hit = Physics2D.Raycast(transform.position, Vector2.down, groundRayLength, groundLayer);
        _isGrounded = hit.collider != null;

        // Mouvement horizontal — Q/D AZERTY (= aKey/dKey en physique US)
        float h = 0f;
        if (kb.aKey.isPressed || kb.leftArrowKey.isPressed) h = -1f;
        else if (kb.dKey.isPressed || kb.rightArrowKey.isPressed) h = 1f;
        _rb.linearVelocity = new Vector2(h * moveSpeed, _rb.linearVelocity.y);

        // Saut — Espace ou flèche haut
        if ((kb.spaceKey.wasPressedThisFrame || kb.upArrowKey.wasPressedThisFrame) && _isGrounded)
        {
            _rb.linearVelocity = new Vector2(_rb.linearVelocity.x, jumpForce);
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.cyan;
        Gizmos.DrawLine(transform.position, transform.position + Vector3.down * groundRayLength);
    }
}
