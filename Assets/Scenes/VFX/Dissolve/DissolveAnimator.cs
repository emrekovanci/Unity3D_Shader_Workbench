using UnityEngine;

[ExecuteInEditMode]
public class DissolveAnimator : MonoBehaviour
{
    public float Speed = 5.0f;
    public float Frequency = 2.0f;

    private Material _material;

    private void Start()
    {
        _material = GetComponent<MeshRenderer>().sharedMaterial;
    }

    private void Update()
    {
        float dissolveAmount = Mathf.Sin(Time.time * Speed * Frequency) * 0.5f + 0.5f;

        _material.SetFloat("_DissolveAmount", dissolveAmount);
    }
}
