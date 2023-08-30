Shader "Chimp/VFX/Flag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", Range(1, 5)) = 1
        _Frequency ("Frequency", Range(1, 5)) = 1
        _Amplitude ("Amplitude", Range(1, 5)) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
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

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            float _Speed;
            float _Frequency;
            float _Amplitude;
            CBUFFER_END

            float4 flag(float3 positionOS, float2 uv)
            {
                positionOS.y += sin((uv.x - (_Time.y * _Speed)) * _Frequency) * (uv.x * _Amplitude);

                return TransformObjectToHClip(positionOS);
            }

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = flag(input.positionOS, input.uv);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
                return col;
            }

            ENDHLSL
        }
    }
}
