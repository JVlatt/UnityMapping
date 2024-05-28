using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;

public class Chaser : MonoBehaviour
{
	public enum TriggerMode
	{
		TRIGGER,
		REGISTER
	}

	public enum MovementMode
	{
		GROW,
		SPIRAL,
		MOVE,
		NONE
	}

	public enum ShapeMode
    {
		SPHERE,
		RECT,
		COMPLEX
    }

	public TriggerMode triggerMode = TriggerMode.TRIGGER;
	public MovementMode movementMode = MovementMode.GROW;
	public ShapeMode shapeMode = ShapeMode.SPHERE;

	public float startDelay = 0f;

	public float GrowSpeed = 1.0f;
	public Vector2 MinMaxRadius = new Vector2(0, 1);
	private CircleCollider2D m_circleCollider;
	private BoxCollider2D m_boxCollider;
	public float SleepTime = .2f;
	private float SleepTimer = 0f;

	public bool Grow = true;
	public bool Bounce = false;
	public bool OneShot = false;

	public float RotationSpeed = 1.0f;
	public float RadiusSpeed = 1.0f;

	public Vector2 RectStart = new Vector2(-1,-1);
    public Vector2 RectTarget = Vector2.zero;
	public float RectSpeed = 1f;

	private float ActiveRectDelta = 0f;

    private float ActiveRadius = 0.0f;
	private float ActiveAngle = 0.0f;
	private Vector3 Center = Vector3.zero;
	private bool isInit = false;
	[SerializeField]
	private FragManager FragManager;
	private void Awake ()
	{
		Center = transform.position;
		switch(shapeMode)
        {
			case ShapeMode.SPHERE:
                m_circleCollider = GetComponent<CircleCollider2D>();
				
				if(movementMode != MovementMode.NONE)
					m_circleCollider.radius = Grow ? MinMaxRadius.x : MinMaxRadius.y;
                
				break;
			case ShapeMode.RECT:
				m_boxCollider = GetComponent<BoxCollider2D>();
				switch (movementMode)
				{
					case MovementMode.GROW:
					m_boxCollider.size = Grow ? RectStart : RectTarget;
					ActiveRectDelta = Grow ? 0f : 1f;
						break;
					case MovementMode.SPIRAL:
						break;
					case MovementMode.MOVE:
					RectStart = transform.position;
					RectTarget += RectStart;
						break;
					case MovementMode.NONE:
						break;
				}
				break;
			case ShapeMode.COMPLEX:
				transform.localScale = Grow ? Vector3.one * MinMaxRadius.x : Vector3.one * MinMaxRadius.y;
				break;
        }
		StartCoroutine(StartDelayCR(startDelay));
	}

	private IEnumerator StartDelayCR(float _delay)
    {
		yield return new WaitForSeconds(_delay);
		isInit = true;
    }

	private void Update ()
	{
		if (!isInit)
			return;
		if (movementMode != MovementMode.NONE)
			UpdateShape();
	}

	private void UpdateShape()
	{
		switch (shapeMode)
		{
			case ShapeMode.SPHERE:
				switch (movementMode)
				{
					case MovementMode.GROW:
						m_circleCollider.radius = Mathf.Clamp(m_circleCollider.radius + GrowSpeed * Time.deltaTime * (Grow ? 1f : -1f), MinMaxRadius.x, MinMaxRadius.y);
						if (m_circleCollider.radius <= MinMaxRadius.x || m_circleCollider.radius >= MinMaxRadius.y)
						{
							SleepTimer += Time.deltaTime;
							if (SleepTimer >= SleepTime)
							{
								if (Bounce)
								{
									SleepTimer = 0f;
									Grow = !Grow;
								}
								else if (!OneShot)
								{
									SleepTimer = 0f;
									m_circleCollider.radius = MinMaxRadius.x;
								}
							}
						}
						break;
					case MovementMode.SPIRAL:
						ActiveRadius += RadiusSpeed * Time.deltaTime;
						ActiveAngle += RotationSpeed * Time.deltaTime;
						transform.position = Center + new Vector3(ActiveRadius * Mathf.Cos(ActiveAngle), ActiveRadius * Mathf.Sin(ActiveAngle));
						break;
				}
				break;
			case ShapeMode.RECT:
				switch (movementMode)
				{
					case MovementMode.GROW:
						ActiveRectDelta = Mathf.Clamp01(ActiveRectDelta + Time.deltaTime * RectSpeed * (Grow ? 1 : -1));
						m_boxCollider.size = Vector2.Lerp(RectStart, RectTarget, ActiveRectDelta);
						if (ActiveRectDelta == 0f || ActiveRectDelta == 1f)
						{
							SleepTimer += Time.deltaTime;
							if (SleepTimer >= SleepTime)
							{
								if (Bounce)
								{
									SleepTimer = 0f;
									Grow = !Grow;
								}
								else if (!OneShot)
								{
									SleepTimer = 0f;
									m_boxCollider.size = Grow ? RectStart : RectTarget;
								}
							}
						}
						break;
					case MovementMode.SPIRAL:
						break;
					case MovementMode.MOVE:
						ActiveRectDelta = Mathf.Clamp01(ActiveRectDelta + Time.deltaTime * RectSpeed * (Grow ? 1 : -1));
						transform.position = Vector3.Lerp(RectStart, RectTarget, ActiveRectDelta);
						if (ActiveRectDelta == 0f || ActiveRectDelta == 1f)
						{
							SleepTimer += Time.deltaTime;
							if (SleepTimer >= SleepTime)
							{
								if (Bounce)
								{
									SleepTimer = 0f;
									Grow = !Grow;
								}
								else if (!OneShot)
								{
									SleepTimer = 0f;
									ActiveRectDelta = 0f;
									transform.position = RectStart;
								}
							}
						}
						break;
				}

				break;

			case ShapeMode.COMPLEX:
				switch (movementMode)
				{
					case MovementMode.GROW:
						transform.localScale = Vector3.one * Mathf.Clamp(transform.localScale.x + GrowSpeed * Time.deltaTime * (Grow ? 1f : -1f), MinMaxRadius.x, MinMaxRadius.y);
						if (transform.localScale.x <= MinMaxRadius.x || transform.localScale.x >= MinMaxRadius.y)
						{
							SleepTimer += Time.deltaTime;
							if (SleepTimer >= SleepTime)
							{
								if (Bounce)
								{
									SleepTimer = 0f;
									Grow = !Grow;
								}
								else if (!OneShot)
								{
									SleepTimer = 0f;
									transform.localScale = Vector3.one * MinMaxRadius.x;
								}
							}
						}
						break;
					case MovementMode.SPIRAL:
						break;
					case MovementMode.MOVE:
						break;

				}
				break;
		}
	}

	private void OnDestroy ()
	{
		
	}

}
