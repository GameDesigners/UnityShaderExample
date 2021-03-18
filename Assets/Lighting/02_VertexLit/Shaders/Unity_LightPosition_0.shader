// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/LightMode/VertexLit/Unity_LightPosition_0"
{
    Properties
    {
        _Color("Base Color",Color) = (1,1,1,1)
        _LightType("Light Type",int) = 0
    }

        SubShader
    {
        Pass
        {
            Tags{"LightMode" = "Vertex"}
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "Lighting.cginc"

            uniform float4 _Color;
            uniform int _LightType;
            
            struct vertOut
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            vertOut vert(appdata_base v)
            {
                int lightType = 0;
                if (_LightType >= 0 && _LightType <= 3)
                    lightType = _LightType;
                float3 viewPos = UnityObjectToViewPos(v.vertex).xyz;
                float viewN = mul((float3x3)UNITY_MATRIX_IT_MV, v.vertex).xyz;
                float3 lightColor = UNITY_LIGHTMODEL_AMBIENT.xyz;

                float3 toLight = unity_LightPosition[lightType].xyz - viewPos.xyz * unity_LightPosition[lightType].w;
                float lengthSq = dot(toLight, toLight);
                float atten = 4.0 / (1.0 + lengthSq * unity_LightAtten[lightType].z);
                float diff = max(0, dot(viewN, normalize(toLight)));
                lightColor += unity_LightColor[lightType].rgb * (diff * atten);

                vertOut o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = float4(lightColor, 1) * _Color;
                return o;
            }

            float4 frag(vertOut i) : COLOR
            {
                return i.color;
            }
            ENDCG
        }
    }
}
