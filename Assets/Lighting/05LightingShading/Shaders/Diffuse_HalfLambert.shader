Shader "Custom/LightingShader/Diffuse_HalfLambert"
{
    Properties
    {
        _Diffuse("Diffuse",Color) = (1,1,1,1)
        _AlphaValue("HalfLambert光照模型的α值",float)=0.5
        _BetaValue("HalfLambert光照模型的β值",float) = 0.5
    }

        SubShader
    {
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "Lighting.cginc"

            fixed4 _Diffuse;
            float _AlphaValue;
            float _BetaValue;
            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_ObjectToWorld));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldLightDir= normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * (_AlphaValue * dot(i.worldNormal, worldLightDir) + _BetaValue);
                fixed3 res = diffuse + ambient;
                return fixed4(res, 1.0);
            }
            ENDCG
        }
    }
}
