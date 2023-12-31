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
		MOVE
	}

	public enum ShapeMode
    {
		SPHERE,
		RECT
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
	private FragIndexOrder FragIndexOrderObject;
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
                m_circleCollider.radius = Grow ? MinMaxRadius.x : MinMaxRadius.y;
                break;
			case ShapeMode.RECT:
				m_boxCollider = GetComponent<BoxCollider2D>();
				if(movementMode == MovementMode.GROW)
                {
					m_boxCollider.size = Grow ? RectStart : RectTarget;
					ActiveRectDelta = Grow ? 0f : 1f;
                }
				if(movementMode == MovementMode.MOVE)
                {
					RectStart = transform.position;
					RectTarget += RectStart;
                }
                break;
        }
		if (triggerMode == TriggerMode.REGISTER)
		{
			FragIndexOrderObject = ScriptableObject.CreateInstance<FragIndexOrder>();
			FragIndexOrderObject.fragList = new List<int>();
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
						if (ActiveRadius > MinMaxRadius.y)
						{
							if (triggerMode == TriggerMode.REGISTER)
							{
								AssetDatabase.CreateAsset(FragIndexOrderObject, "Assets/Indexes/Index" + (AssetDatabase.FindAssets("Index", new[] { "Assets/Indexes" }).Count() + 1) + ".asset");
								EditorUtility.SetDirty(FragIndexOrderObject);
							}
						}
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
						if(Vector2.Distance(transform.position, RectStart) <= .05f || Vector2.Distance(transform.position, RectTarget) <= .05f)
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
        }
		

	}

	private void OnTriggerEnter2D ( Collider2D collision )
	{
		if (triggerMode == TriggerMode.REGISTER)
		{
			Frag frag = collision.transform.GetComponent<Frag>();

			if (frag != null && !FragIndexOrderObject.fragList.Contains(FragManager.m_fragList.IndexOf(frag)))
				FragIndexOrderObject.fragList.Add(FragManager.m_fragList.IndexOf(frag));
		}
	}

	private void OnDestroy ()
	{
		
	}

}
