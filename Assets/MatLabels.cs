using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class MatLabels : MonoBehaviour
{
    [Serializable]
    public class ObjectTag
    {
        public GameObject go;
        public Text tag;
    }

    public List<ObjectTag> objectTags;


    void Start()
    {
        Vector3 screenPos;        
        foreach (ObjectTag o in objectTags)
        {
            screenPos = Camera.main.WorldToScreenPoint(o.go.transform.position);
            o.tag.text = o.go.name;
            o.tag.GetComponent<RectTransform>().anchoredPosition = new Vector2(screenPos.x, screenPos.y + 180);
        }
    }
}
