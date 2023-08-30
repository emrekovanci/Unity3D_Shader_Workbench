Shader "Chimp/VFX/VertexDisplacement"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        [Space(10)]
        _Speed ("Speed", Range(-5, 5)) = 0
        _Frequency ("Frequency", Float) = 0
        _Amplitude ("Amplitude", Range(0, 5)) = 1
    }

    SubShader
    {
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

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.positionCS.y += sin(input.positionOS.z * _Frequency * (_Time.y * _Speed)) * _Amplitude;
                output.positionCS.y += cos(input.positionOS.x * _Frequency * (_Time.y * _Speed)) * _Amplitude;

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
