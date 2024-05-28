using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(FragManager))]
public class FragManagerEditor : Editor
{
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
			fragManager.m_fragList.Clear();
			Frag[] fragArray = new Frag[fragManager.activeLayout.GetComponentsInChildren<Frag>(false).Length];
			System.Array.Copy(fragManager.activeLayout.GetComponentsInChildren<Frag>(false), fragArray, fragArray.Length);
			for(int i = 0; i < fragArray.Length; i++)
			{
				fragManager.m_fragList.Add(fragArray[i]);
			}
		}

		if (GUILayout.Button("All Frags"))
		{
			GameObject[] gameObjectsToSelect = new GameObject[fragManager.m_fragList.Count];

			for (int i = 0; i < fragManager.m_fragList.Count; i++)
			{
				gameObjectsToSelect[i] = fragManager.m_fragList[i].gameObject;
			}

			Selection.objects = gameObjectsToSelect;
		}

		if (fragManager.Mode == FragManager.MANAGER_MODE.SELECT && fragManager.fragSelection != null)
		{
			if (GUILayout.Button("Use Selection Frags"))
			{
				GameObject[] gameObjectsToSelect = new GameObject[fragManager.fragSelection.fragList.Count];

				for (int i = 0; i < fragManager.fragSelection.fragList.Count; i++)
				{
					gameObjectsToSelect[i] = fragManager.m_fragList[fragManager.fragSelection.fragList[i]].gameObject;
				}

				Selection.objects = gameObjectsToSelect;
			}

			if (GUILayout.Button("Invert Selection Frags"))
			{
				GameObject[] gameObjectsToSelect = new GameObject[fragManager.m_fragList.Count - fragManager.fragSelection.fragList.Count];

				int selectionIndex = 0;

				for (int i = 0; i < fragManager.m_fragList.Count; i++)
				{
					if (!fragManager.fragSelection.fragList.Contains(i))
					{
						gameObjectsToSelect[selectionIndex] = fragManager.m_fragList[i].gameObject;
						selectionIndex++;
					}
				}

				Selection.objects = gameObjectsToSelect;
			}


		}
		
	}
}
