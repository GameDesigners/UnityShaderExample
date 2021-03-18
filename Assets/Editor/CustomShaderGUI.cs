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

        bool redify = Array.IndexOf(targetMat.shaderKeywords, "REDIFY_ON") != -1;
        EditorGUI.BeginChangeCheck();
        redify = EditorGUILayout.Toggle("Redify material", redify);
        if(EditorGUI.EndChangeCheck())
        {
            if (redify)
                targetMat.EnableKeyword("REDIFY_ON");
            else
                targetMat.DisableKeyword("REDIFY_ON");
        }
    }
}
