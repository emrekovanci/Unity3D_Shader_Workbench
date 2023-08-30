Shader "Chimp/VFX/Hologram1"
{
    Properties
    {
        [MainTexture] _BaseMap ("Texture", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1, 1, 1, 1)
        _Transparency("Transparency", Range(0.0, 0.5)) = 0.25
        _CutoutThreshold("Cutout Thresold", Range(0.0, 1.0)) = 0.2
        _Speed("Speed", Float) = 1
        _Amplitude("Amplitude", Float) = 1
        _Distance("Distance", Float) = 1
        _Amount("Amount", Range(0.0, 1.0)) = 1
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _TintColor;
            float _Transparency;
            float _CutoutThreshold;
            float _Speed;
            float _Amplitude;
            float _Distance;
            float _Amount;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            Varyings vert(Attributes input)
            {
                input.positionOS.x += sin(_Time.y * _Speed + input.positionOS.y * _Amplitude) * _Distance * _Amount;

                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
                return output;
            }

            float4 frag(Varyings input) : SV_TARGET
            {
                float4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv) + _TintColor;
                col.a = _Transparency;
                clip(col.r - _CutoutThreshold);
                return col;
            }

            ENDHLSL
        }
    }
}
