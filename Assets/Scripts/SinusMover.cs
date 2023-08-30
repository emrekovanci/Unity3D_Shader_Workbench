using UnityEngine;

[ExecuteInEditMode]
public class SinusMover : MonoBehaviour
{
    public float Speed = 1f;
    public float Frequency = 2f;
    public float Amplitude = 1f;

    private Vector3 _startPos;

    private void Start()
    {
        _startPos = transform.localPosition;
    }

    private void Update()
    {
        Vector3 nextPos = _startPos + new Vector3(0f, Mathf.Sin(Time.time * Speed * Frequency) * Amplitude , 0f);

        transform.localPosition = nextPos;
    }
}
