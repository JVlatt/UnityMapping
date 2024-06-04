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
	public Vector2 TriggerDelayMinMax = new Vector2(.1f,1f);
	private float TriggerDelay = 0f;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public Vector2 FragTriggeredMinMax = new Vector2(1, 10);
	private int FragTriggered = 0;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public bool RemoveTriggeredFrag = true;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public bool Loop = false;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public bool ForceTrigger = false;
	[DrawIf("Mode", MANAGER_MODE.AUTOTRIGGER, ComparisonType.Equals)]
	public bool RandomSettings = false;
	[DrawIf("RandomSettings", true, ComparisonType.Equals)]
	public Vector2 FadeInTimeMinMax = new Vector2(.1f, 2f);
	[DrawIf("RandomSettings", true, ComparisonType.Equals)]
	public Vector2 ActiveTimeMinMax = new Vector2(.1f, 2f);
	[DrawIf("RandomSettings", true, ComparisonType.Equals)]
	public Vector2 FadeOutTimeMinMax = new Vector2(.1f, 2f);

	[DrawIf("Mode", MANAGER_MODE.SELECT, ComparisonType.Equals)]
	public GameObject mouseSelector;

	public FragSelection fragSelection;
	private FragSelection FragIndexOrderObject;

	public List<Frag> activeFragList = new List<Frag>();
	[HideInInspector]
	public List<Frag> layoutFragList = new List<Frag>();

	private List<Frag> m_fragListCopy = new List<Frag>();
	private float TriggerTimer = 0f;

	public GameObject ChasersHolder;

	public enum MANAGER_MODE
	{
		NONE,
		CHASER,
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
		

		switch (Mode)
		{
			case MANAGER_MODE.NONE:
				break;
			case MANAGER_MODE.CHASER:
				break;
			case MANAGER_MODE.AUTOTRIGGER:
				
				ChasersHolder.SetActive(false);

				foreach (Frag frag in activeFragList)
					m_fragListCopy.Add(frag);

				if (fragSelection != null)
				{
					m_fragListCopy = new();
					for (int index = 0; index < fragSelection.fragList.Count; index++)
					{
						m_fragListCopy.Add(layoutFragList[fragSelection.fragList[index]]);
					}
				}

				FragTriggered = (int)Random.Range(FragTriggeredMinMax.x, FragTriggeredMinMax.y);
				TriggerDelay = Random.Range(TriggerDelayMinMax.x, TriggerDelayMinMax.y);

				break;
			
			case MANAGER_MODE.SELECT:
				FragIndexOrderObject = ScriptableObject.CreateInstance<FragSelection>();
				FragIndexOrderObject.fragList = new List<int>();
				ChasersHolder.SetActive(false);
				break;
		}

		mouseSelector.SetActive(Mode == MANAGER_MODE.SELECT);

		foreach (Frag frag in layoutFragList)
		{
			if(frag.gameObject.activeSelf)
				frag.Init(Mode, idleColor, activatedColor);
		}
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
						TriggerFrag(Random.Range(0, m_fragListCopy.Count));
					}
					FragTriggered = (int)Random.Range(FragTriggeredMinMax.x, FragTriggeredMinMax.y);
					TriggerDelay = Random.Range(TriggerDelayMinMax.x, TriggerDelayMinMax.y);
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
				foreach (Frag frag in activeFragList)
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
		if (!FragIndexOrderObject.fragList.Contains(layoutFragList.IndexOf(frag)))
		{
			FragIndexOrderObject.fragList.Add(layoutFragList.IndexOf(frag));
			frag.SetColor(Color.green);
		}
	}

	public void RemoveFragFromSelection ( Frag frag )
	{
		if (FragIndexOrderObject.fragList.Contains(layoutFragList.IndexOf(frag)))
		{
			FragIndexOrderObject.fragList.Remove(layoutFragList.IndexOf(frag));
			frag.SetColor(Color.white);
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
			layoutFragList[index].SetColor(Color.green);

		foreach (int index in old.fragList)
		{
			if (!FragIndexOrderObject.fragList.Contains(index))
				layoutFragList[index].SetColor(Color.red);
			else
				layoutFragList[index].SetColor(Color.blue);
		}
	}

	public void ResetSelection()
	{
		List<int> savedIndexes = FragIndexOrderObject.fragList;
		FragIndexOrderObject = ScriptableObject.CreateInstance<FragSelection>(); ;
		FragIndexOrderObject.fragList = savedIndexes;

		foreach(Frag frag in layoutFragList)
		{
			if(frag.gameObject.activeSelf)
				frag.SetColor(new Color(1, 1, 1, .2f));
		}

		foreach (int index in FragIndexOrderObject.fragList)
			layoutFragList[index].SetColor(Color.white);
	}
}
