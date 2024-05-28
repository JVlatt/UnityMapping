using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

public class FragManager : MonoBehaviour
{
	public MANAGER_MODE Mode;

	public Color idleColor;
	public Color activatedColor;

	[HideInInspector] public Transform activeLayout;
	public static FragManager Instance { get; private set;}

	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public float TriggerDelay = .1f;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public int FragTriggered = 1;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public bool RemoveTriggeredFrag = true;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public bool Loop = false;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public bool ForceTrigger = false;

	[DrawIf("Mode", MANAGER_MODE.SELECT, ComparisonType.Equals)]
	public GameObject mouseSelector;

	public FragSelection fragSelection;
	private FragSelection FragIndexOrderObject;

	public List<Frag> m_fragList = new List<Frag>();
	private List<Frag> m_fragListCopy = new List<Frag>();
	private float TriggerTimer = 0f;

	public GameObject ChasersHolder;

	public enum MANAGER_MODE
	{
		NONE,
		AUTOTRIGGER,
		SELECT
	}


	private void Awake ()
	{
		if (Instance != null && Instance != this)
		{
			Destroy(this);
		}
		else
		{
			Instance = this;
		}

		Init();
	}

	private void Init ()
	{
		foreach (Frag frag in m_fragList)
		{
			frag.Init(Mode,idleColor,activatedColor);
		}

		switch (Mode)
		{
			case MANAGER_MODE.NONE:
				break;
			case MANAGER_MODE.AUTOTRIGGER:
				
				ChasersHolder.SetActive(false);

				foreach (Frag frag in m_fragList)
					m_fragListCopy.Add(frag);

				if (fragSelection != null)
				{
					m_fragListCopy = new();
					for (int index = 0; index < fragSelection.fragList.Count; index++)
					{
						m_fragListCopy.Add(m_fragList[fragSelection.fragList[index]]);
					}
				}
				break;
			case MANAGER_MODE.SELECT:
				FragIndexOrderObject = ScriptableObject.CreateInstance<FragSelection>();
				FragIndexOrderObject.fragList = new List<int>();
				ChasersHolder.SetActive(false);
				break;
		}

		mouseSelector.SetActive(Mode == MANAGER_MODE.SELECT);
	}

	// Update is called once per frame
	void Update ()
	{
		switch (Mode)
		{
			case MANAGER_MODE.NONE:
				break;
			case MANAGER_MODE.AUTOTRIGGER:
				TriggerTimer += Time.deltaTime;
				if (TriggerTimer > TriggerDelay)
				{
					TriggerTimer = 0f;
					for (int i = 0; i < FragTriggered; i++)
					{
						TriggerFrag(fragSelection == null ? Random.Range(0, m_fragListCopy.Count) : 0);
					}
				}
				break;
			case MANAGER_MODE.SELECT:
				break;
		}

	}

	void TriggerFrag ( int index )
	{
		if (m_fragListCopy.Count == 0)
		{
			if (Loop)
			{
				foreach (Frag frag in m_fragList)
					m_fragListCopy.Add(frag);
			}
			return;
		}

		m_fragListCopy[index].TriggerFrag(ForceTrigger);

		if (RemoveTriggeredFrag)
			m_fragListCopy.RemoveAt(index);
	}

	public void AddFragToSelection ( Frag frag )
	{
		if (!FragIndexOrderObject.fragList.Contains(m_fragList.IndexOf(frag)))
		{
			FragIndexOrderObject.fragList.Add(m_fragList.IndexOf(frag));
			frag.SetColor(Color.white);
		}
	}

	public void RemoveFragFromSelection ( Frag frag )
	{
		if (FragIndexOrderObject.fragList.Contains(m_fragList.IndexOf(frag)))
		{
			FragIndexOrderObject.fragList.Remove(m_fragList.IndexOf(frag));
			frag.SetColor(new Color(1, 1, 1, .2f));
		}
	}

	public void ValidateSelection ( string _selectionName )
	{
		if(AssetDatabase.LoadAssetAtPath<FragSelection>("Assets/Indexes/" + _selectionName + ".asset"))
		{
			AssetDatabase.DeleteAsset("Assets/Indexes/" + _selectionName + ".asset");
		}
		AssetDatabase.CreateAsset(FragIndexOrderObject, "Assets/Indexes/" + _selectionName + ".asset");
		EditorUtility.SetDirty(FragIndexOrderObject);
		ResetSelection();
	}

	public bool CheckExistingSelection(string _selectionName)
	{
		return (AssetDatabase.LoadAssetAtPath<FragSelection>("Assets/Indexes/" + _selectionName + ".asset") != null);
	}

	public void MergeSelection(string _selectionName)
	{
		FragSelection old = AssetDatabase.LoadAssetAtPath<FragSelection>("Assets/Indexes/" + _selectionName + ".asset");
		foreach(int index in old.fragList) 
		{
			if(!FragIndexOrderObject.fragList.Contains(index))
				FragIndexOrderObject.fragList.Add(index);
		}
		AssetDatabase.DeleteAsset("Assets/Indexes/" + _selectionName + ".asset");
		AssetDatabase.CreateAsset(FragIndexOrderObject, "Assets/Indexes/" + _selectionName + ".asset");
		EditorUtility.SetDirty(FragIndexOrderObject);
		ResetSelection();
	}

	public void DisplayMerge( string _selectionName )
	{
		FragSelection old = AssetDatabase.LoadAssetAtPath<FragSelection>("Assets/Indexes/" + _selectionName + ".asset");

		foreach (int index in FragIndexOrderObject.fragList)
			m_fragList[index].SetColor(Color.green);

		foreach (int index in old.fragList)
		{
			if (!FragIndexOrderObject.fragList.Contains(index))
				m_fragList[index].SetColor(Color.red);
			else
				m_fragList[index].SetColor(Color.blue);
		}
	}

	public void ResetSelection()
	{
		List<int> savedIndexes = FragIndexOrderObject.fragList;
		FragIndexOrderObject = ScriptableObject.CreateInstance<FragSelection>(); ;
		FragIndexOrderObject.fragList = savedIndexes;

		foreach(Frag frag in m_fragList)
			frag.SetColor(new Color(1, 1, 1, .2f));

		foreach (int index in FragIndexOrderObject.fragList)
			m_fragList[index].SetColor(Color.white);
	}
}
