using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[ExecuteInEditMode]
public class RampMat : MonoBehaviour
{
    public Material RampTextureMat;
    public List<Texture> RampTexs;

    public Button ChangeTexBtn;

    private int currentIndex = 0;

    private void Start()
    {
        Vector2 screenPos = Camera.main.WorldToScreenPoint(transform.position);
        ChangeTexBtn.GetComponent<RectTransform>().anchoredPosition = new Vector2(screenPos.x, screenPos.y - 180);

        ChangeTexBtn.onClick.AddListener(delegate ()
        {
            currentIndex = currentIndex + 1 <= RampTexs.Count - 1 ? currentIndex + 1 : 0;
            RampTextureMat.SetTexture("_RampTex", RampTexs[currentIndex]);
        });
    }
}
