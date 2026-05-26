using UnityEngine;

/// <summary>
/// Anime la boule d'énergie de Zell : pulse doux + dérive lente des couches
/// pour donner l'aspect "fluide vivant", pas figé.
/// À mettre sur le node "Visual" parent des sprites OrbOuter/OrbMid/OrbInner/OrbCore.
/// </summary>
public class EnergyOrbVisual : MonoBehaviour
{
    [Header("Pulse global")]
    public float pulseSpeed = 1.6f;
    public float pulseAmount = 0.12f;

    [Header("Dérive des couches (chaque couche a sa propre phase)")]
    public float layerDriftSpeed = 0.9f;
    public float layerDriftAmount = 0.06f;

    private Transform[] _layers;
    private Vector3[] _baseLocalPos;
    private Vector3 _baseScale;
    private float[] _phases;

    void Awake()
    {
        _baseScale = transform.localScale;
        int n = transform.childCount;
        _layers = new Transform[n];
        _baseLocalPos = new Vector3[n];
        _phases = new float[n];
        for (int i = 0; i < n; i++)
        {
            _layers[i] = transform.GetChild(i);
            _baseLocalPos[i] = _layers[i].localPosition;
            _phases[i] = i * 1.7f;
        }
    }

    void Update()
    {
        // Pulse global de toute la boule
        float pulse = 1f + Mathf.Sin(Time.time * pulseSpeed) * pulseAmount;
        transform.localScale = _baseScale * pulse;

        // Chaque couche dérive doucement avec sa propre phase
        for (int i = 0; i < _layers.Length; i++)
        {
            float t = Time.time * layerDriftSpeed + _phases[i];
            var offset = new Vector3(Mathf.Sin(t) * layerDriftAmount, Mathf.Cos(t * 1.3f) * layerDriftAmount, 0f);
            _layers[i].localPosition = _baseLocalPos[i] + offset;
        }
    }
}
