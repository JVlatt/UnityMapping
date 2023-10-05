using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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

	public bool FadeIn = true;
    public float FadeInDuration = .2f;
    public float Duration = .2f;
    public float FadeOutDuration = .5f;
	public float RetriggerDelay = 1.0f;
	public bool AutoRetrigger = false;
	private float m_timer = .0f;
    private SpriteRenderer m_spriteRenderer;
	private State m_state = State.WAIT;

	private void Awake ()
	{
		m_spriteRenderer = GetComponent<SpriteRenderer>();
		m_spriteRenderer.color = FadeIn ? Color.black : Color.white;
	}

	private void Update ()
	{
		switch (m_state)
		{
			case State.WAIT:
				break;
			case State.IN:
				m_timer += Time.deltaTime;
				m_spriteRenderer.color = Color.Lerp(Color.black, Color.white, Mathf.Clamp01(m_timer / FadeInDuration));
				if(m_timer > FadeInDuration) 
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
				m_spriteRenderer.color = Color.Lerp(Color.white, Color.black, Mathf.Clamp01(m_timer / FadeOutDuration));
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

	public void TriggerFrag()
	{
		m_timer = 0f;
		m_state = FadeIn ? State.IN : State.OUT;
	}

	private void OnTriggerEnter2D ( Collider2D collision )
	{
		if (collision.tag == "Chaser")
			TriggerFrag();
	}

	private void OnTriggerExit2D ( Collider2D collision )
	{
		if (collision.tag == "Chaser")
			TriggerFrag();
	}
}
