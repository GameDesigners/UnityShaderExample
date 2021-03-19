// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "Custom/RenderPath/ForwardRendering"
{
    Properties
    {
        _Color("Color Tint",Color) = (1,1,1,1)
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8.0,256)) = 20
    }

    SubShader
    {
        //Base Pass:只处理场景中最亮的平行光
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
#pragma multi_compile_fwdbase  //此指令可以保证我们在Shader中使用光照衰减等光照变量可以被正确赋值
#pragma vertex vert
#pragma fragment frag
#include "Lighting.cginc"
            fixed4 _Color;
            fixed4 _Specular;
            float _Gloss;

            struct a2v{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldViewDir : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.vertex);
                o.worldViewDir = UnityWorldSpaceViewDir(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }


            /*
            *   光源的五个属性：位置、方向、强度、衰减
            *   平行光的衰减一般为 1
            */
            fixed4 frag(v2f i) : SV_Target{

                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldViewDir = normalize(i.worldViewDir);
                 
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));
                
                fixed3 halfDir = normalize(worldLightDir + worldViewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

                fixed atten = 1;  //平行光的衰减一般为 1
                return fixed4(ambient + (diffuse + specular) * atten, 1.0);
            }

            ENDCG
        }

        Pass
        {
            Tags{"LightMode"="ForwardAdd"}
            Blend One One  //混合到BasePass计算的光照结果上，如果没有，则会覆盖BasePass的光照
            CGPROGRAM
#pragma multi_compile_fwdadd
#pragma vertex vert
#pragma fragment frag
#include "Lighting.cginc"
#include "AutoLight.cginc"
            fixed4 _Color;
            fixed4 _Specular;
            float _Gloss;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldViewDir : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.vertex);
                o.worldViewDir = UnityWorldSpaceViewDir(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target{

                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldViewDir=normalize(i.worldViewDir);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                
                //根据光源类型获取光照方向
                #ifdef USING_DIRECTIONAL_LIGHT
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                #endif

                //根据光源类型获取光照方向
                #ifdef USING_DIRECTIONAL_LIGHT
                    fixed atten=1.0;
                #else
                    //把顶点从世界坐标转化为光源空间坐标
                    float3 lightCoord=mul(unity_WorldToLight,float4(i.worldPos,1)).xyz;

                    //dot(lightCoord, lightCoord).rr  -->  构建了一个二维矢量（dot(lightCoord, lightCoord),dot(lightCoord, lightCoord)）
                    fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                #endif

                    fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));

                    fixed3 halfDir = normalize(worldLightDir + worldViewDir);
                    fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

                    return fixed4(ambient + (diffuse + specular) * atten, 1.0);
            }


            ENDCG
        }
    }
    Fallback "Specular"
}
