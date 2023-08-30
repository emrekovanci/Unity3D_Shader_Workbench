using UnityEngine;

[ExecuteInEditMode]
public class Rotator : MonoBehaviour
{
    public float Speed = 30.0f;

    private void Update()
    {
        transform.Rotate(Vector3.up, Speed * Time.deltaTime);
    }
}
