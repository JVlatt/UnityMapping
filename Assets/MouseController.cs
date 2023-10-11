using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseController : MonoBehaviour
{
    private void Update()
    {
        Vector3 Position = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        Debug.Log(Position);
        transform.position = new Vector3(Position.x, Position.y, 0);
    }
}
