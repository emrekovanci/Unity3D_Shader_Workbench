Shader "Chimp/VFX/Teleport/Dissolve"
{
    Properties
    {
        [MainTexture] _BaseMap("Texture", 2D) = "white" {}
        _DissolveMap ("Dissolve", 2D) = "white" {}
        [Space(10)]
        _DissolveColor ("Dissolve Color", Color) = (1, 1, 1, 1)
        _DissolveSmooth ("Dissolve Smooth", Range(0.0, 1.0)) = 0
        _DissolveAmount ("Dissolve Threshold", Range(0.0, 1.0)) = 1
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }

        // Color
        Pass
        {
            Tags
            {
                "LightMode" = "SRPDefaultUnlit"
            }

            Blend SrcAlpha One

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            TEXTURE2D(_DissolveMap);
            SAMPLER(sampler_DissolveMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _DissolveColor;
            float _DissolveSmooth;
            float _DissolveAmount;
            CBUFFER_END

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

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.uv = TRANSFORM_TEX(input.uv, _BaseMap);

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float dissolve = SAMPLE_TEXTURE2D(_DissolveMap, sampler_DissolveMap, input.uv).r;

                float remapped = remap(_DissolveAmount, float2(0.0, 1.0), float2(-_DissolveSmooth, 1.0));
                float smooth = smoothstep(remapped, remapped + _DissolveSmooth, dissolve);

                float4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv);
                col.a *= smooth;

                return float4(_DissolveColor.rgb, col.a);
            }

            ENDHLSL
        }

        // Texture
        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            TEXTURE2D(_DissolveMap);
            SAMPLER(sampler_DissolveMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _DissolveColor;
            float _DissolveSmooth;
            float _DissolveAmount;
            CBUFFER_END

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

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.uv = TRANSFORM_TEX(input.uv, _BaseMap);

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float dissolve = SAMPLE_TEXTURE2D(_DissolveMap, sampler_DissolveMap, input.uv).r;

                float remapped = remap(_DissolveAmount, float2(0.0, 1.0), float2(-_DissolveSmooth, 1.0));
                float smooth = smoothstep(remapped, remapped + _DissolveSmooth, dissolve);

                float4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv);
                col.a *= smooth;

                return col;
            }

            ENDHLSL
        }
    }
}
