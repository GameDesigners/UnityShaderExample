using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class AlphaBlendMat : MonoBehaviour
{
    public Material AlphaBlend;

    public Slider AdjustAlphaScaleSlider;
    public Text sliderTip;


    private void Start()
    {
        Vector2 screenPos = Camera.main.WorldToScreenPoint(transform.position);
        AdjustAlphaScaleSlider.GetComponent<RectTransform>().anchoredPosition = new Vector2(screenPos.x, screenPos.y - 220);

        SetParam(0.5f);
        AdjustAlphaScaleSlider.value = 0.5f;
        AdjustAlphaScaleSlider.onValueChanged.AddListener(delegate (float value)
        {
            SetParam(value);
        });
    }

    private void SetParam(float cullOff)
    {
        float v = (float)Math.Round(cullOff, 2);
        AlphaBlend.SetFloat("_AlphaScale", v);
        sliderTip.text = $"AlphaScale={v}";
    }
}
