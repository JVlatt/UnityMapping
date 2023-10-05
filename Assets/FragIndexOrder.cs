using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/FragIndexOrder", order = 1)]
public class FragIndexOrder : ScriptableObject
{
    public List<int> fragList;
}
