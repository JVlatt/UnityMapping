using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(FragManager))]
public class FragManagerEditor : Editor
{
	public void UpdateFragList(FragManager fragManager)
	{
		fragManager.layoutFragList.Clear();
		Frag[] fragArray = new Frag[fragManager.activeLayout.GetComponentsInChildren<Frag>(true).Length];
		System.Array.Copy(fragManager.activeLayout.GetComponentsInChildren<Frag>(true), fragArray, fragArray.Length);
		for (int i = 0; i < fragArray.Length; i++)
		{
			if(fragArray[i].transform.parent.gameObject.activeSelf)
				fragManager.layoutFragList.Add(fragArray[i]);
		}

		if (fragManager.fragSelection != null)
		{
			fragManager.activeFragList.Clear();
			foreach (int fragIndex in fragManager.fragSelection.fragList)
			{
				fragManager.activeFragList.Add(fragManager.layoutFragList[fragIndex]);
			}
		}
		else
		{
			fragManager.activeFragList.Clear();
			foreach (Frag frag in fragManager.layoutFragList)
			{
				fragManager.activeFragList.Add(frag);
			}
		}

		foreach(Frag frag in fragManager.activeFragList)
			frag.gameObject.SetActive(true);
	}

	public override void OnInspectorGUI ()
	{
		base.OnInspectorGUI();
		FragManager fragManager = (FragManager)target;

		string[] options = new string[fragManager.transform.childCount];

		for (int i = 0; i < fragManager.transform.childCount; i++)
			options[i] = fragManager.transform.GetChild(i).name;

		int activeIndex = 0;

		if (fragManager.activeLayout != null)
		{
			activeIndex = fragManager.transform.Find(fragManager.activeLayout.name).GetSiblingIndex();
		}

		activeIndex = EditorGUILayout.Popup("Active Layout", activeIndex, options);

		if(fragManager.activeLayout != fragManager.transform.GetChild(activeIndex))
		{
			if(fragManager.activeLayout != null)
				fragManager.activeLayout.gameObject.SetActive(false);

			fragManager.transform.GetChild(activeIndex).gameObject.SetActive(true);
			fragManager.activeLayout = fragManager.transform.GetChild(activeIndex);
			fragManager.layoutFragList.Clear();
			UpdateFragList(fragManager);
		}

		if(fragManager.Mode == FragManager.MANAGER_MODE.AUTOTRIGGER && fragManager.RandomSettings)
		{
			if(GUILayout.Button("Randomize Frag Settings"))
			{
				foreach(Frag frag in fragManager.activeFragList)
				{
					frag.FadeInDuration = Random.Range(fragManager.FadeInTimeMinMax.x, fragManager.FadeInTimeMinMax.y);
					frag.Duration = Random.Range(fragManager.ActiveTimeMinMax.x, fragManager.ActiveTimeMinMax.y);
					frag.FadeOutDuration = Random.Range(fragManager.FadeOutTimeMinMax.x, fragManager.FadeOutTimeMinMax.y);
				}
			}
		}

		if (GUILayout.Button("Update Frag Selection"))
		{
			UpdateFragList(fragManager);
		}

		if (GUILayout.Button("All Frags"))
		{
			GameObject[] gameObjectsToSelect = new GameObject[fragManager.layoutFragList.Count];

			for (int i = 0; i < fragManager.layoutFragList.Count; i++)
			{
				gameObjectsToSelect[i] = fragManager.layoutFragList[i].gameObject;
			}

			Selection.objects = gameObjectsToSelect;
		}

		if (fragManager.fragSelection != null)
		{
			if (GUILayout.Button("Use Selection Frags"))
			{
				GameObject[] gameObjectsToSelect = new GameObject[fragManager.fragSelection.fragList.Count];

				for (int i = 0; i < fragManager.fragSelection.fragList.Count; i++)
				{
					gameObjectsToSelect[i] = fragManager.layoutFragList[fragManager.fragSelection.fragList[i]].gameObject;
				}

				Selection.objects = gameObjectsToSelect;
			}

			if (GUILayout.Button("Invert Selection Frags"))
			{
				GameObject[] gameObjectsToSelect = new GameObject[fragManager.layoutFragList.Count - fragManager.fragSelection.fragList.Count];

				int selectionIndex = 0;

				for (int i = 0; i < fragManager.layoutFragList.Count; i++)
				{
					if (!fragManager.fragSelection.fragList.Contains(i))
					{
						gameObjectsToSelect[selectionIndex] = fragManager.layoutFragList[i].gameObject;
						selectionIndex++;
					}
				}

				Selection.objects = gameObjectsToSelect;
			}


		}
		
	}
}
