Shader "Chimp/VFX/Teleport/Light"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Intensity ("Intensity", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent+1"
        }

        Blend SrcAlpha One // Additive

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            float _Intensity;
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
                output.uv = input.uv;

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float gradient = (1 - input.uv.y) * _Intensity;

                return float4(_Color.rgb, gradient);
            }

            ENDHLSL
        }
    }
}
