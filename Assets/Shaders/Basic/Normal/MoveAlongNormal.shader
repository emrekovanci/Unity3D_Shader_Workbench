Shader "Chimp/MoveAlongNormal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", Range(1, 5)) = 1
        _Amplitude ("Amplitude", Range(1, 5)) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Cull Off

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
                float4 normal : NORMAL;
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
            float _Amplitude;
            CBUFFER_END

            float4 moveAlongNormal(float3 positionOS, float4 normalPos)
            {
                positionOS += ((cos(_Time.y * _Speed) + 1.0) * _Amplitude) * normalPos.xyz;

                return TransformObjectToHClip(positionOS);
            }

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = moveAlongNormal(input.positionOS, input.normal);
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
