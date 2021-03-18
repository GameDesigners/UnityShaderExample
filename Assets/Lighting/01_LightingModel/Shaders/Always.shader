Shader "Custom/LightMode/Always"
{
    Properties
    {
        _tintAlways("Color of Always", Color) = (1, 0, 0, 1)
        _tintForward("Color of Forward", Color) = (0, 1, 0, 1)
        _tintDeferred("Color of Deferred", Color) = (0, 0, 1, 1)
        _dilateAlways("Dilate of Always", range(1, 3)) = 1
        _dilateForward("Dilate of Forward", range(1, 3)) = 1.2
        _dilateDederred("Dilate of Deferred", range(1, 3)) = 1.4
    }

    SubShader
    {
        Blend One One  //线性变淡？叠加

        //.Pass 1
        Pass
        {
            Tags{"LightMode" = "Always"}
            Blend One One

            CGPROGRAM

#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "Lighting.cginc"

            struct VertOut
            {
                 float4 pos : SV_POSITION;
            };

            float4 _tintAlways;
		    float4 _tintForward;
		    float4 _tintDeferred;
		    float _dilateAlways;
		    float _dilateForward;
		    float _dilateDeferred;

            VertOut vert(appdata_base v)
            {
                VertOut o;
                o.pos = UnityObjectToClipPos(v.vertex* _dilateAlways);
                return o;
            }

            float4 frag(VertOut i) : COLOR
            {
                return _tintAlways;
            }
            ENDCG
        }
    }
}
