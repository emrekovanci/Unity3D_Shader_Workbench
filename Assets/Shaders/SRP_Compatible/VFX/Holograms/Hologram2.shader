Shader "Chimp/VFX/Hologram2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Hologram ("Hologram", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Frequency("Frequency", Range(1, 30)) = 1
        _Speed("Speed", Range(0,5 )) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Blend SrcAlpha One

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
                float2 huv : TEXCOORD1;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            TEXTURE2D(_Hologram);
            SAMPLER(sampler_Hologram);

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            float4 _Hologram_ST;
            float4 _Color;
            float _Frequency;
            float _Speed;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.huv = input.uv;
                output.huv.y += _Time.x * _Speed;

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv) * _Color;
                float4 holo = SAMPLE_TEXTURE2D(_Hologram, sampler_Hologram, input.huv);
                holo.a = abs(sin(input.huv.y * _Frequency));
                return col * holo;
            }

            ENDHLSL
        }
    }
}
