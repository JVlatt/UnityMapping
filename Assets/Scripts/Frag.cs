using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class Frag : MonoBehaviour
{

	private enum State
	{
		WAIT,
		IN,
		ON,
		OUT,
		OFF
	}

	public string ChaserTag = "Chaser";

	public bool ForceTriggerEnter = false;
	public bool ForceTriggerExit = false;
	public bool ShouldTriggerEnter = true;
	public bool ShouldTriggerExit = false;
	public bool FadeIn = true;
	public float FadeInDuration = .001f;
	public float Duration = .5f;
	public float FadeOutDuration = .001f;
	public float RetriggerDelay = .01f;
	public bool AutoRetrigger = false;
	
	private float m_timer = .0f;
	private Material m_material;
	private State m_state = State.WAIT;
	private Color m_activeColor;
	private Color m_idleColor;
	private Color m_activatedColor;

	private void Awake ()
	{
	}

	public void Init ( FragManager.MANAGER_MODE _mode, Color _baseColor, Color _activeColor )
	{
		GetComponent<MeshFilter>().mesh = GetComponent<PolygonCollider2D>().CreateMesh(false,false);
		m_material = GetComponent<MeshRenderer>().material;
		m_activatedColor = _activeColor;
		m_idleColor = _baseColor;
		m_activeColor = FadeIn ? m_idleColor : m_activatedColor;
		
		m_material.SetColor("_Color", m_activeColor);
	}

	private void Update ()
	{
		switch (m_state)
		{
			case State.WAIT:
				break;
			case State.IN:
				m_timer += Time.deltaTime;
				m_activeColor = Color.Lerp(m_idleColor, m_activatedColor,Mathf.Clamp01(m_timer / FadeInDuration));
				m_material.SetColor("_Color", m_activeColor);
				if (m_timer > FadeInDuration)
				{
					m_timer = 0f;
					m_state = State.ON;
				}
				break;
			case State.ON:
				m_timer += Time.deltaTime;
				if (m_timer > Duration)
				{
					m_timer = 0f;
					m_state = State.OUT;
				}
				break;
			case State.OUT:
				m_timer += Time.deltaTime;
				m_activeColor = Color.Lerp(m_activatedColor, m_idleColor, Mathf.Clamp01(m_timer / FadeOutDuration));
				m_material.SetColor("_Color", m_activeColor);
				if (m_timer > FadeOutDuration)
				{
					m_timer = 0f;
					m_state = State.OFF;
				}
				break;
			case State.OFF:
				m_timer += Time.deltaTime;
				if (m_timer > RetriggerDelay)
				{
					m_timer = 0f;
					m_state = AutoRetrigger ? State.IN : State.WAIT;
				}
				break;
		}

	}

	public void TriggerFrag ( bool forceTrigger )
	{
		if (forceTrigger)
		{
			m_timer = 0f;
			m_state = FadeIn ? State.IN : State.OUT;
		}
		else if (m_state == State.WAIT)
		{
			m_timer = 0f;
			m_state = FadeIn ? State.IN : State.OUT;
		}
	}

	private void OnTriggerEnter2D ( Collider2D collision )
	{
		if (!ShouldTriggerEnter)
			return;

		if (collision.tag == ChaserTag)
			TriggerFrag(ForceTriggerEnter);
	}

	private void OnTriggerExit2D ( Collider2D collision )
	{
		if (!ShouldTriggerExit)
			return;

		if (collision.tag == ChaserTag)
			TriggerFrag(ForceTriggerExit);
	}

	public void SetColor( Color color )
	{
		m_material.SetColor("_Color", color);
	}
}
