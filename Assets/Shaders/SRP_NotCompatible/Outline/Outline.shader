Shader "Chimp/VFX/Outline"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        [Space(10)]
        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _OutlineThickness ("Outline Thickness", Range(0.0, 0.2)) = 0.1
    }

    SubShader
    {
        // Outline
        Pass
        {
            Tags
            {
                "LightMode" = "SRPDefaultUnlit"
                "RenderType" = "Transparent"
                "Queue" = "Transparent"
            }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _MainTex_ST;

            float4 _OutlineColor;
            float _OutlineThickness;

            float4 outline(float4 positionOS, float thickness)
            {
                float4x4 scaleMatrix = float4x4
                (
                    1 + thickness,      0,                  0,                  0,
                    0,                  1 + thickness,      0,                  0,
                    0,                  0,                  1 + thickness,      0,
                    0,                  0,                  0,                  1
                );

                return mul(scaleMatrix, positionOS);
            }

            Varyings vert (Attributes input)
            {
                float4 outlinePosition = outline(float4(input.positionOS, 1.0), _OutlineThickness);

                Varyings output;
                output.positionCS = TransformObjectToHClip(outlinePosition);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);

                return output;
            }

            float4 frag (Varyings input) : SV_Target
            {
                float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);

                return float4(_OutlineColor.rgb, col.a);
            }

            ENDHLSL
        }

        // Texture
        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderType" = "Transparent"
                "Queue" = "Transparent + 1"
            }

            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _MainTex_ST;

            Varyings vert (Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);

                return output;
            }

            float4 frag (Varyings input) : SV_Target
            {
                float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
                return col;
            }

            ENDHLSL
        }

    }
}
