using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class FragManager : MonoBehaviour
{
	public float TriggerDelay = .1f;
	public int FragTriggered = 1;
	public bool RemoveTriggeredFrag = true;
	public bool Loop = false;
	public bool ForceTrigger = false;
	public FragIndexOrder fragIndexOrder;

	public List<Frag> m_fragList = new List<Frag>();
	private List<Frag> m_fragListCopy = new List<Frag>();
	private float TriggerTimer = 0f;

	private void Awake ()
	{
		foreach (Frag frag in m_fragList)
			m_fragListCopy.Add(frag);

		if(fragIndexOrder != null ) 
		{
			m_fragListCopy = new();
			for (int index = 0; index < fragIndexOrder.fragList.Count; index++)
			{
				m_fragListCopy.Add(m_fragList[fragIndexOrder.fragList[index]]);
			}
		}
	}
	// Update is called once per frame
	void Update ()
	{
		TriggerTimer += Time.deltaTime;
		if (TriggerTimer > TriggerDelay)
		{
			TriggerTimer = 0f;
			for(int i  = 0; i < FragTriggered; i++) 
			{
				TriggerFrag(fragIndexOrder == null ? Random.Range(0, m_fragListCopy.Count) : 0);
			}
		}
	}

	void TriggerFrag (int index)
	{
		if (m_fragListCopy.Count == 0)
        {
			if(Loop)
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

}
