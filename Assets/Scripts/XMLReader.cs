using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Xml;
using System.IO;
using UnityEditor.SceneManagement;
using UnityEngine.Device;
using UnityEditor;
using System;

[ExecuteInEditMode]
public class XMLReader : MonoBehaviour
{
	public TextAsset fileToRead;
	public bool screenSized = false;
	private XmlDocument xmlDocument;
	public Material baseMaterial;
	public bool overrideExisting = true;
	public float extrusionDepth = 1.0f;


	public void LoadScreens ()
	{
		Debug.Log("Loading Screens");

		xmlDocument = new XmlDocument();
		xmlDocument.LoadXml(fileToRead.text);
		XmlNode root = xmlDocument.DocumentElement;
		root = root.SelectSingleNode("ScreenSetup/screens");
		XmlNodeList items = root.SelectNodes("Screen");

		Debug.Log("Screens found : " + items.Count);

		if (items.Count > 0)
		{
			GameObject parent = new GameObject(fileToRead.name);
			Transform fragManagerTransform = FindObjectOfType<FragManager>().transform;
			if (overrideExisting && fragManagerTransform.Find(fileToRead.name) != null)
			{
				DestroyImmediate(fragManagerTransform.Find(fileToRead.name).gameObject);
			}
			parent.transform.parent = FindObjectOfType<FragManager>().transform;

			if (Directory.Exists("Assets/GeneratedMeshes/" + fileToRead.name))
			{
				Directory.Delete("Assets/GeneratedMeshes/" + fileToRead.name, true);
			}
			Directory.CreateDirectory("Assets/GeneratedMeshes/" + fileToRead.name);

			foreach (XmlNode node in items)
			{
				XmlNodeList polygons = node.SelectNodes("layers/Polygon");

				if (polygons.Count > 0)
				{
					int polyIndex = 0;
					GameObject screenGO = new GameObject(node.Attributes["name"].Value);
					screenGO.transform.parent = parent.transform;
					if (!Directory.Exists("Assets/GeneratedMeshes/" + fileToRead.name + "/" + node.Attributes["name"].Value))
					{
						Directory.CreateDirectory("Assets/GeneratedMeshes/" + fileToRead.name + "/" + node.Attributes["name"].Value);
					}
					foreach (XmlNode polygon in polygons)
					{
						GameObject polyGO = new GameObject(polygon.FirstChild.FirstChild.Attributes["value"].Value);
						polyGO.transform.parent = screenGO.transform;


						XmlNodeList vertices = polygon.SelectNodes("InputContour/points/v");


						Vector2[] points = new Vector2[vertices.Count];

						for (int i = 0; i < vertices.Count; i++)
						{
							Vector2 vertex = new Vector2(float.Parse(vertices[i].Attributes["x"].Value, System.Globalization.CultureInfo.InvariantCulture), 1080 - float.Parse(vertices[i].Attributes["y"].Value, System.Globalization.CultureInfo.InvariantCulture));
							points[i] = screenSized ? vertex : Camera.main.ScreenToWorldPoint(vertex);
						}

						Vector3 center = CalculateBoundingBoxCenter(points);

						Vector2[] sortedPoints = SortPointsClockwise(points);

						MeshFilter meshfilter = polyGO.AddComponent<MeshFilter>();
						polyGO.transform.position = center;

						Mesh mesh = Generate3DMesh(AdjustPointsToBoundingBoxCenter(sortedPoints, center), extrusionDepth);
						InvertNormals(mesh);

						AssetDatabase.CreateAsset(mesh, "Assets/GeneratedMeshes/" + fileToRead.name + "/" + node.Attributes["name"].Value + "/GeneratedMesh_" + polyIndex.ToString() + ".asset");

						meshfilter.mesh = mesh;
						Frag frag = polyGO.AddComponent<Frag>();

						polyGO.GetComponent<MeshRenderer>().material = baseMaterial;


						polyIndex++;
					}

				}
			}

			AssetDatabase.SaveAssets();
			parent.SetActive(false);
		}

	}

	Vector2 CalculateBoundingBoxCenter ( Vector2[] points )
	{
		float minX = float.MaxValue;
		float minY = float.MaxValue;
		float maxX = float.MinValue;
		float maxY = float.MinValue;

		foreach (Vector2 point in points)
		{
			if (point.x < minX) minX = point.x;
			if (point.y < minY) minY = point.y;
			if (point.x > maxX) maxX = point.x;
			if (point.y > maxY) maxY = point.y;
		}

		float centerX = (minX + maxX) / 2;
		float centerY = (minY + maxY) / 2;

		return new Vector2(centerX, centerY);
	}

	Vector2[] AdjustPointsToBoundingBoxCenter ( Vector2[] points, Vector2 boundingBoxCenter )
	{
		Vector2[] adjustedPoints = new Vector2[points.Length];
		for (int i = 0; i < points.Length; i++)
		{
			adjustedPoints[i] = points[i] - boundingBoxCenter;
		}
		return adjustedPoints;
	}

	public Mesh Generate3DMesh ( Vector2[] points, float depth )
	{
		Triangulator triangulator = new Triangulator(points);
		int[] tris = triangulator.Triangulate();
		Mesh m = new Mesh();
		Vector3[] vertices = new Vector3[points.Length * 2];

		for (int i = 0; i < points.Length; i++)
		{
			vertices[i].x = points[i].x;
			vertices[i].y = points[i].y;
			vertices[i].z = 0; // front vertex
			vertices[i + points.Length].x = points[i].x;
			vertices[i + points.Length].y = points[i].y;
			vertices[i + points.Length].z = -depth;  // back vertex    
		}
		int[] triangles = new int[tris.Length * 2 + points.Length * 6];
		int count_tris = 0;
		for (int i = 0; i < tris.Length; i += 3)
		{
			triangles[i] = tris[i];
			triangles[i + 1] = tris[i + 1];
			triangles[i + 2] = tris[i + 2];
		} // front vertices
		count_tris += tris.Length;
		for (int i = 0; i < tris.Length; i += 3)
		{
			triangles[count_tris + i] = tris[i + 2] + points.Length;
			triangles[count_tris + i + 1] = tris[i + 1] + points.Length;
			triangles[count_tris + i + 2] = tris[i] + points.Length;
		} // back vertices
		count_tris += tris.Length;
		for (int i = 0; i < points.Length; i++)
		{
			int n = (i + 1) % points.Length;
			triangles[count_tris] = n;
			triangles[count_tris + 1] = i + points.Length;
			triangles[count_tris + 2] = i;
			triangles[count_tris + 3] = n;
			triangles[count_tris + 4] = n + points.Length;
			triangles[count_tris + 5] = i + points.Length;
			count_tris += 6;
		}
		m.vertices = vertices;
		m.triangles = triangles;
		m.RecalculateNormals();
		m.RecalculateBounds();
		m.Optimize();
		return m;
	}
	public void InvertNormals ( Mesh mesh )
	{
		// Get the mesh triangles
		int[] triangles = mesh.triangles;

		// Reverse the winding order of triangles
		for (int i = 0; i < triangles.Length; i += 3)
		{
			int temp = triangles[i];
			triangles[i] = triangles[i + 1];
			triangles[i + 1] = temp;
		}

		// Assign the inverted triangles back to the mesh
		mesh.triangles = triangles;

		// Recalculate normals to reflect the changes
		mesh.RecalculateNormals();
	}

	public Vector2[] SortPointsClockwise ( Vector2[] points )
	{
		// Calculate the centroid of the points
		Vector2 centroid = CalculateCentroid(points);

		// Calculate the angles of each point relative to the centroid
		float[] angles = new float[points.Length];
		for (int i = 0; i < points.Length; i++)
		{
			angles[i] = Mathf.Atan2(points[i].y - centroid.y, points[i].x - centroid.x);
		}

		// Sort the points based on their angles
		Array.Sort(angles, points);

		return points;
	}

	private Vector2 CalculateCentroid ( Vector2[] points )
	{
		float totalX = 0f;
		float totalY = 0f;

		foreach (Vector2 point in points)
		{
			totalX += point.x;
			totalY += point.y;
		}

		float centroidX = totalX / points.Length;
		float centroidY = totalY / points.Length;

		return new Vector2(centroidX, centroidY);
	}
}

public class Triangulator
{
	private List<Vector2> m_points = new List<Vector2>();

	public Triangulator ( Vector2[] points )
	{
		m_points = new List<Vector2>(points);
	}

	public int[] Triangulate ()
	{
		List<int> indices = new List<int>();

		int n = m_points.Count;
		if (n < 3)
			return indices.ToArray();

		int[] V = new int[n];
		if (Area() > 0)
		{
			for (int v = 0; v < n; v++)
				V[v] = v;
		}
		else
		{
			for (int v = 0; v < n; v++)
				V[v] = (n - 1) - v;
		}

		int nv = n;
		int count = 2 * nv;
		for (int m = 0, v = nv - 1; nv > 2;)
		{
			if ((count--) <= 0)
				return indices.ToArray();

			int u = v;
			if (nv <= u)
				u = 0;
			v = u + 1;
			if (nv <= v)
				v = 0;
			int w = v + 1;
			if (nv <= w)
				w = 0;

			if (Snip(u, v, w, nv, V))
			{
				int a, b, c, s, t;
				a = V[u];
				b = V[v];
				c = V[w];
				indices.Add(a);
				indices.Add(b);
				indices.Add(c);
				m++;
				for (s = v, t = v + 1; t < nv; s++, t++)
					V[s] = V[t];
				nv--;
				count = 2 * nv;
			}
		}

		indices.Reverse();
		return indices.ToArray();
	}

	private float Area ()
	{
		int n = m_points.Count;
		float A = 0.0f;
		for (int p = n - 1, q = 0; q < n; p = q++)
		{
			Vector2 pval = m_points[p];
			Vector2 qval = m_points[q];
			A += pval.x * qval.y - qval.x * pval.y;
		}
		return (A * 0.5f);
	}

	private bool Snip ( int u, int v, int w, int n, int[] V )
	{
		int p;
		Vector2 A = m_points[V[u]];
		Vector2 B = m_points[V[v]];
		Vector2 C = m_points[V[w]];
		if (Mathf.Epsilon > (((B.x - A.x) * (C.y - A.y)) - ((B.y - A.y) * (C.x - A.x))))
			return false;
		for (p = 0; p < n; p++)
		{
			if ((p == u) || (p == v) || (p == w))
				continue;
			Vector2 P = m_points[V[p]];
			if (InsideTriangle(A, B, C, P))
				return false;
		}
		return true;
	}

	private bool InsideTriangle ( Vector2 A, Vector2 B, Vector2 C, Vector2 P )
	{
		float ax, ay, bx, by, cx, cy, apx, apy, bpx, bpy, cpx, cpy;
		float cCROSSap, bCROSScp, aCROSSbp;

		ax = C.x - B.x; ay = C.y - B.y;
		bx = A.x - C.x; by = A.y - C.y;
		cx = B.x - A.x; cy = B.y - A.y;
		apx = P.x - A.x; apy = P.y - A.y;
		bpx = P.x - B.x; bpy = P.y - B.y;
		cpx = P.x - C.x; cpy = P.y - C.y;

		aCROSSbp = ax * bpy - ay * bpx;
		cCROSSap = cx * apy - cy * apx;
		bCROSScp = bx * cpy - by * cpx;

		return ((aCROSSbp >= 0.0f) && (bCROSScp >= 0.0f) && (cCROSSap >= 0.0f));
	}

	
}

