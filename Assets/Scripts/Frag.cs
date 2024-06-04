using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class Frag : MonoBehaviour
{
	public enum ActivationMode
	{
		COLOR,
		MOVE
	}

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
	public bool shouldFadeIn = true;
	public float FadeInDuration = .001f;
	public float Duration = .5f;
	public float FadeOutDuration = .001f;
	public float RetriggerDelay = .01f;
	public bool AutoRetrigger = false;

	public ActivationMode activationMode = ActivationMode.COLOR;

	private float m_timer = .0f;
	private Material m_material;
	private State m_state = State.WAIT;
	private Color m_activeColor;
	private Color m_idleColor;
	private Color m_activatedColor;

	[DrawIf("activationMode", ActivationMode.MOVE, ComparisonType.Equals)]
	public Vector3 targetOffsetPosition = Vector3.zero;
	private Vector3 m_startPosition;
	private Vector3 m_endPosition;
	private Vector3 m_activePosition;

	private void Awake ()
	{
	}

	public void Init ( FragManager.MANAGER_MODE _mode, Color _baseColor, Color _activeColor )
	{
		m_material = GetComponent<MeshRenderer>().material;
		m_activatedColor = _activeColor;
		m_idleColor = _baseColor;
		m_activeColor = shouldFadeIn ? m_idleColor : m_activatedColor;

		m_material.SetColor("_Color", m_activeColor);

		m_startPosition = transform.position;
		m_endPosition = transform.position + targetOffsetPosition;
		m_activePosition = shouldFadeIn ? m_startPosition : m_endPosition;

	}

	private void Update ()
	{
		switch (m_state)
		{
			case State.WAIT:
				break;
			case State.IN:
				m_timer += Time.deltaTime;
				FadeIn();
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
				FadeOut();
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

	public void FadeIn ()
	{
		switch (activationMode)
		{
			case ActivationMode.COLOR:
				m_activeColor = Color.Lerp(m_idleColor, m_activatedColor, Mathf.Clamp01(m_timer / FadeInDuration));
				m_material.SetColor("_Color", m_activeColor);
				break;
			case ActivationMode.MOVE:
				m_activePosition = Vector3.Lerp(m_startPosition, m_endPosition, Mathf.Clamp01(m_timer / FadeInDuration));
				transform.position = m_activePosition;
				break;
			default:
				break;
		}
	}
	public void FadeOut ()
	{
		switch (activationMode)
		{
			case ActivationMode.COLOR:
				m_activeColor = Color.Lerp(m_activatedColor, m_idleColor, Mathf.Clamp01(m_timer / FadeOutDuration));
				m_material.SetColor("_Color", m_activeColor);
				break;
			case ActivationMode.MOVE:
				m_activePosition = Vector3.Lerp(m_endPosition, m_startPosition, Mathf.Clamp01(m_timer / FadeOutDuration));
				transform.position = m_activePosition;
				break;
			default:
				break;
		}
	}
	public void TriggerFrag ( bool forceTrigger )
	{
		if (forceTrigger)
		{
			m_timer = 0f;
			m_state = shouldFadeIn ? State.IN : State.OUT;
		}
		else if (m_state == State.WAIT)
		{
			m_timer = 0f;
			m_state = shouldFadeIn ? State.IN : State.OUT;
		}
	}

	private void OnTriggerEnter ( Collider other )
	{
		if (!ShouldTriggerEnter)
			return;

		if (other.tag == ChaserTag)
			TriggerFrag(ForceTriggerEnter);
	}
	private void OnTriggerExit ( Collider other )
	{
		if (!ShouldTriggerExit)
			return;

		if (other.tag == ChaserTag)
			TriggerFrag(ForceTriggerExit);
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

	public void SetColor ( Color color )
	{
		m_material.SetColor("_Color", color);
	}
}
