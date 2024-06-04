using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MouseSelector : MonoBehaviour
{
	public FragManager fragManager;

	private SELECTION_MODE selectionMode;
	private enum SELECTION_MODE
	{
		NONE,
		ADD,
		REMOVE
	}

	private void Update ()
	{
		Vector3 mousePos = Input.mousePosition;
		mousePos.z = Camera.main.orthographic ? 0 : -10f;
		Vector3 desiredPosition = Camera.main.ScreenToWorldPoint(mousePos);
		desiredPosition.z = 0;
		transform.position = desiredPosition;

		if (Input.GetMouseButtonDown(0))
			selectionMode = SELECTION_MODE.ADD;
		if (Input.GetMouseButtonDown(1))
			selectionMode = SELECTION_MODE.REMOVE;
		if (Input.GetMouseButtonDown(2))
			selectionMode = SELECTION_MODE.NONE;

	}


	private void OnTriggerEnter ( Collider collision )
	{
		Frag frag = collision.GetComponent<Frag>();

		if (frag != null)
		{
			switch (selectionMode)
			{
				case SELECTION_MODE.NONE:
					break;
				case SELECTION_MODE.ADD:
					fragManager.AddFragToSelection(frag);
					break;
				case SELECTION_MODE.REMOVE:
					fragManager.RemoveFragFromSelection(frag);
					break;
				default:
					break;
			}
		}
	}
}
