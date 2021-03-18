using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class AlphaTestMat : MonoBehaviour
{
    public Material AlphaTest;

    public Slider AdjustCullOffSlider;
    public Text sliderTip;


    private void Start()
    {
        Vector2 screenPos = Camera.main.WorldToScreenPoint(transform.position);
        AdjustCullOffSlider.GetComponent<RectTransform>().anchoredPosition = new Vector2(screenPos.x, screenPos.y - 220);

        SetParam(0.5f);
        AdjustCullOffSlider.value = 0.5f;
        AdjustCullOffSlider.onValueChanged.AddListener(delegate(float value)
        {
            SetParam(value);
        });
    }

    private void SetParam(float cullOff)
    {
        float v = (float)Math.Round(cullOff, 2);
        AlphaTest.SetFloat("_Culloff", v);
        sliderTip.text = $"如果贴图区域Alpha小于{v}则剔除";
    }
}
