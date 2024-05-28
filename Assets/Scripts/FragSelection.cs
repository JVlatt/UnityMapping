using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/FragIndexOrder", order = 1)]
public class FragSelection : ScriptableObject
{
    public List<int> fragList;
}
