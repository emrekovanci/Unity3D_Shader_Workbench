Shader "Chimp/VFX/Valuable"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _GoldTex ("Texture", 2D) = "white" {}
        [Space(10)]
        _Range ("Gold Range", Range(1, 5)) = 1
        _Speed ("Gold Speed", Range(-1, 1)) = 0
        _Brightness ("Gold Brightness", Range(0.0, 0.5)) = 0.1
        _Saturation ("Gold Saturation", Range(0.5, 1)) = 0.5
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                "Queue" = "Geometry"
                "LightMode" = "UniversalForward"
            }

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
                float4 uvv : TEXCOORD1;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            TEXTURE2D(_GoldTex);
            SAMPLER(sampler_GoldTex);

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            float4 _GoldTex_ST;
            float _Range;
            float _Speed;
            float _Brightness;
            float _Saturation;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.uvv = computeScreenPos(output.positionCS);

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float2 coords = input.uvv.xy / input.uvv.w;
                coords.x += _Time.x * _Speed;

                float4 gol = SAMPLE_TEXTURE2D(_GoldTex, sampler_GoldTex, coords * _Range);
                float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);

                col *= gol / _Saturation;

                return col + _Brightness;
            }

            ENDHLSL
        }
    }
}
