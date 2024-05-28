using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(XMLReader))]
public class XMLReaderEditor : Editor
{
	public override void OnInspectorGUI ()
	{
		base.OnInspectorGUI();
		XMLReader xmlReader = (XMLReader)target;

		if (GUILayout.Button("Read XML"))
		{
			xmlReader.LoadScreens();
		}
	}
}
