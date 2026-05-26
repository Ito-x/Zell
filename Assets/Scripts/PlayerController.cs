using UnityEngine;

/// <summary>
/// Contrôleur basique pour la boule d'énergie Zell.
/// Déplacement gauche/droite + saut. Aucun fioriture, on itère après.
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
    public LayerMask groundLayer = ~0; // par défaut tout, le -queriesStartInColliders=false filtre le player lui-même

    private Rigidbody2D _rb;
    private bool _isGrounded;

    void Awake()
    {
        _rb = GetComponent<Rigidbody2D>();
        _rb.gravityScale = gravityScale;
        _rb.freezeRotation = true;
        // Raycasts ignorent les colliders dans lesquels ils démarrent (= notre propre body)
        Physics2D.queriesStartInColliders = false;
    }

    void Update()
    {
        // Ground check par raycast vers le bas
        var hit = Physics2D.Raycast(transform.position, Vector2.down, groundRayLength, groundLayer);
        _isGrounded = hit.collider != null;

        // Mouvement horizontal (legacy Input — A/D, flèches)
        float h = 0f;
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow)) h = -1f;
        else if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow)) h = 1f;
        _rb.linearVelocity = new Vector2(h * moveSpeed, _rb.linearVelocity.y);

        // Saut (espace)
        if ((Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.UpArrow)) && _isGrounded)
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
