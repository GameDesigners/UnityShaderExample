using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class CustomShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        base.OnGUI(materialEditor, properties);

        Material targetMat = materialEditor.target as Material;

        bool redify = Array.IndexOf(targetMat.shaderKeywords, "SPECULAR_ON") != -1;
        EditorGUI.BeginChangeCheck();
        redify = EditorGUILayout.Toggle("Specular On", redify);
        if(EditorGUI.EndChangeCheck())
        {
            if (redify)
                targetMat.EnableKeyword("SPECULAR_ON");
            else
                targetMat.DisableKeyword("SPECULAR_ON");
        }
    }
}
