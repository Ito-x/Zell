using UnityEngine;

/// <summary>
/// Caméra 2D qui suit une cible avec :
///   - Damping (amortissement) : la caméra ne colle pas instantanément
///   - Dead zone : zone centrale où la cible peut bouger sans déplacer la caméra
///   - Lookahead : anticipe la direction de mouvement (regarde devant)
///   - Vertical lock optionnel : ignore les petits mouvements verticaux (utile en plateforme)
///
/// À mettre sur la Main Camera (pas enfant du Player — la caméra est libre).
/// </summary>
public class FollowCamera2D : MonoBehaviour
{
    [Header("Cible")]
    public Transform target;
    public Vector2 offset = new Vector2(0f, 1f);

    [Header("Dead zone (zone morte centrale)")]
    public Vector2 deadZone = new Vector2(2.0f, 1.5f);

    [Header("Damping (plus haut = plus lent)")]
    [Range(0.01f, 1f)] public float dampingX = 0.20f;
    [Range(0.01f, 1f)] public float dampingY = 0.35f;

    [Header("Lookahead horizontal")]
    public float lookAheadDistance = 3f;
    [Range(0.01f, 1f)] public float lookAheadSmooth = 0.30f;

    private Vector3 _vel;
    private float _currentLookAhead;
    private float _facingDir = 1f;
    private Rigidbody2D _targetRb;

    void Start()
    {
        if (target != null) _targetRb = target.GetComponent<Rigidbody2D>();
    }

    void LateUpdate()
    {
        if (target == null) return;

        // Mise à jour direction selon vélocité horizontale du target
        if (_targetRb != null)
        {
            float vx = _targetRb.linearVelocity.x;
            if (Mathf.Abs(vx) > 0.3f) _facingDir = Mathf.Sign(vx);
        }

        // Lookahead lissé
        float targetLookAhead = _facingDir * lookAheadDistance;
        _currentLookAhead = Mathf.Lerp(_currentLookAhead, targetLookAhead, lookAheadSmooth * Time.deltaTime * 10f);

        // Position désirée
        Vector3 desired = target.position + (Vector3)offset + Vector3.right * _currentLookAhead;
        Vector3 current = transform.position;

        // Dead zone : ne bouger que si target sort de la zone
        float dx = desired.x - current.x;
        float dy = desired.y - current.y;
        Vector3 targetPos = current;
        if (Mathf.Abs(dx) > deadZone.x) targetPos.x = desired.x - Mathf.Sign(dx) * deadZone.x;
        if (Mathf.Abs(dy) > deadZone.y) targetPos.y = desired.y - Mathf.Sign(dy) * deadZone.y;

        // Damping (SmoothDamp séparé X / Y pour avoir des dampings différents)
        Vector3 newPos = current;
        newPos.x = Mathf.SmoothDamp(current.x, targetPos.x, ref _vel.x, dampingX);
        newPos.y = Mathf.SmoothDamp(current.y, targetPos.y, ref _vel.y, dampingY);
        newPos.z = current.z;
        transform.position = newPos;
    }

    void OnDrawGizmosSelected()
    {
        if (target == null) return;
        Gizmos.color = new Color(1f, 1f, 0f, 0.5f);
        Vector3 c = target.position + (Vector3)offset;
        Gizmos.DrawWireCube(c, new Vector3(deadZone.x * 2, deadZone.y * 2, 0));
    }
}
