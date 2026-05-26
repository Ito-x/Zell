using UnityEngine;

/// <summary>
/// Petit helper : fait fondre un SpriteRenderer en alpha de sa valeur initiale → 0
/// sur `duration` secondes, puis détruit le GameObject. Optionnellement, scale
/// shrink en parallèle pour un effet "se dissipe".
///
/// À utiliser via GameObject + SpriteRenderer + ce composant.
/// </summary>
[RequireComponent(typeof(SpriteRenderer))]
public class FadeAndDestroy : MonoBehaviour
{
    public float duration = 0.35f;
    public bool shrink = false;
    public float shrinkTo = 0.6f;

    private SpriteRenderer _sr;
    private Color _baseColor;
    private Vector3 _baseScale;
    private float _t;

    void Awake()
    {
        _sr = GetComponent<SpriteRenderer>();
        _baseColor = _sr.color;
        _baseScale = transform.localScale;
    }

    void Update()
    {
        _t += Time.deltaTime;
        float k = Mathf.Clamp01(_t / duration);

        var c = _baseColor;
        c.a = Mathf.Lerp(_baseColor.a, 0f, k);
        _sr.color = c;

        if (shrink)
            transform.localScale = Vector3.Lerp(_baseScale, _baseScale * shrinkTo, k);

        if (k >= 1f)
            Destroy(gameObject);
    }
}
