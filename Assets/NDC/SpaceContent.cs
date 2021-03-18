using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SpaceContent : MonoBehaviour
{

    private void OnGUI()
    {
        GUI.Label(new Rect(20, 0, 1000, 150), $"worldToLocalMatrix : \n{transform.worldToLocalMatrix}");
        GUI.Label(new Rect(20, 150, 1000, 300), $"localToWorldMatrix : \n{transform.localToWorldMatrix}");

        GUI.Label(new Rect(20, 300, 1000, 450), $"cameraToWorldMatrix [Main Camera] : \n{Camera.main.cameraToWorldMatrix}");
        GUI.Label(new Rect(20, 450, 1000, 600), $"worldToCameraMatrix [Main Camera]] : \n{Camera.main.worldToCameraMatrix}");

        GUI.Label(new Rect(20, 600, 1000, 750), $"projectionMatrix [Main Camera]] : \n{Camera.main.projectionMatrix}");
    }
}
