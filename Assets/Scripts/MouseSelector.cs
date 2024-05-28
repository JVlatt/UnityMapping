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
		Vector3 Position = Camera.main.ScreenToWorldPoint(Input.mousePosition);
		transform.position = new Vector3(Position.x, Position.y, 0);

		if (Input.GetMouseButtonDown(0))
			selectionMode = SELECTION_MODE.ADD;
		if (Input.GetMouseButtonDown(1))
			selectionMode = SELECTION_MODE.REMOVE;
		if (Input.GetMouseButtonDown(2))
			selectionMode = SELECTION_MODE.NONE;

	}


	private void OnTriggerEnter2D ( Collider2D collision )
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
